create_tables <- function(conn, metadata) {

  purrr::iwalk(metadata, function(metadata, name) {
    create_single_table(conn, name, metadata$vars_info)
  })

}

create_single_table <- function(conn, table_name, vars_info) {

  message(glue::glue("#### Creating table: { table_name }"))

  columns_definitions <- vars_info |>
    dplyr::mutate(
      ColumnTypeSQL = dplyr::case_when(
        ColumnType == "Alphanum." ~ "text",
        ColumnType == "Numeric" & DecimalPosition == 0 ~ "integer",
        ColumnType == "Numeric" & DecimalPosition > 0 ~ "float"
      ),
      ColumnDefinitionSQL = paste(ColumnName, ColumnTypeSQL)
    ) |>
    dplyr::pull(ColumnDefinitionSQL) |>
    paste0(collapse = ",\n")

  create_table_statement <- glue::glue("
    create table { table_name }
    (
    { columns_definitions }
    );
  ")

  # Print to console
  message(create_table_statement)

  # Create table
  DBI::dbSendQuery(
    conn = conn,
    statement = create_table_statement
  )

  # table_comment_statement <- glue::glue("
  #   comment on table { table_name } is '{ table_comment }';
  # ")
  #
  # # Print to console
  # message(table_comment_statement)
  #
  # # Add table comment
  # DBI::dbSendQuery(
  #   conn = conn,
  #   statement = table_comment_statement
  # )

  columns_comments <- vars_info |>
    dplyr::mutate(
      Definition = gsub("'", "", Definition), # Presence of ' in Definition throws error
      ColumnCommentSQL = glue::glue("comment on column { table_name }.{ ColumnName } is '{ Definition }'")
    ) |>
    dplyr::pull(ColumnCommentSQL)

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
