# Process a data file using metadata and codes dictionary

`process_data_file()` reads a data file, applies the provided metadata
and codes dictionary, and organizes the data into a tidy format. The
column names are determined based on the metadata scenario (e.g.,
`"single"`, `"single_multiple"`, `"single_multiple_single"`).

## Usage

``` r
process_data_file(file, metadata, dict = NULL)
```

## Arguments

- file:

  (String) The path to the data file

- metadata:

  A list containing the scenario and variable information obtained from
  the metadata file using
  [`process_metadata_file`](https://ketchbrookanalytics.github.io/fcall/reference/process_metadata_file.md).

- dict:

  (Optional) A data frame containing codes dictionary information

## Value

A tibble containing the processed data in a tidy format

## Details

`process_data_file()` processes the data file according to the metadata
scenario. It handles cases where variables have multiple occurrences and
organizes the data into a tidy format with appropriate column names. The
function relies on the
[`read_data_file`](https://ketchbrookanalytics.github.io/fcall/reference/read_data_file.md)
function for the actual data reading.

## Examples

``` r
if (FALSE) { # \dontrun{

  path <- tempfile("fcadata")

  download_data(
    year = 2022,
    month = "March",
    dest = path
  )

  process_data_file(
    file = file.path(path, "RCB_Q202203_G20220808.TXT"),
    metadata = process_metadata_file(file.path(path, "D_RCB.TXT")),
    dict = RCB__INV_CODE
  )

} # }
```
