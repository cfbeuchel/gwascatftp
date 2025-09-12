#' Download a list of all sub-directories of the GWAS Catalog FTP directory
#' `summary_statistics/`
#'
#' Function to get a list of all direct subdirectories of the GWAS Catalog FTP
#' directory `https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/`. The
#' list is used in several functions of this package and should therefore be
#' downloaded once to be used as input for those functions instead of
#' downloading it with every function call.
#'
#' @returns A character vector containing all directories of
#'   `https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/`.
#' @export
get_directory_list <- function() {
  lftp_call_for_dir_list <- lftp_call(
    lftp_command = "cls -1",
    execute_system_call = FALSE
  )
  directory_list <- system(lftp_call_for_dir_list, intern = TRUE)
  directory_list <- gsub("@$", "", directory_list)
  directory_list <- directory_list[directory_list != "harmonised_list.txt"]
  directory_list <- directory_list[grepl("^GCST", directory_list)]
  return(directory_list)
}
