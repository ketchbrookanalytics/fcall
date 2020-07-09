clean_lines <- function(lines) {
  
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
  
  lines <- lines[grepl(pattern = "Numeric|Alphanum.", x = lines)]
  
  for (i in 1:length(lines)) {
    
    lines[i] <- substr(lines[i], start = 1, stop = unlist(gregexpr(pattern = ",", text = lines[i]))[2] - 1)
    
  }
  
  lines
  
}