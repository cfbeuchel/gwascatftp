#' Find FTP links to all non-harmonised files for a GWAS Catalog study accession
#'
#' This function looks up and returns a vector containing FTP links to all
#' non-harmonised files for a given GWAS Catalog study accession.  To get links
#' to harmonised files where available, use the function
#' [get_harmonised_accession_file_links()].
#'
#' @inheritParams download_all_accession_data
#'
#' @returns A named list containing a character string vector with the FTP links
#'   to all non-harmonised files for the input study accession.
#'
#' @export
get_accession_file_links <- function(
    study_accession,
    directory_list = NA
) {

  stopifnot("Have to supply accession and list!" = (!is.na(study_accession) | all(!is.na(study_accession))))
  check_lftp_settings()
  ftp_root <- options()$gwascatftp.ftp_root
  
  accession_bucket <- find_bucket(
    study_accession = study_accession,
    directory_list = directory_list
  )
  data_directory <- glue::glue("{accession_bucket}/{study_accession}/")
  files_list <- lftp_call(
    path_from_ftp_root = data_directory,
    lftp_command = "cls -1",
    execute_system_call = TRUE
  )
  files_list <- gsub("@$", "", files_list)
  files_list <- files_list[!grepl("harmonised", files_list)]
  files_full_links <- glue::glue("{ftp_root}/{accession_bucket}/{study_accession}/{files_list}")
  files_full_links <- clean_url(files_full_links)
  result_list <- list(files_full_links)
  names(result_list) <- study_accession
  return(result_list)
}
