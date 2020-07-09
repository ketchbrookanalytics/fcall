get_col_info <- function(lines, codes, code_pos) {
  
  vars <- NULL
  types <- NULL
  
  for (i in 1:length(lines)) {
    
    if (i %in% code_pos) {
      
      for (j in 1:length(codes)) {
        
        for (k in code_pos) {
          
          vars <- append(
            x <- vars,
            values = paste0(unlist(strsplit(lines[k], split = ","))[1], "_CODE", codes[j])
          )
          
          types <- append(
            x = types, 
            values = unlist(strsplit(lines[k], split = ","))[2]
          )
          
        }
        
        # vars <- append(
        #   x = vars, 
        #   values = paste0(unlist(strsplit(lines[i], split = ","))[1], "_CODE", codes[j])
        # )
        # 
        # types <- append(
        #   x = types, 
        #   values = unlist(strsplit(lines[i], split = ","))[2]
        # )
        
      }
      
    } else {
      
      vars <- append(
        x = vars, 
        values = unlist(strsplit(lines[i], split = ","))[1]
      )
      
      types <- append(
        x = types, 
        values = unlist(strsplit(lines[i], split = ","))[2]
      )
      
    }
    
  }
  
  vars <- unique(vars)
  types <- types[1:length(vars)]
  types <- ifelse(types == "Numeric", "numeric", "character")
  
  list(vars = vars, types = types)
  
}