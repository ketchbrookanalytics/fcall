#' @noRd
append_data <- function(conn, data, period) {

  purrr::iwalk(data, function(data, name) {
    append_single_data(conn, name, data, period)
  })

}

#' @noRd
append_single_data <- function(conn, table, data, period) {

  # Clean period from table (to avoid duplicates)
  delete_statement <- glue::glue("
    delete from \"{ table }\"
      where \"DATA_PERIOD\" = '{ period }'
  ")

  # Inform user
  message(glue::glue("Step 1/2: Removing { period } data from { table }"))

  # Remove any rows that already exist in the table for the period
  n_dropped <- DBI::dbExecute(
    conn = conn,
    statement = delete_statement
  )

  # Inform user
  message(glue::glue("Step 2/2: Adding { period } data to { table }"))

  # Append rows from period
  DBI::dbWriteTable(
    conn = conn,
    name = table,
    value = data |>
      dplyr::mutate(DATA_PERIOD = period),
    append = TRUE,
    row.names = FALSE
  )

  # Inform user
  message(glue::glue("{ period } data added to { table }"))

}
