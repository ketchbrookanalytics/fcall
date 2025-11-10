# Process FCA Call Report data in a specified folder

`process_data()` reads the downloaded (and unzipped) .TXT files into
tidy data frames, applying the schema from the "D\_" files to the
corresponding raw comma-separated data files, as well as storing the
metadata from the "D\_" files

## Usage

``` r
process_data(dir)
```

## Arguments

- dir:

  (String) The path to a folder containing FCA Call Report .TXT files
  for a single quarter

## Value

A list containing processed data and metadata.

## Details

`process_data()` assumes that metadata and data files share a common
root name (characters until the first underscore occurrence).

## Examples

``` r
if (FALSE) { # \dontrun{

  path <- tempfile("fcadata")

  download_data(
    year = 2022,
    month = "December",
    dest = path
  )

  processed_data <- process_data(path)

  # Access "RCB" data
  processed_data$data$RCB

  # Access "RCB" metadata
  processed_data$metadata$RCB
} # }
```
