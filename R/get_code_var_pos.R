get_code_var_pos <- function(lines) {

  lines <- trimws(lines)

  lines <- gsub(
    pattern = "\\s+",
    replacement = ",",
    x = lines
  )

  lines <- lines[grepl(
    pattern = "Numeric|Alphanum.",
    x = lines
  )]

  grep(
    pattern = "\\*\\*",
    x = lines
  )

}
