download_all_accession_data <- function(
    study_accession,
    harmonised_list = NA,
    directory_list = NA,
    lftp_settings = NA,
    download_directory = NA,
    create_accession_directory = FALSE,
    overwrite_existing_files = FALSE,
    return_meta_data = TRUE
){
  is_harmonized <- is_available_harmonised(
    study_accession = study_accession,
    harmonised_list = harmonised_list
  )
  all_file_links <- c()
  if(isTRUE(is_harmonized)) {
    harmonised_accession_file_links <- get_harmonised_accession_file_links(
      study_accession = study_accession,
      harmonised_list = study_accession,
      directory_list = directory_list,
      list_all_files = TRUE,
      lftp_settings = lftp_settings
    )
    stopifnot("Accession name mismatch in harmonized data!" = study_accession == names(harmonised_accession_file_links))
    all_file_links <- c(all_file_links, unlist(harmonised_accession_file_links, use.names = FALSE))
  }
  accession_file_links <- get_accession_file_links(
    study_accession = study_accession,
    directory_list = directory_list,
    lftp_settings = lftp_settings)
  stopifnot("Accession name mismatch in data!" = study_accession == names(accession_file_links))
  all_file_links <- c(all_file_links, unlist(accession_file_links, use.names = FALSE))
  all_file_links <- list(all_file_links)
  names(all_file_links) <- study_accession
  download_accession_files_from_ftp(
    accession_file_links = all_file_links,
    download_directory = download_directory,
    create_folder = create_accession_directory,
    overwrite_existing_files = overwrite_existing_files,
    lftp_settings = lftp_settings
  )
  if (isTRUE(return_meta_data)) {
    raw_meta_data <- get_accession_meta_data(
      accession_file_links = all_file_links,
      lftp_settings = lftp_settings
    )
    meta_data <- parse_raw_meta_data(
      raw_meta_data_list = raw_meta_data
    )
    return(meta_data)
  }
}
