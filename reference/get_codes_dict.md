# Retrieve dictionary of lookup codes for a specified dataset name

`get_codes_dict()` searches for an internal .rda file in the specified
package and retrieves the codes dictionary based on the provided data
name and naming convention. The naming convention is assumed to include
the data name followed by a double underscore "\_\_".

## Usage

``` r
get_codes_dict(data_name)
```

## Arguments

- data_name:

  A character string specifying the data name to retrieve the codes
  dictionary for.

## Value

A list with the codes dictionary (`codes_dict`) and the associated
variable name (`codes_varname`) if found, otherwise each element will be
NULL.

## Details

`get_codes_dict()` uses the provided data name to construct the expected
naming convention and searches for an internal .rda file in the
specified package. If found, it attempts to retrieve the codes
dictionary using `get` and returns it; otherwise, it returns NULL.

## Examples

``` r
if (FALSE) { # \dontrun{

  rcb_dict <- get_codes_dict("RCB")

  # Access codes dictionary
  rcb_dict$codes_dict

  # Access the name of the variable that stores the codes
  rcb_dict$codes_varname

} # }
```
