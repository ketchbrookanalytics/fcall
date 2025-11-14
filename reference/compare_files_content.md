# Compare content of a specific file between two folders

`compare_files_content()` reads the content of a specified file from two
folders and compares the content using the
[`waldo::compare`](https://waldo.r-lib.org/reference/compare.html)
function. It identifies any differences in the content and returns the
comparison results.

## Usage

``` r
compare_files_content(filename, dir1, dir2)
```

## Arguments

- filename:

  A character string specifying the name of the file to compare.

- dir1:

  A character string specifying the path to the first folder.

- dir2:

  A character string specifying the path to the second folder.

## Value

A list containing information about differences in the content of the
specified file.

## Details

`compare_files_content()` reads the content of the specified file from
both folders using
[`readLines()`](https://rdrr.io/r/base/readLines.html), and compares the
content using the
[`waldo::compare()`](https://waldo.r-lib.org/reference/compare.html)
function.
