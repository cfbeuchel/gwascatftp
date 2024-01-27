# Get only the harmonised data file link or all files in the harmonised/ directory
get_harmonised_accession_file_links <- function(
    study_accession,
    harmonised_list = NA,
    directory_list = NA,
    list_all_files = TRUE,
    lftp_settings = NA
){
  stopifnot("Have to supply accession and list!" = (!is.na(study_accession) | all(!is.na(directory_list))))
  if (
    isFALSE(
      is_available_harmonised(
        study_accession = study_accession,
        harmonised_list = harmonised_list
      )
    )
  ) {
    result_list <- list(NA)
    names(result_list) <- study_accession
    return(result_list)
  }
  if (isFALSE(list_all_files)) {
    relative_path <- grep(
      pattern = study_accession,
      x = harmonised_list,
      fixed = TRUE,
      value = TRUE
    )
    relative_path <- gsub("^\\.\\/", "", relative_path)
    full_ftp_path <- glue::glue("{lftp_settings$ftp_root}{relative_path}")
    full_ftp_path <- clean_url(full_ftp_path)
    result_list <- list(full_ftp_path)
    names(result_list) <- study_accession
    return(result_list)
  }
  accession_bucket <- find_bucket(
    study_accession = study_accession,
    directory_list = directory_list
  )
  harmonised_data_directory <- glue::glue("{accession_bucket}/{study_accession}/harmonised")
  harmonised_files_list <- lftp_call(
    path_from_ftp_root = harmonised_data_directory,
    lftp_command = "cls -1",
    execute_system_call = TRUE,
    lftp_settings = lftp_settings
  )
  harmonised_files_list <- gsub("@$", "", harmonised_files_list)
  harmonised_files_full_links <- glue::glue("{lftp_settings$ftp_root}/{accession_bucket}/{study_accession}/harmonised/{harmonised_files_list}")
  harmonised_files_full_links <- clean_url(harmonised_files_full_links)
  result_list <- list(harmonised_files_full_links)
  names(result_list) <- study_accession
  return(result_list)
}
