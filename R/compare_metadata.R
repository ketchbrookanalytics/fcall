#' Compare FCA Call Report metadata files between two folders
#'
#' @description
#' `compare_metadata()` compares the content of the metadata files (files that
#' start with "D_") between two specified folders containing FCA Call Report
#' data (from two different quarters).
#'
#' @param dir1 (String) The path to a folder containing FCA Call Report .TXT
#'   files for a single quarter
#' @param dir2 (String) The path to a folder containing FCA Call Report .TXT
#'   files for a (different) single quarter
#'
#' @return
#' A list containing information about differences in file names, file order,
#' and content differences between the metadata files in `dir1` and `dir2`
#'
#' @details
#' `compare_metadata()` lists metadata files in each folder, identifies shared
#' metadata files, and then compares (a) the number of files, (b) file names,
#' (c) file order, and (d) file content (using the `waldo::compare()` function).
#'
#' @export
#'
#' @examples
#' \donttest{
#'
#'   # Download data from September 2025
#'   path_1 <- tempfile("fcadata1")
#'   dir.create(path_1)
#'
#'   download_data(
#'     year = 2025,
#'     month = 9,
#'     dest = path_1
#'   )
#'
#'   # Download data from September 2011
#'   path_2 <- tempfile("fcadata2")
#'   dir.create(path_2)
#'
#'   download_data(
#'     year = 2011,
#'     month = 9,
#'     dest = path_2
#'   )
#'
#'   compare_metadata(path_1, path_2)
#'
#' }
compare_metadata <- function(dir1, dir2) {

  # Ensure same folder wasn't supplied to both arguments
  if (identical(dir1, dir2)) {
    rlang::abort("`dir1` and `dir2` are identical; nothing to compare")
  }

  # List files in each folder
  files1 <- list.files(dir1)
  files2 <- list.files(dir2)

  # Subset metadata files (those that start with D_)
  metadata_files1 <- files1[stringr::str_detect(files1, "^D_")]
  metadata_files2 <- files2[stringr::str_detect(files2, "^D_")]

  # Find differences in files amount, names and order
  file_differences <- waldo::compare(
    x = metadata_files1,
    y = metadata_files2,
    x_arg = "dir1",
    y_arg = "dir2",
    max_diffs = Inf
  )

  # List shared metadata files
  shared_metadata_files <- intersect(
    x = metadata_files1,
    y = metadata_files2
  )

  # Find content differences
  content_differences <- purrr::map(
    .x = shared_metadata_files,
    .f = function(x) compare_files_content(x, dir1, dir2)
  )

  names(content_differences) <- shared_metadata_files

  # Keep files with content differences
  content_differences <- purrr::keep(
    .x = content_differences,
    .p = function(x) length(x) > 0
  )

  return(
    list(
      file_differences = file_differences,
      content_differences = content_differences
    )
  )

}



#' Compare content of a specific file between two folders
#'
#' `compare_files_content()` reads the content of a specified file from two
#' folders and compares the content using the `waldo::compare` function. It
#' identifies any differences in the content and returns the comparison results.
#'
#' @param filename A character string specifying the name of the file to
#'   compare.
#' @param dir1 A character string specifying the path to the first folder.
#' @param dir2 A character string specifying the path to the second folder.
#'
#' @return A list containing information about differences in the content of the
#'   specified file.
#'
#' @details `compare_files_content()` reads the content of the specified file
#'   from both folders using `readLines()`, and compares the content using the
#'   `waldo::compare()` function.
compare_files_content <- function(filename, dir1, dir2) {

  content1 <- readLines(file.path(dir1, filename), warn = FALSE) |>
    iconv(from = "windows-1252", to = "utf-8")
  content2 <- readLines(file.path(dir2, filename), warn = FALSE) |>
    iconv(from = "windows-1252", to = "utf-8")

  differences <- waldo::compare(
    x = content1,
    y = content2,
    x_arg = "dir1",
    y_arg = "dir2",
    max_diffs = Inf
  )

  return(differences)

}
