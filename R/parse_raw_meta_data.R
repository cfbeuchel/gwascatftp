parse_raw_meta_data <- function(
    raw_meta_data_list
) {
  stopifnot("Must be a named list object" = is.list(raw_meta_data_list))
  meta_data_file_names <- names(raw_meta_data_list)
  dat <- data.table::data.table(
    file_name = meta_data_file_names
  )
  for (i in seq_along(raw_meta_data_list)) {
    meta_data <- yaml::yaml.load(unlist(raw_meta_data_list[[i]]))
    for (j in seq_along(meta_data)) {
      my_entry <- unlist(meta_data[j])
      if (length(my_entry) != 1) {
        my_entry <- paste(my_entry, collapse = "; ")
      }
      data.table::set(dat, i = i, j = names(meta_data[j]), value = my_entry)
    }
  }
  return(dat)
}
