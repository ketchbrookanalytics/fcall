
# Download & process September 2023 Call Report data in a safe, temp environment
call_report_data <- withr::with_tempfile(
  "call_report_data",
  code = {
    download_data(2023, 9, call_report_data); process_data(call_report_data)
  }
)

test_that("`process_data()` was successful", {

  # Returns a list
  expect_true(
    is.list(call_report_data)
  )

  # List elements named correctly
  expect_identical(
    names(call_report_data),
    c("data", "metadata")
  )

  # Data & Metadata have same length
  expect_equal(
    length(call_report_data$data),
    length(call_report_data$metadata)
  )

  # Naming conventions of data & metadata match
  expect_identical(
    names(call_report_data$data),
    names(call_report_data$metadata)
  )

  # Check `$data` object ----

  # All elements are data frames
  expect_true(
    call_report_data$data |>
      lapply(is.data.frame) |>
      unlist() |>
      all()
  )

  check_gt_one_row <- function(x) {nrow(x) >= 1L}

  # Data frames are not empty
  expect_true(
    call_report_data$data |>
      lapply(check_gt_one_row) |>
      unlist() |>
      all()
  )

  # Check `$metadata` object ----

  # List elements are named correctly
  expect_true(
    call_report_data$metadata |>
      lapply(names) |>
      lapply(function(x) x == c("scenario", "vars_info")) |>
      unlist() |>
      all()
  )

  # Scenarios match naming conventions
  expect_true(
    call_report_data$metadata |>
      lapply(function(x) x$scenario) |>
      lapply(function(x) x %in% c(
        "single",
        "single_multiple",
        "single_multiple_single"
      )) |>
      unlist() |>
      all()
  )

  # All elements in `var_info` are data frames...
  expect_true(
    call_report_data$metadata |>
      lapply(function(x) x$vars_info) |>
      lapply(is.data.frame) |>
      unlist() |>
      all()
  )

  # ...and are not empty
  expect_true(
    call_report_data$metadata |>
      lapply(function(x) x$vars_info) |>
      lapply(check_gt_one_row) |>
      unlist() |>
      all()
  )

})
