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
