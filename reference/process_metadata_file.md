# Process metadata file to extract variable information

`process_metadata_file()` reads a metadata file and extracts information
about the column names, column types, decimal positions, and variable
definitions.

## Usage

``` r
process_metadata_file(file)
```

## Arguments

- file:

  (String) The path to the metadata file.

## Value

A list containing the scenario (e.g., `"single"`, `"single_multiple"`,
`"single_multiple_single"`) and a tibble with variable information.

## Details

`process_metadata_file()` processes metadata files following specific
rules to handle encoding, remove unnecessary information, and extract
variable details. It detects the scenario based on the occurrence of
double asterisks in variable names.

## Examples

``` r
if (FALSE) { # \dontrun{

  path <- tempfile("fcadata")

  download_data(
    year = 2022,
    month = "December",
    dest = path
  )

  process_metadata_file(file.path(path, "D_RC1.TXT"))

} # }
```
