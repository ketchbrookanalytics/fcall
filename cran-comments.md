## Fix

This release addresses the CRAN team's email of 2026-10-08 about check failures (<https://cran.r-project.org/web/checks/check_results_fcall.html>) and the CRAN policy on packages that use Internet resources.

The failing check was a unit test that expected `process_data()` to signal a problem with the 2024 data files. Those files have since been fixed at the source, so the test no longer held. The following changes have been made:

* Removed the failing unit test, and the outdated 2024 message in `process_data()` that it tested for
* Unit tests that download data now use `testthat::skip_if_offline()`, so they are skipped on CRAN and when no internet connection is available
* `download_data()` now fails gracefully: if the resource is unavailable or has changed, it returns `FALSE` (invisibly) with an informative message, instead of throwing an error
* Examples that download data now use `@examplesIf` to run only when an internet connection is available (they remain wrapped in `\donttest{}`), and examples that read downloaded files only do so if the download succeeded

## R CMD check results

0 errors | 0 warnings | 0 notes
