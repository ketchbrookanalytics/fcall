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
# \donttest{

  path <- tempfile("fcadata")
  dir.create(path)

  download_data(
    year = 2025,
    month = "September",
    dest = path
  )
#> Files successfully downloaded into /tmp/Rtmp0H5JIE/fcadata18a226985f89

  process_metadata_file(file.path(path, "D_RC1.TXT"))
#> $scenario
#> [1] "single"
#> 
#> $vars_info
#> # A tibble: 58 × 7
#>    ColumnName ColumnType DecimalPosition Definition       MultipleOccurrenceCo…¹
#>    <chr>      <chr>      <chr>           <chr>            <lgl>                 
#>  1 SYSTEM     Numeric    0               System Code      FALSE                 
#>  2 DIST       Numeric    0               District Code    FALSE                 
#>  3 ASSOC      Numeric    0               Association Code FALSE                 
#>  4 MONTH      Numeric    0               Month of Report  FALSE                 
#>  5 YEAR       Numeric    0               Year of Report   FALSE                 
#>  6 UNINUM     Numeric    0               System, Distric… FALSE                 
#>  7 TYPRE      Numeric    0               Loans - Product… FALSE                 
#>  8 TYPPROINT  Numeric    0               Loans - Product… FALSE                 
#>  9 TYPCOOP    Numeric    0               Loans - Agibusi… FALSE                 
#> 10 TYPPROCMKT Numeric    0               Loans - Agibusi… FALSE                 
#> # ℹ 48 more rows
#> # ℹ abbreviated name: ¹​MultipleOccurrenceColumn
#> # ℹ 2 more variables: CodeColumn <lgl>, ColumnTypeSQL <chr>
#> 

# }
```
