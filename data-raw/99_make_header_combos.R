
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


# RCR3 --------------------------------------------------------------------

a <- c(
  "_RegCapCode", "_AvgDailyCCECET1", "_AvgDailyCCETier2",
  "_AvgDailyCCETotRegCap", "_AvgDailyCCEPermCap"
)

b <- c(
  100,210,220,230,310,320,330,410,420,430,510,520,530,540,600
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")


# RCR7 --------------------------------------------------------------------

a <- c(
  "_RegCapCode", "_AvgDailyCreditExposure", "_CreditConvFactor",
  "_CreditEquil", "_RW0Pct", "_RW2Pct", "_RW4Pct",
  "_RW10Pct", "_RW20Pct", "_RW50Pct", "_RW100Pct",
  "_RW100Pct", "_RW150Pct", "_RW600Pct", "_RW625Pct",
  "_RW937pt5Pct", "_RW1250Pct", "_RWSSFACalc", "_RWGrossUpCalc",

)

b <- c(
  100,210,220,310,320,410,420,430,510,520,600,700,800,900,1000,
  1110,1120,1200,1310,1320,1330,1400,1500,1600,1700,1800,1900,2000,2100
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")


# RID ---------------------------------------------------------------------

a <- c(
  "_CAP_CODE", "_CapStkPurch", "_CAPSTKALLOC",
  "_PREFSTKPERP", "_PREFSTKO", "_PAIDIN",
  "_ALSUR", "_NQASSubj2Retire", "_NQASNotSubj2Retire",
  "_UNRETERN", "_ACNOCOMINC", "_TOTNW"
)

b <- c(
  10,25,35,45,80,70,75,85,95,105,120,130
)

tidyr::expand_grid(b,a) |>
  dplyr::arrange(b) |>
  dplyr::mutate(ans = paste0(b,a)) |>
  readr::write_csv("~/Desktop/foo.csv")
