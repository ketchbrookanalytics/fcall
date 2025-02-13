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

  cli::cli_inform("Table: { table }")

  # Remove any rows that already exist in the table for the period
  n_dropped <- DBI::dbExecute(
    conn = conn,
    statement = delete_statement
  )

  cli::pluralize("Removed { n_dropped } row{?s}") |>
    cli::cli_alert_danger()

  # Append rows from period
  n_added <- DBI::dbAppendTable(
    conn = conn,
    name = table,
    value = data |>
      dplyr::mutate(DATA_PERIOD = period)
  )

  cli::pluralize("Added { n_added } row{?s}") |>
    cli::cli_alert_success()

  cli::cli_rule()

}
