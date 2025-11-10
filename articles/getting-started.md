# Getting Started

### Downloading Data

You can download data for a particular period using
[`download_data()`](https://ketchbrookanalytics.github.io/fcall/reference/download_data.md):

``` r
library(fcall)

# Download FCA Call Report data from March 2023
download_data(
  year = 2023,
  month = 3,
  dest = "path/to/some/folder"
)
```

### Processing Files

You can parse the data from the downloaded *.TXT* files into tidy R data
frames using
[`process_data()`](https://ketchbrookanalytics.github.io/fcall/reference/process_data.md):

``` r
# Process data from March 2023
data_2023_03 <- process_data(dir = "path/to/some/folder")
```

You can also use
[`process_metadata_file()`](https://ketchbrookanalytics.github.io/fcall/reference/process_metadata_file.md)
and
[`process_data_file()`](https://ketchbrookanalytics.github.io/fcall/reference/process_data_file.md)
to process single metadata and data files, respectively.

**Note:
[`process_data()`](https://ketchbrookanalytics.github.io/fcall/reference/process_data.md)
has only been tested by the development team on Call Report data from
March 2020 to present. Please let us know if you find issues with
processing data older than 2020.**

### Comparing Metadata from Different Periods

The FCA Call Report data has changed over time, making it difficult to
perform analysis across multiple periods. To ensure that such
comparisons can be made safely, the
[`compare_metadata()`](https://ketchbrookanalytics.github.io/fcall/reference/compare_metadata.md)
returns differences in the data structure (files, column names, and
column definitions) between two sets of FCA Call Report data.

``` r
# Download data from June 2023
download_data(
  year = 2023,
  month = 6,
  dest = "path/to/some/other/folder"
)

# Compare metadata files from March and June 2023
compare_metadata(
  dir1 = "path/to/some/folder",   # where we downloaded the March 2023 data
  dir2 = "path/to/some/other/folder"
)
```

### Internal Datasets

{fcall} contains the following internal datasets:

- `file_metadata` contains a short description about each file.
- The remaining datasets represent a series of “lookup table”
  dictionaries for the mapping between integer codes in the raw data and
  their plain-English descriptions in the associated metadata. These
  datasets follow the naming convention `<file>__<column>`, where `file`
  is the name of the raw data file and `column` is the name of the
  column in the associated metadata file for which the dataset provides
  the codes/definition mapping. For example, the `RCB` Call Report data
  includes the column `INV_CODE`; the `RCB__INV_CODE` internal dataset
  in {fcall} provides the mapping between these integer codes and the
  associated plain-English definitions for each.

``` r
RCB__INV_CODE |> str()
#> Classes 'tbl_df', 'tbl' and 'data.frame':    35 obs. of  2 variables:
#>  $ code : int  10 15 17 25 29 35 40 41 60 52 ...
#>  $ value: chr  "U.S. Treasury securities" "SBA securities" "Other U.S. Gov't securities and Agency(excluding MBS)" "Securities fully and unconditionally guaranteed by a GSE (excluding MBS and Farmer Mac securities)" ...
```

To streamline data retrieval and usage, a dedicated function named
[`get_codes_dict()`](https://ketchbrookanalytics.github.io/fcall/reference/get_codes_dict.md)
is also available. This function allows users to access code
dictionaries for a dataset without needing to remember the specific
column name in the dataset that contains the codes:

``` r
# Get codes dictionary information for "RCB" data
get_codes_dict("RCB") |> str()
#> List of 2
#>  $ codes_dict   :Classes 'tbl_df', 'tbl' and 'data.frame':   35 obs. of  2 variables:
#>   ..$ code : int [1:35] 10 15 17 25 29 35 40 41 60 52 ...
#>   ..$ value: chr [1:35] "U.S. Treasury securities" "SBA securities" "Other U.S. Gov't securities and Agency(excluding MBS)" "Securities fully and unconditionally guaranteed by a GSE (excluding MBS and Farmer Mac securities)" ...
#>  $ codes_varname: chr "INV_CODE"
```
