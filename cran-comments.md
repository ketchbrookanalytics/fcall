## Fix

This is a resubmission of a package that is on CRAN but checks are failing due to a "Verify you are a human" page blocking the URL where `utils::download.file()` (within the package's `download_data()` function) attempts to download a file from. The following changes have been made to remediate this issue:

* Files to be downloaded via `download_data()` are now hosted in a public AWS S3 bucket
* `download_data()` now points to the public AWS S3 bucket
* Documentation has been updated to let users know that the data is now being downloaded from AWS S3 instead of the FCA website directly
