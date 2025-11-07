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
