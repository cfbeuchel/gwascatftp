# From the accession file links, get the meta-data
get_accession_meta_data <- function(
    accession_file_links,
    lftp_settings = NA
){
  stopifnot(
    "Input must be a names list containing the accession number as name and the FTP links in the body." =
      is.list(accession_file_links) & all(!is.na(names(accession_file_links)))
              )

  accession_name <- names(accession_file_links)
  accession_file_links <- unlist(accession_file_links)
  meta_data_files <- grep(
    pattern = "\\-meta\\.yaml$",
    x = accession_file_links,
    value = TRUE
  )
  stopifnot("No meta-data file available from these links!" = length(meta_data_files) > 0)
  meta_data_list <- vector(mode = "list", length = length(meta_data_files))
  for (i in seq_along(meta_data_files)) {
    meta_data_file <- meta_data_files[i]
    meta_data_file_relative_path <- gsub(
      pattern = lftp_settings$ftp_root,
      replacement = "",
      x = meta_data_file)
    print_meta_data_file <- glue::glue("cat {meta_data_file_relative_path}")
    meta_data_raw <- lftp_call(
      lftp_command = print_meta_data_file,
      execute_system_call = TRUE,
      lftp_settings = lftp_settings
    )
    meta_data_file_name <- gsub("^(.*/)([^/]+)$", "\\2", meta_data_file_relative_path)
    meta_data_list[[i]] <- meta_data_raw
    names(meta_data_list)[i] <- meta_data_file_name
  }
  return(meta_data_list)
}
