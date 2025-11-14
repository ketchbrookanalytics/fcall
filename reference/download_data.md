# Download data from FCA website

Download data from FCA website

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

Console message informing the user where the data was successfully
downloaded (and unzipped) into

## Details

FCA publishes Call Report data quarterly. These .zip files are typically
named "`YYYY`March.zip", "`YYYY`June.zip", "`YYYY`September.zip" and
"`YYYY`December.zip" (where `YYYY` represents the 4-digit year).
Therefore, valid values to the `month` argument should be limited to
`c(3, 6, 9, 12)`, unless there is an anomaly in FCA's
reporting/publishing. Check
<https://www.fca.gov/bank-oversight/call-report-data-for-download> to
ensure the data is available for the quarter you are interested in.

## Examples

``` r
# \donttest{

  path_1 <- tempfile("fcadata")

  download_data(
    year = 2022,
    month = "December",   # using the name of the month
    dest = path_1
  )
#> Files successfully downloaded into /tmp/RtmpzhZ4et/fcadata40432ab5f9c7

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
#> [35] "D_RIE.TXT"                   "INST_Q202212_G20250814.TXT" 
#> [37] "RC1_Q202212_G20250814.TXT"   "RCB2_Q202212_G20250814.TXT" 
#> [39] "RCB3_Q202212_G20250814.TXT"  "RCB4_Q202212_G20250814.TXT" 
#> [41] "RCB5_Q202212_G20250814.TXT"  "RCB_Q202212_G20250814.TXT"  
#> [43] "RCF1_Q202212_G20250814.TXT"  "RCF_Q202212_G20250814.TXT"  
#> [45] "RCG_Q202212_G20250814.TXT"   "RCH_Q202212_G20250814.TXT"  
#> [47] "RCI1_Q202212_G20250814.TXT"  "RCI2A_Q202212_G20250814.TXT"
#> [49] "RCI2B_Q202212_G20250814.TXT" "RCI2C_Q202212_G20250814.TXT"
#> [51] "RCI2D_Q202212_G20250814.TXT" "RCK_Q202212_G20250814.TXT"  
#> [53] "RCL_Q202212_G20250814.TXT"   "RCM_Q202212_G20250814.TXT"  
#> [55] "RCO_Q202212_G20250814.TXT"   "RCR1_Q202212_G20250814.TXT" 
#> [57] "RCR2_Q202212_G20250814.TXT"  "RCR3_Q202212_G20250814.TXT" 
#> [59] "RCR4_Q202212_G20250814.TXT"  "RCR5_Q202212_G20250814.TXT" 
#> [61] "RCR6_Q202212_G20250814.TXT"  "RCR7_Q202212_G20250814.TXT" 
#> [63] "RC_Q202212_G20250814.TXT"    "RIA_Q202212_G20250814.TXT"  
#> [65] "RIB_Q202212_G20250814.TXT"   "RIC1_Q202212_G20250814.TXT" 
#> [67] "RIC_Q202212_G20250814.TXT"   "RID_Q202212_G20250814.TXT"  
#> [69] "RIE_Q202212_G20250814.TXT"   "RI_Q202212_G20250814.TXT"   

  path_2 <- tempfile("fcadata")

  download_data(
    year = 2023,
    month = 9,   # using the month number (to refer to September)
    dest = path_2,
    # only download the following files
    files = c(
      "D_INST.TXT",
      "INST_Q202309_G20231106.TXT"
    )
  )
#> Warning: requested file not found in the zip file
#> Files successfully downloaded into /tmp/RtmpzhZ4et/fcadata4043486d14c9

  list.files(path_2)
#> [1] "D_INST.TXT"

# }
```
