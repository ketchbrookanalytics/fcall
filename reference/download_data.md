# Download FCA Call Report Data and Unzip

Download FCA Call Report Data and Unzip

## Usage

``` r
download_data(year, month, dest, files = NULL, quiet = FALSE)
```

## Arguments

- year:

  (Integer) The year of the Call Report (e.g., `2022`)

- month:

  (String) The month of the Call Report (e.g., `"March"`); you may also
  supply an integer (e.g., `3`) representing the month numerically

- dest:

  (String) The path to the directory where the data will be downloaded
  (and unzipped) into

- files:

  (Optional) Character vector, representing the names of the files in
  the .zip archive to be downloaded; default is `NULL`, meaning all
  files will be downloaded

- quiet:

  (Optional) Logical. Controls whether download progress messages are
  displayed in the console. Defaults to `TRUE`.

## Value

`TRUE` (invisibly) if the data was successfully downloaded and unzipped,
along with a console message informing the user where the data was
downloaded (and unzipped) into. If the data cannot be downloaded (e.g.,
there is no internet connection, the resource is unavailable, or there
is no data for the requested `year` and `month`) or unzipped,
`download_data()` returns `FALSE` (invisibly) with an informative
console message, instead of throwing an error.

## Details

FCA publishes Call Report data quarterly. These .zip files are typically
named "`YYYY`March.zip", "`YYYY`June.zip", "`YYYY`September.zip" and
"`YYYY`December.zip" (where `YYYY` represents the 4-digit year).
Therefore, valid values to the `month` argument should be limited to
`c(3, 6, 9, 12)`, unless there is an anomaly in FCA's
reporting/publishing. Check
<https://www.fca.gov/bank-oversight/call-report-data-for-download> to
ensure the data is available for the quarter you are interested in.
Ketchbrook Analytics downloads these files and stores them in a public
AWS S3 bucket, which is the location that `download_data()` retrieves
them from.

The files in the S3 bucket are identical to those published by FCA, with
one exception: the `RCR7` data files in the March, June, September and
December 2024 .zip files have been corrected to add rows that are
missing from FCA's versions. Without these rows,
[`process_data()`](https://ketchbrookanalytics.github.io/fcall/reference/process_data.md)
fails on the 2024 data. See
<https://github.com/ketchbrookanalytics/fcall/issues/23> for details. If
you need FCA's original 2024 files, download them directly from the FCA
website.

## Examples

``` r
# \donttest{

  path_1 <- tempfile("fcadata1")
  dir.create(path_1)

  download_data(
    year = 2025,
    month = "September",   # using the name of the month
    dest = path_1
  )
#> Files successfully downloaded into /tmp/Rtmpz5Pxvy/fcadata13b2f737e50a

  list.files(path_1)
#>  [1] "D_INST.TXT"                  "D_RC.TXT"                   
#>  [3] "D_RC1.TXT"                   "D_RCB.TXT"                  
#>  [5] "D_RCB2.TXT"                  "D_RCB3.TXT"                 
#>  [7] "D_RCB4.TXT"                  "D_RCB5.TXT"                 
#>  [9] "D_RCF.TXT"                   "D_RCF1.TXT"                 
#> [11] "D_RCG.TXT"                   "D_RCH.TXT"                  
#> [13] "D_RCI1_2018.TXT"             "D_RCI2A_2018.TXT"           
#> [15] "D_RCI2B_2018.TXT"            "D_RCI2C_2018.TXT"           
#> [17] "D_RCI2D_2018.TXT"            "D_RCK.TXT"                  
#> [19] "D_RCL.TXT"                   "D_RCM.TXT"                  
#> [21] "D_RCO.TXT"                   "D_RCR1.TXT"                 
#> [23] "D_RCR2.TXT"                  "D_RCR3.TXT"                 
#> [25] "D_RCR4.TXT"                  "D_RCR5.TXT"                 
#> [27] "D_RCR6.TXT"                  "D_RCR7.TXT"                 
#> [29] "D_RI.TXT"                    "D_RIA.TXT"                  
#> [31] "D_RIB.TXT"                   "D_RIC.TXT"                  
#> [33] "D_RIC1.TXT"                  "D_RID.TXT"                  
#> [35] "D_RIE1.TXT"                  "D_RIE2.TXT"                 
#> [37] "INST_Q202509_G20251112.TXT"  "RC1_Q202509_G20251112.TXT"  
#> [39] "RCB2_Q202509_G20251112.TXT"  "RCB3_Q202509_G20251112.TXT" 
#> [41] "RCB4_Q202509_G20251112.TXT"  "RCB5_Q202509_G20251112.TXT" 
#> [43] "RCB_Q202509_G20251112.TXT"   "RCF1_Q202509_G20251112.TXT" 
#> [45] "RCF_Q202509_G20251112.TXT"   "RCG_Q202509_G20251112.TXT"  
#> [47] "RCH_Q202509_G20251112.TXT"   "RCI1_Q202509_G20251112.TXT" 
#> [49] "RCI2A_Q202509_G20251112.TXT" "RCI2B_Q202509_G20251112.TXT"
#> [51] "RCI2C_Q202509_G20251112.TXT" "RCI2D_Q202509_G20251112.TXT"
#> [53] "RCK_Q202509_G20251112.TXT"   "RCL_Q202509_G20251112.TXT"  
#> [55] "RCM_Q202509_G20251112.TXT"   "RCO_Q202509_G20251112.TXT"  
#> [57] "RCR1_Q202509_G20251112.TXT"  "RCR2_Q202509_G20251112.TXT" 
#> [59] "RCR3_Q202509_G20251112.TXT"  "RCR4_Q202509_G20251112.TXT" 
#> [61] "RCR5_Q202509_G20251112.TXT"  "RCR6_Q202509_G20251112.TXT" 
#> [63] "RCR7_Q202509_G20251112.TXT"  "RC_Q202509_G20251112.TXT"   
#> [65] "RIA_Q202509_G20251112.TXT"   "RIB_Q202509_G20251112.TXT"  
#> [67] "RIC1_Q202509_G20251112.TXT"  "RIC_Q202509_G20251112.TXT"  
#> [69] "RID_Q202509_G20251112.TXT"   "RIE1_Q202509_G20251112.TXT" 
#> [71] "RIE2_Q202509_G20251112.TXT"  "RI_Q202509_G20251112.TXT"   

  path_2 <- tempfile("fcadata2")
  dir.create(path_2)

  download_data(
    year = 2025,
    month = 9,   # using the month number (to refer to September)
    dest = path_2,
    # only download the following files
    files = c(
      "D_INST.TXT",
      "INST_Q202509_G20251112.TXT"
    )
  )
#> Files successfully downloaded into /tmp/Rtmpz5Pxvy/fcadata23b2f30f88cbf

  list.files(path_2)
#> [1] "D_INST.TXT"                 "INST_Q202509_G20251112.TXT"

# }
```
