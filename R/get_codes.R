get_codes <- function(lines) {
  
  lines <- gsub(
    pattern = "\\*",
    replacement = "",
    x = lines
  )
  
  lines <- trimws(lines)
  
  lines <- gsub(
    pattern = "\\s+", 
    replacement = ",", 
    x = lines
  )
  
  codes <- NULL
  for (i in 1:length(lines)) {
    
    codes[i] <- suppressWarnings(
      as.numeric(
        substr(
          lines[i], 
          start = 1, 
          stop = unlist(
            gregexpr(
              pattern = ",", 
              text = lines[i])
          )[1] - 1
        )
      )
    )
    
  }
  
  codes <- codes[codes >= 10]
  
  sort(codes[!is.na(codes)])
  
  
  
}