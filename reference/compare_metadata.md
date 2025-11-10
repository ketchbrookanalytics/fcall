# Compare FCA Call Report metadata files between two folders

`compare_metadata()` compares the content of the metadata files (files
that start with "D\_") between two specified folders containing FCA Call
Report data (from two different quarters).

## Usage

``` r
compare_metadata(dir1, dir2)
```

## Arguments

- dir1:

  (String) The path to a folder containing FCA Call Report .TXT files
  for a single quarter

- dir2:

  (String) The path to a folder containing FCA Call Report .TXT files
  for a (different) single quarter

## Value

A list containing information about differences in file names, file
order, and content differences between the metadata files in `dir1` and
`dir2`

## Details

`compare_metadata()` lists metadata files in each folder, identifies
shared metadata files, and then compares (a) the number of files, (b)
file names, (c) file order, and (d) file content (using the
[`waldo::compare()`](https://waldo.r-lib.org/reference/compare.html)
function).

## Examples

``` r
if (FALSE) { # \dontrun{

  # Download data from March 2023
  path_1 <- tempfile("fcadata")

  download_data(
    year = 2023,
    month = 3,
    dest = path_1
  )

  # Download data from March 2022
  path_2 <- tempfile("fcadata")

  download_data(
    year = 2022,
    month = 3,
    dest = path_2
  )

  compare_metadata(path_1, path_2)

} # }
```
