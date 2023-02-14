
con <- DBI::dbConnect(

)

glue::glue_sql(
  "
  CREATE TABLE inst (
    SYSTEM int NOT NULL,
    DIST int NOT NULL,
    ASSOC int NOT NULL,
    MONTH int NOT NULL,
    YEAR int NOT NULL,
    UNINUM int NOT NULL,
    SHORTNAME varchar(50) NOT NULL,
    MAIL_ADDR varchar(60) NOT NULL,
    STREET_ADDR varchar(60) NOT NULL,
    CITY varchar(30) NOT NULL,
    STATE char(2) NOT NULL,
    ZIP char(5) NOT NULL,
  )
  "
)


upload_INST <- function(data) {




}
