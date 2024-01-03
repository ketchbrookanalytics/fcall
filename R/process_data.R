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
    stringr::str_replace_all(" numeric ", " Numeric ")

  descriptions[[i]] <- gsub("\\b(\\w+)(?=(\\s+Alphanum\\.|\\s+Numeric))", "\n\\1", raw_text, perl = TRUE) |>
    stringr::str_split("\n") |>
    unlist() |>
    tibble::as_tibble() |>
    dplyr::slice(-1) |>
    tidyr::separate(value, into = c("ColumnName", "ColumnType", "DecimalPosition", "Definition"), sep = "\\s+", extra = "merge") |>
    dplyr::mutate(Definition = stringr::str_replace_all(Definition, "\\s+", " ") |>
                    stringr::str_trim())

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

  data_filepath <- list.files(
    path = "data-raw/2023_09",
    pattern = paste0("^", gsub("D_", "", filename), "_"),
    full.names = TRUE
  )

  data <- read.csv(
    file = data_filepath,
    header = FALSE
  )

  if (ncol(data) == nrow(metadata)) {
    names(data) <- metadata$ColumnName
  } else {
    # browser()
  }

  data

})
