

library(dplyr)
library(readr)

LOC <- "/home/brad/Desktop/2022September"

read_them <- function(file) {
  
  readr::read_fwf(file,
                  skip = 7,
                  skip_empty_rows = T,
                  fwf_cols(var_name = c(1, 17),
                           field_type = c(18, 26),
                           dec_pos = c(30,32),
                           var_desc = c(33,47)
                  ))
  
}



all_files <- fs::dir_ls(LOC)
header_files <- all_files |> 
  purrr::keep(~stringi::stri_detect(.x, regex='D_R') |
                stringi::stri_detect(.x, regex='D_INST'))

all_dfs <- header_files |> 
  purrr::map(read_them)

names(all_dfs) <- fs::path_file(header_files)  
