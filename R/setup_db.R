library(DBI)
library(glue)

con <- DBI::dbConnect(

)

# Create "institution" schema for the `INST.txt` file
glue::glue_sql(
  "
  CREATE TABLE institution (
    system int NOT NULL,
    district int NOT NULL,
    association int NOT NULL,
    month int NOT NULL,
    year int NOT NULL,
    uninum int NOT NULL,
    short_name varchar(50) NOT NULL,
    mailing_address varchar(60) NOT NULL,
    street_address varchar(60) NOT NULL,
    city varchar(30) NOT NULL,
    state char(2) NOT NULL,
    zip char(5) NOT NULL
  )
  "
)


upload_institution <- function(data) {



}



# Create "balance_sheet" schema for the `INST.txt` file
glue::glue_sql(
  "
  CREATE TABLE balance_sheet (
    system int NOT NULL,
    district int NOT NULL,
    association int NOT NULL,
    month int NOT NULL,
    year int NOT NULL,
    uninum int NOT NULL,
    cash numeric NOT NULL,
    accounts_receivable numeric NOT NULL,
    accrual_loans numeric NOT NULL,
    notes_receivable_from_other_fcs_institutions numeric NOT NULL,
    other_notes_receivable numeric NOT NULL,
    accrual_sales_contracts numeric NOT NULL,
    nonaccrual_loans numeric NOT NULL,
    allowance_for_loan_losses numeric NOT NULL,
    net_loans numeric NOT NULL,
    ...
  )
  "
)
