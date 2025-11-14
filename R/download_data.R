#' Download data from FCA website
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
#'
#' @return Console message informing the user where the data was successfully
#'   downloaded (and unzipped) into
#'
#' @export
#'
#' @examples
#' \donttest{
#'
#'   path_1 <- tempfile("fcadata")
#'
#'   download_data(
#'     year = 2022,
#'     month = "December",   # using the name of the month
#'     dest = path_1
#'   )
#'
#'   list.files(path_1)
#'
#'   path_2 <- tempfile("fcadata")
#'
#'   download_data(
#'     year = 2023,
#'     month = 9,   # using the month number (to refer to September)
#'     dest = path_2,
#'     # only download the following files
#'     files = c(
#'       "D_INST.TXT",
#'       "INST_Q202309_G20231106.TXT"
#'     )
#'   )
#'
#'   list.files(path_2)
#'
#' }
download_data <- function(year, month, dest, files = NULL, quiet = FALSE) {

  # Example valid URL: "https://www.fca.gov/template-fca/bank/2020March.zip"

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

  # Build the URL to the .zip file
  url <- paste0(
    "https://www.fca.gov/template-fca/bank/",
    year,
    month,
    ".zip"
  )

  # Create temp storage location for .zip file
  temp_path <- tempfile(fileext =  ".zip")

  # Download .zip file into temp storage location
  utils::download.file(
    url = url,
    destfile = temp_path,
    quiet = quiet
  )

  # Un-zip the files into the directory defined by the `dest` argument
  utils::unzip(
    zipfile = temp_path,
    files = files,
    exdir = dest
  )

  # Inform user
  paste0("Files successfully downloaded into ", dest) |>
    rlang::inform()

}
