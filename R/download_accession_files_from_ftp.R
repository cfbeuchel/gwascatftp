download_accession_files_from_ftp <- function(
    accession_file_links,
    download_directory = NA
    lftp_settings = NA
) {
  stopifnot(
    "Input must be a names list containing the accession number as name and the FTP links in the body." =
      is.list(accession_file_links) & all(!is.na(names(accession_file_links)))
  )


}
