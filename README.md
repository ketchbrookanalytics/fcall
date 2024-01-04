# fcacallr
R package for parsing most FCA call report data into dataframes.

FCA publishes call report data at [https://www.fca.gov/bank-oversight/call-report-data-for-download](https://www.fca.gov/bank-oversight/call-report-data-for-download).

## Data Structure

The information about each dataset is spread across two files:

- A metadata file that contains information about the columns of the dataset.
- A data file with the actual data, without headers.

Metadata filenames start with "D_". We can use filenames to link each metadata file with its corresponding data file.

### Metadata Files

Each metadata file, in essence, contains the following information about the variables in the corresponding data file:

- Variable name
- Field type
- Decimal positions
- Variable description

Metadata is stored in a way that is not straightforward to process:

- Each metadata file has a description header that can span across multiple lines.
- Information about a variable is not stored in a single line, as variable descriptions can span across multiple lines (in an inconsistent way).
- Some metadata files have variable names that are preceded by two asterisks (**). These asterisks are used to denote multiple occurrence columns and the first of them corresponds to a variable that stores codes. Files with multiple occurrence columns end with a NOTE that can span across multiple lines.

Nevertheless, there are some features about metadata files that come in handy:

- Variable names are a single word (i.e., variable names are not separated by spaces).
- Field type is either "Numeric" or "Alphanum." and is always placed after a variable name.
- Decimal positions is a one-digit number that is always placed after field type.

These features allow us to use regular expressions to process metadata files.

#### Metadata Files Scenarios

Metadata files can be classified into different scenarios:

- Scenario 1: All variables are single occurrence (i.e., no variable is preceded by two asterisks). This scenario will be referred as "single".
- Scenario 2: A set of single occurrence variables is followed by a set of multiple occurrence variables. This scenario will be referred as "single_multiple".
- Scenario 3: A set of single occurrence variables followed by a set of multiple occurrence variables is followed by a second set of single occurrence variables. This scenario will be referred as "single_multiple_single".

This classification is important because the corresponding data file has a different structure depending on the scenario.

### Data Files

In general terms, the processing workflow of data files involves:

1. Reading data.
2. Naming columns.
3. Performing pivot operations (if necessary).

Specific operations depend on the metadata file identified structure.

- Scenario 1 ("single"): This is the simplest scenario. The data in the data file is already in the expected format, and the only task is to use the column names specified in the metadata file.

- Scenario 2 ("single_multiple"): In this case, the tabular structure in the data file is not as expected. After single occurrence columns, the multiple occurrence columns are repeated for each code of the "code" variable. To help understanding the previous statement, take a look at the following mock column names: SINGLE1, SINGLE2, CODE10, MULTIPLE1_10, MULTIPLE2_10, CODE20, MULTIPLE1_20, MULTIPLE2_20. CODE, MULTIPLE1 and MULTIPLE2 would appear in the metadata file with preceding double asterisks. In this case, CODE has only codes 10 and 20. To properly name the columns it is necessary to determine the total number of distinct codes. Using naming conventions simplifies pivot operations. Once data columns are properly named, we complete the data processing by applying both long and wide pivots accordingly.

- Scenario 3 ("single_multiple_single"): This is the most complex scenario, currently applicable to only one data file (RCR7). Unlike Scenario 2, there is an additional set of single occurrence columns. The data in the data file has, for each "observation", a row that contains comma separated values of variables that belong to the first set of single occurrence columns, followed by a row for each code of the 'code' variable with comma separated values of multiple occurrence variables, and finally, a row that contains comma separated values of the remaining single occurrence columns. In this case, the initial step of reading the data involves concatenating lines corresponding to the same observation using loops. Once the data is read, the processing is similar to Scenario 2, with the difference that when naming the variables, it is necessary to consider that the repeating columns are in the middle of the dataset. After naming the columns, the processing is the same as in Scenario 2. The resulting dataset differs from the metadata file in that it places all single occurrence columns at the beginning.
