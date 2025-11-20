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
# \donttest{

  path <- tempfile("fcadata")
  dir.create(path)

  download_data(
    year = 2025,
    month = "September",
    dest = path
  )
#> Files successfully downloaded into /tmp/Rtmp0rXpkR/fcadata181412c6914c

  process_data_file(
    file = file.path(path, "RCB_Q202509_G20251112.TXT"),
    metadata = process_metadata_file(file.path(path, "D_RCB.TXT")),
    dict = RCB__INV_CODE
  )
#> # A tibble: 2,240 × 11
#>    SYSTEM  DIST ASSOC MONTH  YEAR UNINUM INV_CODE BKVAL MKTVAL BKVALFORSALE
#>     <int> <int> <int> <int> <int>  <int>    <int> <int>  <int>        <int>
#>  1      6    10     0     9  2025 610000       10     0      0       770093
#>  2      6    10     0     9  2025 610000       15     0      0       154555
#>  3      6    10     0     9  2025 610000       17     0      0         1917
#>  4      6    10     0     9  2025 610000       25     0      0            0
#>  5      6    10     0     9  2025 610000       29     0      0            0
#>  6      6    10     0     9  2025 610000       35     0      0            0
#>  7      6    10     0     9  2025 610000       40     0      0       284976
#>  8      6    10     0     9  2025 610000       41     0      0       400000
#>  9      6    10     0     9  2025 610000       50     0      0       250000
#> 10      6    10     0     9  2025 610000       51     0      0            0
#> # ℹ 2,230 more rows
#> # ℹ 1 more variable: MKTVALFORSALE <int>

# }
```
