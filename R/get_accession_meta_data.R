#' From a list of accession file links, download the raw meta-data
#'
#' This function tries to download the meta-data for a GWAS Catalog study
#' accession that is contained in a `yaml` file (ending on `-meta.yaml`) where
#' available. This function receives a names list as input that is the output of
#' the functions `get_harmonised_accession_file_links()` or
#' `get_accession_file_links()`.
#'
#' @param accession_file_links A named list with a vector of character strings.
#'   Use the output of `get_harmonised_accession_file_links()` or
#'   `get_accession_file_links()` as the input for this function.
#' @inheritParams download_all_accession_data
#'
#' @return A named list of raw and unparsed character strings containing the
#'   content of the meta-data yaml file
#'
#' @seealso [parse_raw_meta_data()]
#'
#' @export
get_accession_meta_data <- function(
    accession_file_links,
    lftp_settings = NA
){
  stopifnot(
    "Input must be a names list containing the accession number as name and the FTP links in the body." =
      is.list(accession_file_links) & all(!is.na(names(accession_file_links)))
  )

  accession_name <- names(accession_file_links)
  accession_file_links <- unlist(accession_file_links, use.names = FALSE)
  meta_data_files <- grep(
    pattern = "\\-meta\\.yaml$",
    x = accession_file_links,
    value = TRUE
  )
  meta_data_file_relative_path <- gsub(
    pattern = lftp_settings$ftp_root,
    replacement = "",
    x = meta_data_files)
  result_list <- vector(mode = "list", length = length(meta_data_file_relative_path))
  for(i in seq_along(meta_data_file_relative_path)) {
    meta_data_file <- meta_data_file_relative_path[i]
    print_meta_data_file <- glue::glue("cat {meta_data_file}")
    meta_data_raw <- lftp_call(
      lftp_command = print_meta_data_file,
      execute_system_call = TRUE,
      lftp_settings = lftp_settings
    )
    result_list[[i]] <- meta_data_raw
    names(result_list)[i] <- accession_name
  }
  return(result_list)
}
