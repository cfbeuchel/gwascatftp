#' Download all GWAS Catalog Data for a Study Accession
#'
#' `download_all_accession_data()` uses the `lftp` FTP client to look up and
#' download all available data (meta-data, summary statistics, etc.) for a
#' study, identified by the accession `GCST[...]`, from the GWAS Catalog. For
#' instance, to download all data of the study listed at
#' `https://www.ebi.ac.uk/gwas/studies/GCST90162626`, use `GCST90162626` as the
#' input for `study_accession`.
#'
#' @param study_accession single character string Input. GWAS Catalog study ID
#'   to download data for. Must be an accession number beginning with “GCST”.
#'   Use the package `{gwasrapidd}` or browse the GWAS Catalog website
#'   (https://www.ebi.ac.uk/gwas/) to get accessions for studies you want to
#'   download data from.
#' @param harmonised_list character vector. Use `get_harmonised_list()` to
#'   create. Contains the content of the FTP file
#'   `ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/harmonised_list.txt`.
#'   Should be downloaded once and saved in a variable to be then passed to
#'   functions using this field.
#' @param directory_list character vector. Use `get_directory_list()` to create.
#'   Should be downloaded once and saved in a variable to be then passed to
#'   functions using this field.
#' @param lftp_settings named list. Use `create_lftp_settings()` to create.
#' @param download_directory character string. Output file directory. Downloaded
#'   files will retain their names.
#' @param create_accession_directory logical. `TRUE`/`FALSE` for whether a new
#'   directory named after `study_accession` should be created in
#'   `download_directory`  to save all downloaded files in.
#' @param overwrite_existing_files logical. `TRUE`/`FALSE` for whether identical
#'   output files found in `download_directory` should be overwritten.
#' @param return_meta_data logical. `TRUE`/`FALSE` for whether to return the
#'   study accessions meta-data (if available as `yaml` file) in a data.table
#'   with one row per found file.
#'
#' @return If `return_meta_data` is set to `TRUE`, returns a data.table
#'   containing one row per meta-data yaml file found for the given study.
#'
#' @seealso [create_lftp_settings], [get_harmonised_list] and
#'   [get_directory_list] that are used to create required input files for this
#'   function.
#'
#' @export
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
      harmonised_list = harmonised_list,
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
    create_accession_directory = create_accession_directory,
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
