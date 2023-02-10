
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
