#' Process data in a specified folder
#'
#' This function processes data files and their corresponding metadata files
#' in a given folder. It extracts information from metadata files (prefixed with
#' "D_") and applies the extracted metadata to process the associated data files.
#'
#' @param folder A character string specifying the path to the folder containing
#'   the data and metadata files.
#'
#' @return A list containing processed data and metadata.
#'
#' @details The function assumes that metadata and data files share a common
#' root name (characters until the first underscore occurrence) and that
#' metadata and data files are sorted in the same order.
#'
#' @export
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
      codes_dict = get_codes_dict(data_name)$codes_dict
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

#' Process metadata file to extract variable information
#'
#' This function reads a metadata file and extracts information about variables,
#' including column names, column types, decimal positions, and variable definitions.
#' It performs necessary preprocessing steps to handle encoding issues and ensure
#' proper extraction.
#'
#' @param filepath A character string specifying the path to the metadata file.
#'
#' @return A list containing the scenario (e.g., "single", "single_multiple",
#'   "single_multiple_single") and a tibble with variable information.
#'
#' @details The function processes metadata files following specific rules to handle
#' encoding, remove unnecessary information, and extract variable details. It detects
#' the scenario based on the occurrence of double asterisks in variable names.
#'
#' @export
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

#' Process a data file using metadata and codes dictionary
#'
#' This function reads a data file, applies the provided metadata and codes dictionary,
#' and organizes the data into a tidy format. The column names are determined based on
#' the metadata scenario (e.g., "single", "single_multiple", "single_multiple_single").
#'
#' @param filepath A character string specifying the path to the data file.
#' @param metadata A list containing the scenario and variable information obtained
#'   from the metadata file using \code{\link{process_metadata_file}}.
#' @param codes_dict An optional data frame containing codes dictionary information.
#'
#' @return A tibble containing the processed data in a tidy format.
#'
#' @details The function processes the data file according to the metadata scenario.
#' It handles cases where variables have multiple occurrences and organizes the data
#' into a tidy format with appropriate column names. The function relies on the
#' \code{\link{read_data_file}} function for the actual data reading.
#'
#' @export
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

#' Read and process a data file based on metadata and codes dictionary
#'
#' This function reads a data file and processes it based on the provided metadata
#' and codes dictionary. The processing depends on the metadata scenario, which
#' includes cases like "single," "single_multiple," and "single_multiple_single."
#' For certain scenarios, the function utilizes \code{read.csv} to infer column
#' types without explicit specification.
#'
#' @param filepath A character string specifying the path to the data file.
#' @param metadata A list containing the scenario and variable information obtained
#'   from the metadata file using \code{\link{process_metadata_file}}.
#' @param codes_dict A data frame containing codes dictionary information.
#'
#' @return A tibble containing the processed data.
#'
#' @details The function reads the data file and applies necessary processing based
#' on the metadata scenario. For scenarios like "single" and "single_multiple," it
#' uses \code{read.csv} for convenient type inference. For "single_multiple_single,"
#' it reads the file line by line, collapses every (N_CODES + 2) lines, and then reads
#' the collapsed lines using \code{read.table}.
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

#' Retrieve codes dictionary for a specified data name
#'
#' This function searches for an internal .rda file in the specified package
#' and retrieves the codes dictionary based on the provided data name and naming
#' convention. The naming convention is assumed to include the data name followed
#' by a double underscore "__". If the codes dictionary is found, it is returned;
#' otherwise, a NULL value is returned.
#'
#' @param data_name A character string specifying the data name to retrieve the
#'   codes dictionary for.
#'
#' @return A list with the codes dictionary (\code{codes_dict}) and the associated
#' variable name (\code{codes_varname}) if found, otherwise each element will be NULL.
#'
#' @details The function uses the provided data name to construct the expected
#' naming convention and searches for an internal .rda file in the specified package.
#' If found, it attempts to retrieve the codes dictionary using \code{get} and returns
#' it; otherwise, it returns NULL.
get_codes_dict <- function(data_name) {

  # Get list of internal .rda files
  internal_data <- utils::data(package = "fcacallr")$results[, "Item"]

  # Get codes dict based on data name and naming convention
  codes_dict_name <- internal_data[
    stringr::str_detect(
      string = internal_data,
      pattern = glue::glue("^{ data_name }__"))
  ]

  # Set initial values as NULL (these values represent data without codes)
  codes_dict <- NULL
  codes_varname <- NULL

  # Get corresponding information when data has codes
  if (length(codes_dict_name) > 0) {

    codes_dict <- get(codes_dict_name)

    codes_varname <- gsub(
      pattern = ".*__",
      replacement = "",
      x = codes_dict_name
    )

  }

  # Return objects
  return(
    list(
      codes_dict = codes_dict,
      codes_varname = codes_varname
    )
  )

}
