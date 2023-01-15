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


get_data <- function(dir, code) {

  schema_file_name <- paste0("D_", code, ".TXT")

  # Read lines from source .TXT file
  lines <- readLines(
    here::here(dir, schema_file_name),
    warn = FALSE
  )

  # Get the line where the variables start
  vars_start <- which(
    startsWith(
      trimws(lines),
      "----"
    ) == TRUE
  ) + 1

  # Subset 'lines' to start at 'vars_start'
  lines <- lines[vars_start:length(lines)]

  # print(paste0("Dirty Lines: ", lines))

  codes <- get_codes(lines = lines)

  # print(paste0("Codes: ", codes))

  code_pos <- get_code_var_pos(lines = lines)

  # print(paste0("Code Positions: ", code_pos))

  lines_clean <- clean_lines(lines = lines)

  # print("Clean Lines:")
  # print(lines_clean)

  # lines_clean[code_pos]

  schema <- get_col_info(
    lines = lines_clean,
    codes = codes,
    code_pos = code_pos
  )

  # print("Schema:")
  # print(schema)

  path_to_data <- list.files(
    path = dir,
    pattern = paste0("^", code, "_Q*")
  )

  if (length(path_to_data > 1)) {

    path_to_data <- path_to_data[length(path_to_data)]

  }

  # Read the data
  read.csv(
    file = here::here(dir, path_to_data),
    header = F,
    col.names = schema$vars,
    colClasses = schema$types
  )

}
