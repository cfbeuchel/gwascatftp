#' Find the FTP directory of a study accession
#'
#' For a given GWAS Catalog study accession, identify the directory containing
#' study data on the GWAS Catalog FTP server at
#' `https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/`.
#'
#' On the GWAS Catalog FTP server, all study directories are located in
#' subdirectories covering a range of study IDs. For example, the directory
#' `GCST000001-GCST001000/` contains all studies whose numeric part of their ID
#' lies between 1-1000. This function simply returns this subdirectory.
#'
#' @inheritParams download_all_accession_data
#'
#' @returns The relative path from
#'   `ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/` of the directory
#'   containing the data of the input study accession (e.g.
#'   `	GCST000001-GCST001000/`).
#'
#' @import data.table
#'
#' @export
find_bucket <- function(
    study_accession,
    directory_list = NA
) {
  stopifnot(
    "Have to supply accession and directory list! Use `get_harmonised_list()` to generate the list." = (
      !is.na(study_accession) | all(!is.na(directory_list)))
  )
  accession <- as.numeric(gsub("GCST", "", study_accession))
  directory_ranges <- gsub(pattern = "GCST", "", directory_list, fixed = TRUE)
  directory_ranges <- gsub(pattern = "\\/$", "", directory_ranges)
  directory_ranges <- strsplit(directory_ranges, split = "-")
  dat <- data.table::data.table(
    ftp_directory = directory_list,
    lower_dir = as.numeric(sapply(directory_ranges, `[[`, 1)),
    upper_dir = as.numeric(sapply(directory_ranges, `[[`, 2))
  )
  dat[, accession_location := ifelse(
    (accession >= lower_dir) & (accession <= upper_dir),
    TRUE,
    FALSE
  )]
  return(dat[accession_location == TRUE, ftp_directory])
}
