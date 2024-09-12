#' Process FCA Call Report data in a specified folder
#'
#' @description
#' `process_data()` reads the downloaded (and unzipped) .TXT files into tidy
#' data frames, applying the schema from the "D_" files to the corresponding raw
#' comma-separated data files, as well as storing the metadata from the "D_"
#' files
#'
#' @param dir (String) The path to a folder containing FCA Call Report .TXT
#'   files for a single quarter
#'
#' @return A list containing processed data and metadata.
#'
#' @details
#' `process_data()` assumes that metadata and data files share a common root
#' name (characters until the first underscore occurrence).
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#'   path <- tempfile("fcadata")
#'
#'   download_data(
#'     year = 2022,
#'     month = "December",
#'     dest = path
#'   )
#'
#'   processed_data <- process_data(path)
#'
#'   # Access "RCB" data
#'   processed_data$data$RCB
#'
#'   # Access "RCB" metadata
#'   processed_data$metadata$RCB
#'
#' }
process_data <- function(dir) {

  # List all files in folder
  files <- list.files(dir)

  # List metadata files (those that start with D_)
  metadata_files <- files[stringr::str_detect(files, "^D_")]

  # Store file root names
  data_root_names <- metadata_files |>
    # Remove file extension
    stringr::str_replace(pattern = "\\.TXT", replacement = "") |>
    # Remove D_ name convention of metadata files
    stringr::str_replace(pattern = "^D_", replacement = "") |>
    # Removal of unneeded characters in RCI* files
    # These files contain an additional _YEAR that is not match in data filenames
    stringr::str_replace(pattern = "^(.*?)_.*$", replacement = "\\1")

  # Process metadata files
  metadata <- purrr::map(metadata_files, function(metadata_filename) {
    process_metadata_file(file.path(dir, metadata_filename))
  })

  names(metadata) <- data_root_names

  # Process data files
  data <- purrr::imap(metadata, function(metadata, data_root_name) {

    # Get corresponding data file based on name matching
    data_filename <- files[grepl(pattern = paste0("^", data_root_name, "_"), x = files)]

    process_data_file(
      file = file.path(dir, data_filename),
      metadata = metadata,
      dict = get_codes_dict(data_root_name)$codes_dict
    )
  })

  return(
    list(
      data = data,
      metadata = metadata
    )
  )
}

#' Process metadata file to extract variable information
#'
#' @description
#' `process_metadata_file()` reads a metadata file and extracts information
#' about the column names, column types, decimal positions, and variable
#' definitions.
#'
#' @param file (String) The path to the metadata file.
#'
#' @return A list containing the scenario (e.g., `"single"`, `"single_multiple"`,
#'   `"single_multiple_single"`) and a tibble with variable information.
#'
#' @details
#' `process_metadata_file()` processes metadata files following specific rules
#' to handle encoding, remove unnecessary information, and extract variable
#' details. It detects the scenario based on the occurrence of double asterisks
#' in variable names.
#'
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#'   path <- tempfile("fcadata")
#'
#'   download_data(
#'     year = 2022,
#'     month = "December",
#'     dest = path
#'   )
#'
#'   process_metadata_file(file.path(path, "D_RC1.TXT"))
#'
#' }
process_metadata_file <- function(file) {

  raw_text <-
    # Read text lines from file
    readLines(file, warn = FALSE) |>
    # Create a single string by concatenating each line
    paste0(collapse = " ") |>
    # Convert encoding
    iconv(from = "windows-1252", to = "utf-8") |>
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
      col = "value",
      into = c("ColumnName", "ColumnType", "DecimalPosition", "Definition"),
      sep = "\\s+",
      extra = "merge"
    ) |>
    dplyr::mutate(
      # Use double asterisks to identify multiple occurrence columns
      MultipleOccurrenceColumn = stringr::str_detect(.data$ColumnName, "^\\*\\*"),
      # Set the first multiple occurrence column as the code column
      CodeColumn = cumsum(.data$MultipleOccurrenceColumn) == 1,
      # Clean Definition column by removing white spaces
      Definition = .data$Definition |>
        stringr::str_replace_all("\\s+", " ") |>
        stringr::str_trim(),
      # Remove double asterisk from variable names
      ColumnName = stringr::str_replace_all(.data$ColumnName, "\\*\\*", ""),
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
#' `process_data_file()` reads a data file, applies the provided metadata and codes dictionary,
#' and organizes the data into a tidy format. The column names are determined based on
#' the metadata scenario (e.g., `"single"`, `"single_multiple"`, `"single_multiple_single"`).
#'
#' @param file (String) The path to the data file
#' @param metadata A list containing the scenario and variable information
#'   obtained from the metadata file using \code{\link{process_metadata_file}}.
#' @param dict (Optional) A data frame containing codes dictionary information
#'
#' @return A tibble containing the processed data in a tidy format
#'
#' @details
#' `process_data_file()` processes the data file according to the metadata scenario.
#' It handles cases where variables have multiple occurrences and organizes the data
#' into a tidy format with appropriate column names. The function relies on the
#' \code{\link{read_data_file}} function for the actual data reading.
#'
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#'   path <- tempfile("fcadata")
#'
#'   download_data(
#'     year = 2022,
#'     month = "March",
#'     dest = path
#'   )
#'
#'   process_data_file(
#'     file = file.path(path, "RCB_Q202203_G20220808.TXT"),
#'     metadata = process_metadata_file(file.path(path, "D_RCB.TXT")),
#'     dict = RCB__INV_CODE
#'   )
#'
#' }
process_data_file <- function(file, metadata, dict = NULL) {

  data <- read_data_file(file, metadata, dict)

  if (metadata$scenario == "single") {

    names(data) <- metadata$vars_info$ColumnName

  } else {

    single_occurrence_columns <- metadata$vars_info |>
      dplyr::filter(.data$MultipleOccurrenceColumn == FALSE) |>
      dplyr::pull("ColumnName")

    multiple_occurrence_columns <- metadata$vars_info |>
      dplyr::filter(.data$MultipleOccurrenceColumn == TRUE) |>
      dplyr::pull("ColumnName")

    n_codes <- nrow(dict)

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
            dplyr::filter(cumsum(.data$CodeColumn) == 0) |>
            dplyr::pull("ColumnName")
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
            dplyr::filter(cumsum(.data$CodeColumn) > 0) |>
            dplyr::pull("ColumnName")
        )
      )

    }

    names(data) <- column_names

    data <- data |>
      tidyr::pivot_longer(cols = -dplyr::all_of(single_occurrence_columns)) |>
      dplyr::mutate(
        ID = stringr::str_extract(.data$name, "\\d+$"),
        .after = "UNINUM"
      ) |>
      dplyr::mutate(name = stringr::str_replace_all(.data$name, "__\\d+$", "")) |>
      tidyr::pivot_wider(
        names_from = "name",
        values_from = "value"
      ) |>
      dplyr::select(-"ID")

  }

  return(data)

}

