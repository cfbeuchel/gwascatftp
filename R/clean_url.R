clean_url <- function(url) {
  cleaned_url <- gsub(pattern = "(?<!:)\\/\\/+", "/", url, perl = T)
  return(cleaned_url)
}
