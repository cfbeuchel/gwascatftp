#' Download Files from the GWAS Catalog FTP Server
#'
#' This files takes a named list of FTP links as input and downloads all files to a local directory. To download all data for a GWAS Catalog study, most users will probably want to use `download_all_accession_data()` instead of this function.
#'
#' @inheritParams download_all_accession_data
#' @inheritParams get_accession_meta_data
#'
#' @seealso [download_all_accession_data()]
#'
#' @return Nothing. Will download files into `download_directory`.
#' @export
download_accession_files_from_ftp <- function(
    accession_file_links,
    download_directory = NA,
    create_accession_directory = FALSE,
    overwrite_existing_files = FALSE,
    lftp_settings = NA
) {
  stopifnot(
    "Input must be a named list containing the accession number as name and the FTP links in the body." =
      is.list(accession_file_links) & all(!is.na(names(accession_file_links)))
  )
  stopifnot("Please provide a directory to store the downloaded files in." = !is.na(download_directory))
  accession_name <- names(accession_file_links)
  accession_file_links <- unlist(accession_file_links, use.names = FALSE)
  if(isTRUE(create_accession_directory)) {
    download_directory <- paste(download_directory, accession_name, sep = "/")
    download_directory <- paste0(download_directory, "/")

  }
  download_directory <- clean_url(download_directory)
  if(!dir.exists(download_directory)) {
    dir.create(download_directory)
  }
  accession_file_links_relative_paths <- gsub(
    pattern = lftp_settings$ftp_root,
    replacement = "",
    accession_file_links,
    fixed = TRUE
      )
  if (isTRUE(overwrite_existing_files)) {
    overwrite_settings <- "set xfer:clobber yes"
  } else {
    overwrite_settings <- "set xfer:clobber no"
  }
  for (i in seq_along(accession_file_links_relative_paths)) {
    file <- accession_file_links_relative_paths[i]
    download_file_command <- glue::glue("get {file} -o {download_directory}")
    download_file_command <- paste(overwrite_settings, download_file_command, sep = "; ")
    message(glue::glue("Downloading: `{file}`..."))
    lftp_call(
      lftp_command = download_file_command,
      execute_system_call = TRUE,
      lftp_settings = lftp_settings
    )
  }
  message(glue::glue("All files downloaded to: `{download_directory}`."))
}
