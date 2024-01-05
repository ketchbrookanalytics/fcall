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

compare_files_content <- function(filename, folder1, folder2) {

  content1 <- readLines(here::here(folder1, filename), warn = FALSE)
  content2 <- readLines(here::here(folder2, filename), warn = FALSE)

  differences <- waldo::compare(content1, content2, max_diffs = Inf)

}
