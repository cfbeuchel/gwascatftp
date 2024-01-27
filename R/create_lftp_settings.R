create_lftp_settings <- function(
    lftp_bin = "lftp",
    use_proxy = FALSE,
    ftp_proxy = NA,
    ftp_root = "ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/"
) {
  lftp_settings <- list(
    lftp_bin,
    use_proxy,
    ftp_proxy,
    ftp_root
  )
  names(lftp_settings) <- c(
    "lftp_bin",
    "use_proxy",
    "ftp_proxy",
    "ftp_root"
  )
  return(lftp_settings)
}