#' Read a data file based on metadata and codes dictionary
#'
#' `read_data_file()` reads a data file and processes it based on the provided metadata
#' and codes dictionary. The processing depends on the metadata scenario, which
#' includes cases like `"single"`, `"single_multiple"`, and `"single_multiple_single"`.
#' For certain scenarios, the function utilizes `read.csv` to infer column
#' types without explicit specification.
#'
#' @param file A character string specifying the path to the data file.
#' @param metadata A list containing the scenario and variable information obtained
#'   from the metadata file using \code{\link{process_metadata_file}}.
#' @param dict A data frame containing codes dictionary information.
#'
#' @return A tibble containing the processed data.
#'
#' @details
#' `read_data_file()` reads the data file and applies necessary processing based
#' on the metadata scenario. For scenarios like `"single"` and `"single_multiple"`, it
#' uses `read.csv` for convenient type inference. For `"single_multiple_single"`,
#' it reads the file line by line, collapses every `(N_CODES + 2)` lines, and then reads
#' the collapsed lines using `read.table`.
read_data_file <- function(file, metadata, dict) {

  if (metadata$scenario %in% c("single", "single_multiple")) {

    # I use read.csv instead of readr::read_csv to avoid having to specify
    # column types (which is not straightforward and read.csv defaults are
    # working as expected identifying integers and character types)
    data <- utils::read.csv(file = file, header = FALSE) |>
      tibble::as_tibble()

  } else if (metadata$scenario == "single_multiple_single") {

    n_codes <- nrow(dict)

    # Read the content of the file into a vector
    lines <- readLines(file, warn = FALSE)

    # Create a new vector to store the collapsed lines
    collapsed_lines <- character()

    # Loop through the lines, collapsing every (N_CODES + 2) lines
    for (i in seq(1, length(lines), by = (n_codes + 2))) {
      chunk <- lines[i:min(i + (n_codes + 2 - 1), length(lines))]
      collapsed_lines <- c(collapsed_lines, paste(chunk, collapse = ""))
    }

    data <- utils::read.table(text = collapsed_lines, sep = ",", header = FALSE)

  }

  return(data)

}

#' Retrieve dictionary of lookup codes for a specified dataset name
#'
#' `get_codes_dict()` searches for an internal .rda file in the specified package
#' and retrieves the codes dictionary based on the provided data name and naming
#' convention. The naming convention is assumed to include the data name followed
#' by a double underscore "__".
#'
#' @param data_name A character string specifying the data name to retrieve the
#'   codes dictionary for.
#'
#' @return A list with the codes dictionary (`codes_dict`) and the associated
#' variable name (`codes_varname`) if found, otherwise each element will be NULL.
#'
#' @details
#' `get_codes_dict()` uses the provided data name to construct the expected naming
#' convention and searches for an internal .rda file in the specified package.
#' If found, it attempts to retrieve the codes dictionary using `get` and returns
#' it; otherwise, it returns NULL.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#'   rcb_dict <- get_codes_dict("RCB")
#'
#'   # Access codes dictionary
#'   rcb_dict$codes_dict
#'
#'   # Access the name of the variable that stores the codes
#'   rcb_dict$codes_varname
#'
#' }
get_codes_dict <- function(data_name) {

  # Get list of internal .rda files
  internal_data <- utils::data(package = "fcall")$results[, "Item"]

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
