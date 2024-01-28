#' Look up, download and parse meta-data for several study accessions
#'
#' Given a vector of study accessions (GWAS Catalog study IDs starting with
#' `GCST[...]`), download all available meta data and parse them into a
#' data.table with one row per available meta-data `yaml` file.
#'
#' @param study_accessions Character vector. GWAS Catalog study ID(s) to download
#'   meta-data for. Must be an accession number beginning with “GCST”. Use the
#'   package `{gwasrapidd}` or browse the GWAS Catalog website
#'   (https://www.ebi.ac.uk/gwas/) to get accessions for studies you want to
#'   download data from.
#' @inheritParams download_all_accession_data
#' @returns a data.table with n=`length(study_accessions)` rows. Studies with no
#'   available meta-data will have `NA` entries for all fields.
#' @export
download_multiple_accession_meta_data <- function(
    study_accessions,
    harmonised_list = NA,
    directory_list = NA,
    lftp_settings = NA
) {
  result_list <- vector("list", length = length(study_accessions))
  names(result_list) <- study_accessions
  for(i in seq_along(study_accessions)) {
    study_accession <- study_accessions[i]
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
    result_list[[i]] <- all_file_links
    raw_meta_data <- get_accession_meta_data(accession_file_links = result_list[i], lftp_settings = lftp_settings)
    parsed_meta_data <- parse_raw_meta_data(raw_meta_data)
    if(nrow(parsed_meta_data) == 0) {
      data.table::set(
        x = parsed_meta_data,
        j = "accession_name",
        value = study_accession
      )
    }
    result_list[[i]] <- parsed_meta_data
  }
  result_data <- data.table::rbindlist(result_list, use.names = TRUE, fill = TRUE)
  return(result_data)
}
