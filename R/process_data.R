download_data(
  year = 2023,
  month = 9,
  dest = "data-raw/2023_09"
)

# Description
description_files <- list.files(
  path = "data-raw/2023_09",
  pattern = "^D_",
  full.names = TRUE
)

descriptions <- vector("list", length(description_files))

for (i in seq_along(description_files)) {

  raw_text <- readLines(description_files[[i]]) |>
    paste0(collapse = " ") |>
    utf8::utf8_encode() |>
    stringr::str_replace_all("\\\\t", " ") |>
    stringr::str_replace_all(" numeric ", " Numeric ") |>
    # Remove "** NOTE"
    stringr::str_replace_all("\\*\\*\\s+NOTE.*$", "") |>
    # Consider ** a component of ColumnName
    stringr::str_replace_all("\\*\\*\\s+", "\\*\\*")

  descriptions[[i]] <- gsub("(\\*\\*)?\\b(\\w+)(?=(\\s+Alphanum\\.|\\s+Numeric))", "\n\\1\\2", raw_text, perl = TRUE) |>
    stringr::str_split("\n") |>
    unlist() |>
    tibble::as_tibble() |>
    dplyr::slice(-1) |>
    tidyr::separate(value, into = c("ColumnName", "ColumnType", "DecimalPosition", "Definition"), sep = "\\s+", extra = "merge") |>
    dplyr::mutate(
      MultipleOccurranceColumn = stringr::str_detect(ColumnName, "^\\*\\*"),
      CodeColumn = cumsum(MultipleOccurranceColumn) == 1,
      Definition = stringr::str_replace_all(Definition, "\\s+", " ") |>
        stringr::str_trim(),
      ColumnName = stringr::str_replace_all(ColumnName, "\\*\\*", "")
    )

}

description_files <- description_files |>
  # Remove the last instance of "_NUMBER" before the ".TXT" extension
  # Data files are missing that component in the name
  sub(
    pattern = "_[0-9]+(?=\\.TXT$)",
    replacement = "",
    x = _,
    perl = TRUE
  )

names(descriptions) <- basename(tools::file_path_sans_ext(description_files))

# Data
data <- purrr::imap(descriptions, .f = function(metadata, filename) {

  data_name <- gsub("D_", "", filename)

  data_filepath <- list.files(
    path = "data-raw/2023_09",
    pattern = paste0("^", data_name, "_"),
    full.names = TRUE
  )

  if (data_name %in% c("RCR7")) {

    code_column <- metadata |>
      dplyr::filter(CodeColumn == TRUE) |>
      dplyr::pull(ColumnName)

    codes <- get(paste0(data_name, "__", code_column))

    n_codes <- nrow(codes)

    # Read the content of the file into a vector
    lines <- readLines(data_filepath)

    # Create a new vector to store the collapsed lines
    collapsed_lines <- character()

    # Loop through the lines, collapsing every N_CODES + 2 lines
    for (i in seq(1, length(lines), by = (n_codes + 2))) {
      chunk <- lines[i:min(i + (n_codes + 2 - 1), length(lines))]
      collapsed_lines <- c(collapsed_lines, paste(chunk, collapse = ""))
    }

    data <- read.table(text = collapsed_lines, sep = ",", header = FALSE)

  } else {

    # I use read.csv instead of readr::read_csv to avoid having to specify
    # column types (which is not straightforward and read.csv defaults are
    # working as expected identifying integers and character types)
    data <- read.csv(
      file = data_filepath,
      header = FALSE
    ) |>
      tibble::as_tibble()

  }

  if (ncol(data) == nrow(metadata)) {

    names(data) <- metadata$ColumnName

  } else {

    single_occurrance_columns <- metadata |>
      dplyr::filter(MultipleOccurranceColumn == FALSE) |>
      dplyr::pull(ColumnName)

    multiple_occurrance_columns <- metadata |>
      dplyr::filter(MultipleOccurranceColumn == TRUE) |>
      dplyr::pull(ColumnName)

    n_single_occurrance_columns <- length(single_occurrance_columns)

    n_multiple_occurrance_columns <- length(multiple_occurrance_columns)


    multiple_single_occurance_columns_sets <- length(rle(metadata$MultipleOccurranceColumn)$lengths) > 2


    code_column <- metadata |>
      dplyr::filter(CodeColumn == TRUE) |>
      dplyr::pull(ColumnName)

    codes <- get(paste0(data_name, "__", code_column))

    n_codes <- nrow(codes)

    if (multiple_single_occurance_columns_sets == TRUE) {

      column_names <- c(
        intersect(single_occurrance_columns,  metadata |> dplyr::filter(cumsum(CodeColumn) == 0) |> dplyr::pull(ColumnName)),
        do.call(paste0, expand.grid(multiple_occurrance_columns, paste0("__", 1:n_codes))),
        intersect(single_occurrance_columns,  metadata |> dplyr::filter(cumsum(CodeColumn) > 0) |> dplyr::pull(ColumnName))
      )

    } else {

      column_names <- c(
        single_occurrance_columns,
        do.call(paste0, expand.grid(multiple_occurrance_columns, paste0("__", 1:n_codes)))
      )

    }

    expected_n_columns <- n_single_occurrance_columns + n_multiple_occurrance_columns * n_codes

    if (expected_n_columns == ncol(data)) {


      names(data) <- column_names

      data <- data |>
        tidyr::pivot_longer(cols = -dplyr::all_of(single_occurrance_columns)) |>
        dplyr::mutate(ID = stringr::str_extract(name, "\\d+$"), .after = UNINUM) |>
        dplyr::mutate(name = stringr::str_replace_all(name, "__\\d+$", "")) |>
        tidyr::pivot_wider(names_from = name, values_from = value) |>
        dplyr::select(-ID)
    }

  }

  data

})
