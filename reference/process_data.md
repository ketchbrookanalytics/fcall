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
# \donttest{

  path <- tempfile("fcadata")
  dir.create(path)

  download_data(
    year = 2025,
    month = "September",
    dest = path
  )
#> Files successfully downloaded into /tmp/Rtmp0H5JIE/fcadata18a246e34c00

  processed_data <- process_data(path)

  # Access "RCB" data
  processed_data$data$RCB
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

  # Access "RCB" metadata
  processed_data$metadata$RCB
#> $scenario
#> [1] "single_multiple"
#> 
#> $vars_info
#> # A tibble: 11 × 7
#>    ColumnName    ColumnType DecimalPosition Definition    MultipleOccurrenceCo…¹
#>    <chr>         <chr>      <chr>           <chr>         <lgl>                 
#>  1 SYSTEM        Numeric    0               System Code   FALSE                 
#>  2 DIST          Numeric    0               District Code FALSE                 
#>  3 ASSOC         Numeric    0               Association … FALSE                 
#>  4 MONTH         Numeric    0               Month of Rep… FALSE                 
#>  5 YEAR          Numeric    0               Year of Repo… FALSE                 
#>  6 UNINUM        Numeric    0               System, Dist… FALSE                 
#>  7 INV_CODE      Numeric    0               Investment C… TRUE                  
#>  8 BKVAL         Numeric    0               Amortized co… TRUE                  
#>  9 MKTVAL        Numeric    0               Fair Value o… TRUE                  
#> 10 BKVALFORSALE  Numeric    0               Available fo… TRUE                  
#> 11 MKTVALFORSALE Numeric    0               Available fo… TRUE                  
#> # ℹ abbreviated name: ¹​MultipleOccurrenceColumn
#> # ℹ 2 more variables: CodeColumn <lgl>, ColumnTypeSQL <chr>
#> 
# }
```
