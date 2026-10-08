test_that("`download_data()` fails gracefully if the file can't be downloaded", {

  skip_if_offline()

  # No data exists for a year in the future, so the download fails (404)
  dest <- withr::local_tempfile(pattern = "fcadata2099")
  dir.create(dest)

  expect_message(
    out <- download_data(2099, 3, dest, quiet = TRUE),
    "Could not download"
  )

  # Returns `FALSE` (invisibly) instead of throwing an error
  expect_false(out)

  # Nothing was unzipped into `dest`
  expect_length(list.files(dest), 0L)

})

test_that("`download_data()` returns `TRUE` on a successful download", {

  skip_if_offline()

  dest <- withr::local_tempfile(pattern = "fcadata2025")
  dir.create(dest)

  expect_message(
    out <- download_data(2025, 9, dest, files = "D_INST.TXT", quiet = TRUE),
    "Files successfully downloaded"
  )

  expect_true(out)

  expect_identical(list.files(dest), "D_INST.TXT")

})

test_that("`download_data()` still throws an error for invalid arguments", {

  expect_error(
    download_data(2025, 13, tempdir()),
    "`month` must be in `month.name`"
  )

})
