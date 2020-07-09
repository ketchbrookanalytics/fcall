get_data <- function(directory_name, file_prefix, year_desc = NULL) {
  
  # Define prefix for .TXT description & data files
  if (!is.null(year_desc)) {
    
    desc_file_path <- list.files(
      path = directory_name, 
      pattern = paste0(
        "D_", 
        file_prefix, 
        "_", 
        year_desc, 
        ".TXT"
      )
    )
    
  } else {
    
    desc_file_path <- list.files(
      path = directory_name, 
      pattern = paste0(
        "D_", 
        file_prefix, 
        ".TXT"
      )
    )
    
  }

  # Read lines from source .TXT file
  lines <- suppressWarnings(
    readLines(
      paste0(
        directory_name,
        "/", 
        desc_file_path
      )
    )
  )
  
  # Get the line where the variables start
  vars_start <- which(
    startsWith(
      trimws(lines), 
      "----"
    ) == TRUE
  ) + 1
  
  # Subset 'lines' to start at 'vars_start' 
  lines <- lines[vars_start:length(lines)]
  
  # print(paste0("Dirty Lines: ", lines))
  
  codes <- get_codes(lines = lines)
  
  # print(paste0("Codes: ", codes))
  
  code_pos <- get_code_var_pos(lines = lines)
  
  # print(paste0("Code Positions: ", code_pos))
  
  lines_clean <- clean_lines(lines = lines)
  
  # print("Clean Lines:")
  # print(lines_clean)
  
  # lines_clean[code_pos]
  
  schema <- get_col_info(
    lines = lines_clean, 
    codes = codes, 
    code_pos = code_pos
  )
  
  # print("Schema:")
  # print(schema)
  
  path_to_data <- list.files(
    path = directory_name, 
    pattern = paste0(file_prefix, "_")
  )
  
  if (length(path_to_data > 1)) {
    
    path_to_data <- path_to_data[length(path_to_data)]
    
  }
  
  # Read the data
  read.csv(
    file = paste0(directory_name, "/", path_to_data), 
    header = F, 
    col.names = schema$vars, 
    colClasses = schema$types
  )
  
}
