#' Download data from FCA website
#'
#' @param year Integer, the year of the call report (e.g., 2022)
#' @param month Integer, they month of the call report (e.g., 3)
#' @param dest String, representing the directory where the data will be
#'   downloaded into
#' @param files (Optional) character vector, representing the names of the files
#'   in the .zip archive to be downloaded. If left `NULL`, all files will be
#'   downloaded.
#'
#' @details FCA publishes call reports are quarterly, and are typically dated
#'   as "March", "June", "September", and "December". Therefore, valid values
#'   to the `month` argument should be limited to `c(3, 6, 9, 12)`, unless there
#'   is an anomoly in FCA's reporting/publishing. Check
#'   <https://www.fca.gov/bank-oversight/call-report-data-for-download> to
#'   ensure the data is available for the quarter you are interested in.
#'
#' @return Console message informing the user where the data was successfully
#'   downloaded to
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   download_data(
#'     year = 2022,
#'     month = 12,
#'     dest = "data",
#'     c("D_INST.TXT", "D_RC.TXT")
#'    )
#' }
download_data <- function(year, month, dest, files = NULL) {

  # Example valid URL: "https://www.fca.gov/template-fca/bank/2020March.zip"

  url <- paste0(
    "https://www.fca.gov/template-fca/bank/",
    year,
    month.name[month],
    ".zip"
  )

  # Create temp storage location for .zip file
  temp_dir <- tempdir()
  temp_path <- here::here(temp_dir, "tempzip.zip")

  # Download .zip file into temp storage location
  download.file(
    url = url,
    destfile = temp_path
  )

  # Un-zip the files into the directory defined by the `dest` argument
  unzip(
    zipfile = temp_path,
    files = files,
    exdir = dest
  )

  # Remove temp directory
  unlink(temp_dir)

  # Inform user
  paste0("Files successfully downloaded into ", here::here(dest)) |>
    rlang::inform()

}
