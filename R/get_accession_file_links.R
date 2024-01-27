# Get links for non-harmonized files
get_accession_file_links <- function(
    study_accession,
    directory_list = NA,
    lftp_settings = NA
) {

  stopifnot("Have to supply accession and list!" = (!is.na(study_accession) | all(!is.na(study_accession))))
  accession_bucket <- find_bucket(
    study_accession = study_accession,
    directory_list = directory_list
  )
  data_directory <- glue::glue("{accession_bucket}/{study_accession}/")
  files_list <- lftp_call(
    path_from_ftp_root = data_directory,
    lftp_command = "cls -1",
    execute_system_call = TRUE,
    lftp_settings = lftp_settings
  )
  files_list <- gsub("@$", "", files_list)
  files_list <- files_list[!grepl("harmonised", files_list)]
  files_full_links <- glue::glue("{lftp_settings$ftp_root}/{accession_bucket}/{study_accession}/{files_list}")
  files_full_links <- clean_url(files_full_links)
  result_list <- list(files_full_links)
  names(result_list) <- study_accession
  return(result_list)
}
