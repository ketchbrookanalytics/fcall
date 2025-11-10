# Read a data file based on metadata and codes dictionary

`read_data_file()` reads a data file and processes it based on the
provided metadata and codes dictionary. The processing depends on the
metadata scenario, which includes cases like `"single"`,
`"single_multiple"`, and `"single_multiple_single"`. For certain
scenarios, the function utilizes `read.csv` to infer column types
without explicit specification.

## Usage

``` r
read_data_file(file, metadata, dict)
```

## Arguments

- file:

  A character string specifying the path to the data file.

- metadata:

  A list containing the scenario and variable information obtained from
  the metadata file using
  [`process_metadata_file`](https://ketchbrookanalytics.github.io/fcall/reference/process_metadata_file.md).

- dict:

  A data frame containing codes dictionary information.

## Value

A tibble containing the processed data.

## Details

`read_data_file()` reads the data file and applies necessary processing
based on the metadata scenario. For scenarios like `"single"` and
`"single_multiple"`, it uses `read.csv` for convenient type inference.
For `"single_multiple_single"`, it reads the file line by line,
collapses every `(N_CODES + 2)` lines, and then reads the collapsed
lines using `read.table`.
