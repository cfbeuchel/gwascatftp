#' Return parsed GWAS accession meta-data
#'
#' Function to parse the raw meta-data as downloaded with
#' `get_accession_meta_data()`.
#'
#' @param raw_meta_data_list A named list. Should be used with the output of
#'   `get_accession_meta_data()`
#'
#' @seealso [get_accession_meta_data()]
#' @returns A data.table containing the parsed meta-data with one row per file.
#' @export
parse_raw_meta_data <- function(
    raw_meta_data_list
) {
  stopifnot("Must be a named list object" = is.list(raw_meta_data_list))
  accession_names <- names(raw_meta_data_list)
  dat <- data.table::data.table(
    accession_name = accession_names
  )
  for (i in seq_along(raw_meta_data_list)) {
    meta_data <- yaml::yaml.load(raw_meta_data_list[[i]])
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
