#' Download FCA Call Report Data and Unzip
#'
#' @param year (Integer) The year of the Call Report (e.g., `2022`)
#' @param month (String) The month of the Call Report (e.g., `"March"`); you may
#'   also supply an integer (e.g., `3`) representing the month numerically
#' @param dest (String) The path to the directory where the data will be
#'   downloaded (and unzipped) into
#' @param files (Optional) Character vector, representing the names of the files
#'   in the .zip archive to be downloaded; default is `NULL`, meaning all files
#'   will be downloaded
#' @param quiet (Optional) Logical. Controls whether download progress messages
#'   are displayed in the console. Defaults to `TRUE`.
#'
#' @details FCA publishes Call Report data quarterly. These .zip files are
#'   typically named "`YYYY`March.zip", "`YYYY`June.zip", "`YYYY`September.zip"
#'   and "`YYYY`December.zip" (where `YYYY` represents the 4-digit year).
#'   Therefore, valid values to the `month` argument should be limited to
#'   `c(3, 6, 9, 12)`, unless there is an anomaly in FCA's reporting/publishing.
#'   Check <https://www.fca.gov/bank-oversight/call-report-data-for-download> to
#'   ensure the data is available for the quarter you are interested in.
#'   Ketchbrook Analytics downloads these files and stores them in a public AWS
#'   S3 bucket, which is the location that `download_data()` retrieves them
#'   from.
#'
#'   The files in the S3 bucket are identical to those published by FCA, with
#'   one exception: the `RCR7` data files in the March, June, September and
#'   December 2024 .zip files have been corrected to add rows that are missing
#'   from FCA's versions. Without these rows, `process_data()` fails on the
#'   2024 data. See <https://github.com/ketchbrookanalytics/fcall/issues/23>
#'   for details. If you need FCA's original 2024 files, download them directly
#'   from the FCA website.
#'
#' @return `TRUE` (invisibly) if the data was successfully downloaded and
#'   unzipped, along with a console message informing the user where the
#'   data was downloaded (and unzipped) into. If the data cannot be
#'   downloaded (e.g., there is no internet connection, the resource is
#'   unavailable, or there is no data for the requested `year` and `month`)
#'   or unzipped, `download_data()` returns `FALSE` (invisibly) with an
#'   informative console message, instead of throwing an error.
#'
#' @export
#'
#' @examples
#' \donttest{
#'
#'   path_1 <- tempfile("fcadata1")
#'   dir.create(path_1)
#'
#'   download_data(
#'     year = 2025,
#'     month = "September",   # using the name of the month
#'     dest = path_1
#'   )
#'
#'   list.files(path_1)
#'
#'   path_2 <- tempfile("fcadata2")
#'   dir.create(path_2)
#'
#'   download_data(
#'     year = 2025,
#'     month = 9,   # using the month number (to refer to September)
#'     dest = path_2,
#'     # only download the following files
#'     files = c(
#'       "D_INST.TXT",
#'       "INST_Q202509_G20251112.TXT"
#'     )
#'   )
#'
#'   list.files(path_2)
#'
#' }
download_data <- function(year, month, dest, files = NULL, quiet = FALSE) {

  # Example valid URL:
  # "https://fca-call-report-data.s3.us-east-1.amazonaws.com/raw/2020March.zip"

  # Ensure only one month & one year are specified
  if (length(year) > 1L) {
    rlang::abort("You can only specify a single year")
  }

  if (length(month) > 1L) {
    rlang::abort("You can only specify a single month")
  }

  # If the `month` argument supplied is not the explicit name of the month...
  if (!month %in% month.name) {

    # Check to see if it is in the vector c(1:12)
    # NOTE: this handles *both* the cases where `month` is the string "3" or the
    # integer `3` (for example)
    if (month %in% paste(1:12)) {

      # If it is, extract the explicit month name using the integer
      month <- month.name[as.integer(month)]

    } else {

      rlang::abort(
        "`month` must be in `month.name`, or an integer in `c(1:12)`"
      )

    }

  }

  # Define base URL for AWS S3 bucket
  base_url <- "https://fca-call-report-data.s3.us-east-1.amazonaws.com/raw/"

  # The download URL convention changed in March 2015
  if (year >= 2015L) {

    # Build the URL to the .zip file
    url <- paste0(
      base_url,
      year,
      month,
      ".zip"
    )

  } else {

    # Older files use an abbreviated month name convention
    month <- switch(
      month,
      March = "Mar",
      June = "Jun",
      September = "Sept",
      December = "Dec"
    )

    # Build the URL to the .zip file
    url <- paste0(
      base_url,
      month,
      year,
      ".zip"
    )

  }

  # Create temp storage location for .zip file
  temp_path <- tempfile(fileext = ".zip")
  on.exit(unlink(temp_path), add = TRUE)

  # Download .zip file into temp storage location
  # NOTE: per CRAN policy, fail gracefully (with an informative message instead
  # of an error) if the resource is unavailable; `utils::download.file()`
  # signals a warning before its error, so either condition means it failed
  download_problem <- tryCatch(
    expr = {
      utils::download.file(
        url = url,
        destfile = temp_path,
        quiet = quiet
      )
      NULL
    },
    error = function(e) conditionMessage(e),
    warning = function(w) conditionMessage(w)
  )

  if (!is.null(download_problem)) {

    rlang::inform(
      c(
        paste0("Could not download ", url),
        "x" = download_problem,
        "i" = paste(
          "The resource may be temporarily unavailable, or there may be no",
          "data for the requested `year` and `month`. Please check your",
          "internet connection and try again later."
        )
      )
    )

    return(invisible(FALSE))

  }

  # Un-zip the files into the directory defined by the `dest` argument
  # NOTE: `utils::unzip()` signals a warning (not an error) if the .zip file is
  # corrupt or the requested `files` aren't in it
  unzip_problem <- tryCatch(
    expr = {
      utils::unzip(
        zipfile = temp_path,
        files = files,
        exdir = dest
      )
      NULL
    },
    error = function(e) conditionMessage(e),
    warning = function(w) conditionMessage(w)
  )

  if (!is.null(unzip_problem)) {

    rlang::inform(
      c(
        paste0("Could not unzip the files downloaded from ", url),
        "x" = unzip_problem
      )
    )

    return(invisible(FALSE))

  }

  # Inform user
  paste0("Files successfully downloaded into ", dest) |>
    rlang::inform()

  invisible(TRUE)

}
