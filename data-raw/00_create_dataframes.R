
library(dplyr)
library(fs)
library(readr)


# Read all header csvs ----------------------------------------------------

header_loc <- fs::dir_ls(here::here("data-raw/01_clean_header"))
lst_headers <- purrr::map(header_loc, readr::read_csv)


headers_names <- fs::dir_ls(here::here("data-raw/01_clean_header")) |>
  fs::path_file() |>
  stringr::str_replace("D_", "") |>
  stringr::str_replace("_2018", "") |>
  stringr::str_replace(".csv", "")

names(lst_headers) <- headers_names

headers <- purrr::map(lst_headers, dplyr::pull, "var_name")

headers <- headers[order(names(headers))]

# Read all dataframe TXT files --------------------------------------------

all_dfs <- fs::dir_ls(here::here("data-raw/02_raw_data"))

dfs <- purrr::map(all_dfs, readr::read_csv, col_names=F)

df_names <- all_dfs |> fs::path_file() |>
  stringr::str_extract("[^_]*")

names(dfs) <- df_names

dfs <- dfs[order(names(dfs))]

# Apply header names to dataframes ----------------------------------------

core_data <- purrr::map2(dfs,  headers, setNames)

usethis::use_data(core_data, overwrite = TRUE)
