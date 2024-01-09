process_data <- function(folder) {

  # List all files in folder
  files <- list.files(folder)

  # List metadata files (those that start with D_)
  metadata_files <- files[stringr::str_detect(files, "^D_")]

  # List data files
  data_files <- setdiff(files, metadata_files)

  # Store file root names (all characters until first underscore occurrence)
  data_root_names <- sub("^(.*?)_.*$", "\\1", data_files)

  # Process metadata files
  metadata <- purrr::map(metadata_files, function(metadata_filename) {
    process_metadata_file(here::here(folder, metadata_filename))
  })

  names(metadata) <- data_root_names

  # Assuming that metadata and data files have the same sorting...

  # Process data files
  data <- purrr::map2(data_files, metadata, function(data_filename, metadata) {

    data_name <- sub("^(.*?)_.*$", "\\1", data_filename)

    process_data_file(
      filepath = here::here(folder, data_filename),
      metadata = metadata,
      codes_dict = get_codes_dict(data_name)
    )
  })

  names(data) <- data_root_names

  return(
    list(
      data = data,
      metadata = metadata
    )
  )
}

process_metadata_file <- function(filepath) {

  raw_text <-
    # Read text lines from file
    readLines(filepath, warn = FALSE) |>
    # Create a single string by concatenating each line
    paste0(collapse = " ") |>
    # Encode object.
    # Some characters in files where throwing an error due to its encoding.
    utf8::utf8_encode() |>
    # Replace tabs with single space.
    # This is necessary because tabs do not separate words as needed.
    stringr::str_replace_all("\\\\t", " ") |>
    # Field Type is either "Numeric" or "Alphanum.", but I found one instance
    # in which is expressed as "numeric". In order to be properly captured by
    # the regular expression I capitalize the "n". As of writing these lines,
    # I can't guarantee that the process won't fail if "numeric" word is used
    # in variable descriptions.
    stringr::str_replace_all(" numeric ", " Numeric ") |>
    # Remove NOTE string from the end of the file. A variable named NOTE would
    # cause the processing to not work as expected, but it is highly unlikely
    # for a variable to be called NOTE.
    stringr::str_replace_all("\\*\\*\\s+NOTE.*$", "") |>
    # Remove blank spaces between double asterisks and variable names. This is
    # done to temporary consider the double asterisk a part of variable name.
    stringr::str_replace_all("\\*\\*\\s+", "\\*\\*")

  vars_info <-
    # Use regular expression to add a newline before words that are followed by
    # either "Numeric" or "Alphanum.". The case where a double asterisk is part
    # of the variable name is also considered.
    gsub(
      pattern = "(\\*\\*)?\\b(\\w+)(?=(\\s+Alphanum\\.|\\s+Numeric))",
      replacement = "\n\\1\\2",
      x = raw_text,
      perl = TRUE
    ) |>
    # Split string
    stringr::str_split("\n") |>
    # Flatten the list
    unlist() |>
    # Convert to a tibble with a single column
    tibble::as_tibble() |>
    # Remove the header row which does not contain variable information
    dplyr::slice(-1) |>
    # Separate strings into columns. This is possible because variable names and
    # field type are a single word.
    tidyr::separate(
      col = value,
      into = c("ColumnName", "ColumnType", "DecimalPosition", "Definition"),
      sep = "\\s+",
      extra = "merge"
    ) |>
    dplyr::mutate(
      # Use double asterisks to identify multiple occurrence columns
      MultipleOccurrenceColumn = stringr::str_detect(ColumnName, "^\\*\\*"),
      # Set the first multiple occurrence column as the code column
      CodeColumn = cumsum(MultipleOccurrenceColumn) == 1,
      # Clean Definition column by removing white spaces
      Definition = Definition |>
        stringr::str_replace_all("\\s+", " ") |>
        stringr::str_trim(),
      # Remove double asterisk from variable names
      ColumnName = stringr::str_replace_all(ColumnName, "\\*\\*", ""),
      # Express column type as expected in PostgreSQL
      ColumnTypeSQL = dplyr::case_when(
        ColumnType == "Alphanum." ~ "text",
        ColumnType == "Numeric" & DecimalPosition == 0 ~ "integer",
        ColumnType == "Numeric" & DecimalPosition > 0 ~ "float"
      )
    )

  # Determine the scenario that metadata belongs to.
  scenario <- switch (length(rle(vars_info$MultipleOccurrenceColumn)$lengths),
    "1" = "single",
    "2" = "single_multiple",
    "3" = "single_multiple_single"
  )

  return(
    list(
      scenario = scenario,
      vars_info = vars_info
    )
  )

}

