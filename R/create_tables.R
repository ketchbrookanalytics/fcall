#' @noRd
create_tables <- function(conn, metadata) {

  purrr::iwalk(metadata, function(metadata, name) {
    create_single_table(conn, name, metadata$vars_info)
  })

}

#' @noRd
create_single_table <- function(conn, table_name, vars_info) {

  message(glue::glue("#### Creating table: { table_name }"))

  # Extract table fields from vars_info
  fields <- vars_info$ColumnTypeSQL
  names(fields) <- vars_info$ColumnName

  # Add column to store period information
  fields <- append(fields, c("DATA_PERIOD" = "text"))

  DBI::dbCreateTable(
    conn = conn,
    name = table_name,
    fields = fields
  )

  # Prepare column comments
  columns_comments <- vars_info |>
    dplyr::mutate(
      # Single quotes are not supported by default in PostgreSQL
      # Check: https://stackoverflow.com/questions/12316953/insert-text-with-single-quotes-in-postgresql
      Definition = gsub("'", "''", .data$Definition),
      # PostgreSQL is not case sensitive by default. For that reason, the use of " " is needed.
      ColumnCommentSQL = glue::glue("comment on column \"{ table_name }\".\"{ ColumnName }\" is '{ Definition }'")
    ) |>
    dplyr::pull("ColumnCommentSQL")

  # Add column comments
  purrr::iwalk(columns_comments, function(comment, index) {

    # Print to console
    message(glue::glue("({ index } / { nrow(vars_info) }): { comment }"))

    DBI::dbSendQuery(
      conn = conn,
      statement = comment
    )

  })

}
