#' Save the list of all harmonised files from the GWAS Catalog
#'
#' The GWAS Catalog FTP server contains a file with all harmonised data sets at
#' `https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/harmonised_list.txt`.
#' This list is used by several function of this package. With this function,
#' the list is downloaded and can be saved in a variable to avoid repeated
#' remote access of this file. See `https://www.ebi.ac.uk/gwas/docs/faq` for
#' more information on harmonised data in the GWAS Catalog.
#'
#' @return A character vector containing the content of
#'   `https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/harmonised_list.txt`
#' @export
get_harmonised_list <- function() {
  lftp_call_for_harmonised_list <- lftp_call(
    lftp_command = "cat harmonised_list.txt",
    execute_system_call = FALSE
  )
  harmonised_list <- system(lftp_call_for_harmonised_list, intern = TRUE)
  return(harmonised_list)
}
