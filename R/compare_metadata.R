#' Compare metadata files between two folders
#'
#' This function compares metadata files between two specified folders. It identifies
#' differences in the number of files, file names, and their order. Additionally, it
#' compares the content of shared metadata files to identify any differences.
#'
#' @param folder1 A character string specifying the path to the first folder.
#' @param folder2 A character string specifying the path to the second folder.
#'
#' @return A list containing information about differences in file names, file order,
#'   and content differences for shared metadata files.
#'
#' @details The function lists metadata files in each folder, identifies shared metadata
#' files, and then compares the number of files, file names, and their order using the
#' \code{waldo::compare} function. It further compares the content of shared metadata
#' files using the \code{compare_files_content} function.
#'
#' @export
compare_metadata <- function(folder1, folder2) {

  # List files in each folder
  files1 <- list.files(folder1)
  files2 <- list.files(folder2)

  # Subset metadata files (those that start with D_)
  metadata_files1 <- files1[stringr::str_detect(files1, "^D_")]
  metadata_files2 <- files2[stringr::str_detect(files2, "^D_")]

  # Find differences in files amount, names and order
  file_differences <- waldo::compare(metadata_files1, metadata_files2, max_diffs = Inf)

  # List shared metadata files
  shared_metadata_files <- intersect(metadata_files1, metadata_files2)

  # Find content differences
  content_differences <- purrr::map(
    .x = shared_metadata_files,
    .f = \(filename) compare_files_content(filename, folder1, folder2)
  )

  names(content_differences) <- shared_metadata_files

  # Keep files with content differences
  content_differences <- purrr::keep(content_differences, ~length(.x) > 0)

  return(
    list(
      file_differences = file_differences,
      content_differences = content_differences
    )
  )

}

#' Compare content of a specific file between two folders
#'
#' This function reads the content of a specified file from two folders and compares
#' the content using the \code{waldo::compare} function. It identifies any differences
#' in the content and returns the comparison results.
#'
#' @param filename A character string specifying the name of the file to compare.
#' @param folder1 A character string specifying the path to the first folder.
#' @param folder2 A character string specifying the path to the second folder.
#'
#' @return A list containing information about differences in the content of the specified file.
#'
#' @details The function reads the content of the specified file from both folders using
#' \code{readLines} and compares the content using the \code{waldo::compare} function.
compare_files_content <- function(filename, folder1, folder2) {

  content1 <- readLines(here::here(folder1, filename), warn = FALSE)
  content2 <- readLines(here::here(folder2, filename), warn = FALSE)

  differences <- waldo::compare(content1, content2, max_diffs = Inf)

}
