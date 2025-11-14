metadata_comparison_test <- function(year1, month1, dest1,
                                     year2, month2, dest2) {

  download_data(
    year = year1,
    month = month1,
    dest = dest1
  )

  download_data(
    year = year2,
    month = month2,
    dest = dest2
  )

  diffs <- compare_metadata(
    dir1 = dest1,
    dir2 = dest2
  )

  return(diffs)

}


test_that("`compare_metadata()` correctly identifies if differences exist", {

  # Compare June 2025 to September 2025
  # We expect no differences across files or content
  diffs <- withr::with_tempdir(
    code = {
      metadata_comparison_test(
        year1 = 2025, month1 = 6, dest1 = "jun2025",
        year2 = 2025, month2 = 9, dest2 = "sep2025"
      )
    }
  )

  expect_true(
    length(diffs$file_differences) == 0L
  )

  expect_true(
    length(diffs$content_differences) == 0L
  )

  # Compare June 2019 to September 2025
  # We expect differences across files but not content
  diffs <- withr::with_tempdir(
    code = {
      metadata_comparison_test(
        year1 = 2019, month1 = 6, dest1 = "jun2019",
        year2 = 2025, month2 = 9, dest2 = "sep2025"
      )
    }
  )

  expect_gt(
    length(diffs$file_differences),
    0L
  )

  expect_true(
    length(diffs$content_differences) == 0L
  )

  # Compare June 2011 to September 2025
  # We expect differences across files and content
  diffs <- withr::with_tempdir(
    code = {
      metadata_comparison_test(
        year1 = 2011, month1 = 6, dest1 = "jun2011",
        year2 = 2025, month2 = 9, dest2 = "sep2025"
      )
    }
  )

  expect_gt(
    length(diffs$file_differences),
    0L
  )

  expect_gt(
    length(diffs$content_differences),
    0L
  )

})