process_data_file <- function(filepath, metadata, codes_dict = NULL) {

  data <- read_data_file(filepath, metadata, codes_dict)

  if (metadata$scenario == "single") {

    names(data) <- metadata$vars_info$ColumnName

  } else {

    single_occurrence_columns <- metadata$vars_info |>
      dplyr::filter(MultipleOccurrenceColumn == FALSE) |>
      dplyr::pull(ColumnName)

    multiple_occurrence_columns <- metadata$vars_info |>
      dplyr::filter(MultipleOccurrenceColumn == TRUE) |>
      dplyr::pull(ColumnName)

    n_codes <- nrow(codes_dict)

    if (metadata$scenario == "single_multiple") {

      column_names <- c(

        # Single occurrence columns
        single_occurrence_columns,

        # Multiple occurrence columns
        do.call(
          paste0,
          expand.grid(
            multiple_occurrence_columns,
            paste0("__", 1:n_codes)
          )
        )

      )

    } else if (metadata$scenario == "single_multiple_single") {

      column_names <- c(

        # First set of single occurrence columns
        intersect(
          single_occurrence_columns,
          metadata$vars_info |>
            dplyr::filter(cumsum(CodeColumn) == 0) |>
            dplyr::pull(ColumnName)
        ),

        # Multiple occurrence columns
        do.call(
          paste0,
          expand.grid(
            multiple_occurrence_columns,
            paste0("__", 1:n_codes)
          )
        ),

        # Second set of single occurrence columns
        intersect(
          single_occurrence_columns,
          metadata$vars_info |>
            dplyr::filter(cumsum(CodeColumn) > 0) |>
            dplyr::pull(ColumnName)
        )
      )

    }

    names(data) <- column_names

    data <- data |>
      tidyr::pivot_longer(cols = -dplyr::all_of(single_occurrence_columns)) |>
      dplyr::mutate(ID = stringr::str_extract(name, "\\d+$"), .after = UNINUM) |>
      dplyr::mutate(name = stringr::str_replace_all(name, "__\\d+$", "")) |>
      tidyr::pivot_wider(names_from = name, values_from = value) |>
      dplyr::select(-ID)

  }

  return(data)

}

read_data_file <- function(filepath, metadata, codes_dict) {

  if (metadata$scenario %in% c("single", "single_multiple")) {

    # I use read.csv instead of readr::read_csv to avoid having to specify
    # column types (which is not straightforward and read.csv defaults are
    # working as expected identifying integers and character types)
    data <- read.csv(file = filepath, header = FALSE) |>
      tibble::as_tibble()

  } else if (metadata$scenario == "single_multiple_single") {

    n_codes <- nrow(codes_dict)

    # Read the content of the file into a vector
    lines <- readLines(filepath, warn = FALSE)

    # Create a new vector to store the collapsed lines
    collapsed_lines <- character()

    # Loop through the lines, collapsing every (N_CODES + 2) lines
    for (i in seq(1, length(lines), by = (n_codes + 2))) {
      chunk <- lines[i:min(i + (n_codes + 2 - 1), length(lines))]
      collapsed_lines <- c(collapsed_lines, paste(chunk, collapse = ""))
    }

    data <- read.table(text = collapsed_lines, sep = ",", header = FALSE)

  }

  return(data)

}

get_codes_dict <- function(data_name) {

  # Get list of internal .rda files
  internal_data <- utils::data(package = "fcacallr")$results[, "Item"]

  # Get codes dict based on data name and naming convention
  codes_dict_name <- internal_data[
    stringr::str_detect(
      string = internal_data,
      pattern = glue::glue("^{ data_name }__"))
  ]

  # Get codes dict (if exists)
  tryCatch(
    expr = get(codes_dict_name),
    error = function(error) NULL
  )
}
