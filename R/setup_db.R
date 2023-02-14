library(DBI)
library(glue)

con <- DBI::dbConnect(

)

glue::glue_sql(
  "
  CREATE TABLE inst (
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
    zip char(5) NOT NULL,
  )
  "
)


upload_INST <- function(data) {




}
