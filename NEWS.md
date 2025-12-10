# fcall 0.1.6

## Bug Fix

Sometime around 2025-12-08, the Farm Credit Administration (FCA) added a layer to it's website to "Verify you are a human" before hitting the page where the data can be downloaded via hyperlinks. This caused the `download_data()` function (which relies on `utils::download.file()`) to fail, including in CRAN checks/builds.

To remediate this issue, Ketchbrook Analytics has replicated the files on the FCA website (from 2000-present) in a public AWS S3 bucket. `download_data()` now retrieves files from the public AWS S3 bucket instead of the FCA website directly.

# fcall 0.1.5

Addresses CRAN comments regarding:

* Extra "Description: " text in Description field of `DESCRIPTION`
* Quoted "FCA" abbreviation in `DESCRIPTION`

## Additional Changes

* Bug fix for downloading data from years before 2015
* Adds new test for `compare_metadata()`
* Removes embedded files in unit tests (now downloads data on-the-fly)
* Improves naming conventions in `compare_metadata()` output
* Uses latest files in testing/examples

# fcall 0.1.4

Addresses CRAN comments regarding:

* Use of unquoted "FCA" abbreviation in `DESCRIPTION`
* Potential bad hyperlinks in README
    + Database Users section was moved to a {pkgdown} Article to avoid any further issues
* Improper use of hyperlink markdown `< >` characters in `download_data()` roxygen comments

# fcall 0.1.3

* Initial release attempt on CRAN
* Removes use of `get()` in `get_codes_dict()`, removing need to call `library(fcall)` before calling `get_codes_dict()`
* Requires R 4.1 or newer (due to base pipe)
* Updates year in `LICENSE`
* Removes internal database-related functions

# fcall 0.1.2

## User-Facing Improvements

* Additional context included in the error message users see when 2024 files are passed to `process_data()`
* `download_data()` has a new (logical) `quiet` argument that controls console messaging during download process

## Database-Related

* Removed warnings in `append_data()`
* Fixed bug in `add_user_read_access()`

## Other

* Added `R CMD check` GitHub Action for automated package checks
* {fs} has been removed from `Imports`

# fcall 0.1.1

## Technical

* Fixed encoding issues
* Require R version 3.5.0 or newer

## Documentation

* Added "Database" vignette
* Extracted README sections into vignettes/articles

# fcall 0.1.0

* Initial release
