
library(dplyr)
library(readr)
library(tidyr)


# RCB ---------------------------------------------------------------------

a <- c(
  '_INV_CODE', '_BKVAL', '_MKTVAL',
  '_BKVALFORSALE', '_MKTVALFORSALE'
)

b <- c(
  10,15,17,25,29,35,40,41,
  60,52,50,51,62,68,64,69,
  71,72,73,65,86,87,88,66,
  141,142,143,144,145,146,
  95,81,82,99
)


tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")


# RCB2 --------------------------------------------------------------------

a <- c(
  '_name', '_AmortizedCost', '_FairValue', '_DiscountedFairValue',
  '_LiquidityDaysForCategory'
)

b <- c(
  110,120,130,140,150,160,210,220,230,240,310,320,330,340,
  350,410,510
)


tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")


# RCB3 --------------------------------------------------------------------

a <- c(
  "_name", "_SystemwideDebt", "_OtherBankDebt", "_TotalDebt"
)

b <- c(
  110,120,130,140,150,160,170,180,185,190
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")


# RCF ---------------------------------------------------------------------

a <- c("_name", "_NOTPDUE", "_PDUE30",
       "_PDUE90", "_TOTPDUE"
)

b <- c(
  10,20,54,56,60,80
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")


# RCF1 --------------------------------------------------------------------

a <- c(
  "_name", "_ACCR", "_ACCRPDUE",
  "_FRMREST", "_NONCSH", "_NONOTH",
  "_TOTPERF"
)

b <- c(
  100,105,110,115,120,125,130,135,140,145,150,152,155
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")


# RCI2B_2018 --------------------------------------------------------------

a <- c(
  "_name", "_DerivIntRate", "_DerivFX",
  "_DerivOther"
)

b <- c(
  10,20,30,40,50,60,70,80,90,100,110,120,130,140,
  150,160,170,180,190,200,210,220,230
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")


# RCI2C_2018 --------------------------------------------------------------

a <- c(
  "_name", "_ExposureCleared",
  "_ExposureNonCleared"
)

b <- c(
  10,20,30,40,50,70,80,90,100,110,120,140
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")




# RCI2D_2018 --------------------------------------------------------------

a <- c(
  "_name", "_DerivRMLE1Yr",
  "_DerivRMGT1YrLE5Yr",
  "_DerivRMGT5Yr"
)

b <- c(
  10,20,30,40,50,60,70,80,90,100,110
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")


# RCO ---------------------------------------------------------------------

a <- c(
  "_ASSET_CODE", "_TRANSWFCI",
  "_TRANSWNONFCI"
)

b <- c(
  10,20,30,40,50,60,70,80,90,100,110,120
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")
