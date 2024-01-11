
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fcall

<!-- badges: start -->
<!-- badges: end -->

R package for parsing most Farm Credit Administration (“FCA”) Call
Report data into
[tidy](https://tidyr.tidyverse.org/articles/tidy-data.html) R data
frames.

## Installation

You can install {fcall} from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ketchbrookanalytics/fcall")
```

## Background

FCA publishes Call Report data on a quarterly basis at
<https://www.fca.gov/bank-oversight/call-report-data-for-download>.

As of September 2023, this data represents a set of 72 *.TXT* files.
These files represent 36 datasets. The files prefixed with “D\_” contain
*metadata* (the column names, data types, etc.) of the associated file
containing the raw, header-less comma-separated data. For example, the
file that starts with *“D_INST”* contains the metadata for the file that
starts with *“INST\_”*.

Further, some of these datasets are structured in a way that makes data
analysis difficult. In these cases, we chose to pivot the data to make
it more analysis-friendly. See [Metadata Files
Scenarios](#metadata-files-scenarios) for a more in-depth discussion of
when and how this pivoting took place.

This package provides 3 utility functions:

1.  `download_data()` allows users to programmatically download (and
    unzip) data from a specific quarter
2.  `process_data()` parses the data from these unzipped *.TXT* files
    into a list of R data frames containing the Call Report data and
    file metadata
3.  `compare_metadata()` compare metadata files (file names that start
    with “D\_”) across multiple quarters

### Downloading Data

You can download data for a particular period using `download_data()`:

``` r
# Download FCA Call Report data from March 2023
download_data(
  year = 2023, 
  month = 3, 
  dest = "path/to/some/folder"
)
```

### Process Files

You can parse the data from the downloaded *.TXT* files into tidy R data
frames using `process_data()`:

``` r
# Process data from March 2023
data_2023_03 <- process_data(folder = "path/to/some/folder")
```

You can also use `process_metadata_file()` and `process_data_file()` to
process single metadata and data files, respectively.

### Comparing Metadata from Different Periods

The FCA Call Report data has changed over time, making it difficult to
perform analysis across multiple periods. To ensure that such
comparisons can be made safely, the `compare_metadata()` returns
differences in the data structure (files, column names, and column
definitions) between two sets of FCA Call Report data.

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

`fcall` contains with the following internal datasets:

- `file_metadata` contains a short description about each file.
- The remaining datasets represent a set of “lookup table” dictionaries
  for the mapping between integer codes in the raw data and their
  plain-English description in the associated metadata. These datasets
  follow the naming convention `<file>__<column>`, where `file` is the
  name of the raw data file and `column` is the name of the column in
  the associated metadata file for which the dataset provides the
  codes/definition mapping. For example, the `RCB` Call Report data
  includes the column `INV_CODE`; the `RCB__INV_CODE` internal dataset
  in {fcall} provides the mapping between these integer codes and the
  associated plain-Englihs definitions for each.

To streamline data retrieval and usage, a dedicated function named
`get_codes_dict()` has been integrated into the package. This function
allows users to load code dictionaries effortlessly by providing only
the data name, without the need to specify the exact variable name:

``` r
# Get codes dictionary information for "RCB" data
rcb_dict <- get_codes_dict("RCB")

# Access codes dictionary
rcb_dict$codes_dict

# Access associated codes variable name
rcb_dict$codes_varname
```

## Database

[Ketchbrook Analytics](https://www.ketchbrookanalytics.com/) has created
a PostgreSQL database to store data from different periods.

Please, reach out to
[info@ketchbrookanalytics.com](mailto:info@ketchbrookanalytics.com?subject=FCA%20Call%20Report%20Database)
to request access to database credentials.

Once you are provided with credentials (in the form of a `config.yml`
file) to access the SQL database, the following code can be used to
establish a connection to the database:

``` r
# Get config
config <- config::get(config = "user")

# Connect to database
conn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = config$database,
  host = config$host,
  port = config$port,
  user = config$username,
  password = config$password
)
```

## Data Structure

The information about each dataset is spread across two files:

- A metadata file that contains information about the columns of the
  dataset.
- A data file with the actual data, without headers.

Metadata filenames start with “D\_”. We can use filenames to link each
metadata file with its corresponding data file.

### Metadata Files

Each metadata file, in essence, contains the following information about
the variables in the corresponding data file:

- Variable name
- Field type
- Decimal positions
- Variable description

Metadata is stored in a way that is not straightforward to process:

- Each metadata file has a description header that can span across
  multiple lines.
- Information about a variable is not stored in a single line, as
  variable descriptions can span across multiple lines (in an
  inconsistent way).
- Some metadata files have variable names that are preceded by two
  asterisks (\*\*). These asterisks are used to denote multiple
  occurrence columns and the first of them corresponds to a variable
  that stores codes. Files with multiple occurrence columns end with a
  NOTE that can span across multiple lines.

Nevertheless, there are some features about metadata files that come in
handy:

- Variable names are a single word (i.e., variable names are not
  separated by spaces).
- Field type is either “Numeric” or “Alphanum.” and is always placed
  after a variable name.
- Decimal positions is a one-digit number that is always placed after
  field type.

These features allow us to use regular expressions to process metadata
files.

#### Metadata Files Scenarios

Metadata files can be classified into different scenarios:

- Scenario 1: All variables are single occurrence (i.e., no variable is
  preceded by two asterisks). This scenario will be referred as
  “single”.
- Scenario 2: A set of single occurrence variables is followed by a set
  of multiple occurrence variables. This scenario will be referred as
  “single_multiple”.
- Scenario 3: A set of single occurrence variables followed by a set of
  multiple occurrence variables is followed by a second set of single
  occurrence variables. This scenario will be referred as
  “single_multiple_single”.

This classification is important because the corresponding data file has
a different structure depending on the scenario.

### Data Files

In general terms, the processing workflow of data files involves:

1.  Reading data.
2.  Naming columns.
3.  Performing pivot operations (if necessary).

Specific operations depend on the metadata file identified structure.

- Scenario 1 (“single”): This is the simplest scenario. The data in the
  data file is already in the expected format, and the only task is to
  use the column names specified in the metadata file.

- Scenario 2 (“single_multiple”): In this case, the tabular structure in
  the data file is not as expected. After single occurrence columns, the
  multiple occurrence columns are repeated for each code of the “code”
  variable. To help understanding the previous statement, take a look at
  the following mock column names: SINGLE1, SINGLE2, CODE10,
  MULTIPLE1_10, MULTIPLE2_10, CODE20, MULTIPLE1_20, MULTIPLE2_20. CODE,
  MULTIPLE1 and MULTIPLE2 would appear in the metadata file with
  preceding double asterisks. In this case, CODE has only codes 10
  and 20. To properly name the columns it is necessary to determine the
  total number of distinct codes. Using naming conventions simplifies
  pivot operations. Once data columns are properly named, we complete
  the data processing by applying both long and wide pivots accordingly.

- Scenario 3 (“single_multiple_single”): This is the most complex
  scenario, currently applicable to only one data file (RCR7). Unlike
  Scenario 2, there is an additional set of single occurrence columns.
  The data in the data file has, for each “observation”, a row that
  contains comma separated values of variables that belong to the first
  set of single occurrence columns, followed by a row for each code of
  the ‘code’ variable with comma separated values of multiple occurrence
  variables, and finally, a row that contains comma separated values of
  the remaining single occurrence columns. In this case, the initial
  step of reading the data involves concatenating lines corresponding to
  the same observation using loops. Once the data is read, the
  processing is similar to Scenario 2, with the difference that when
  naming the variables, it is necessary to consider that the repeating
  columns are in the middle of the dataset. After naming the columns,
  the processing is the same as in Scenario 2. The resulting dataset
  differs from the metadata file in that it places all single occurrence
  columns at the beginning.
