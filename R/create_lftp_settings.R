#' Create the settings for calling `lftp`
#'
#' This function creates a named list containing the necessary settings for
#' calling `lftp` with the function `lftp_call()`.
#'
#' @param lftp_bin Character string. Contains the (absolute) path to the `lftp`
#'   executable on the system. When installed system wide, something like
#'   `/usr/bin/lftp` or simply `lftp` when available in `$PATH`. When `lftp` was
#'   installed in a conda environment, must contain the full path to the binary,
#'   e.g. `~/miniconda3/envs/lftp/bin/lftp` when the environment called `lftp`
#'   was created using `Miniconda3`
#' @param use_proxy Logical. Default is `FALSE`. Whether to connect to the FTP
#'   server with `ftp-over-http-proxy protocol` with the `lftp`-internal setting
#'   `ftp:proxy [URL]`. When `use_proxy = TRUE`, you must set `ftp_proxy` to
#'   specify the `[URL]`.
#' @param ftp_proxy Character string. URL of the proxy server, e.g.
#'   `http://proxy.my-university.com:8080`.
#' @param ftp_root Character string. FTP link to connect to using `lftp`.
#'   Defaults to the GWAS Catalog FTP directory
#'   `ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/`
#'
#' @seealso [lftp_call()]
#'
#' @returns A named list containing the parameters necessary for making a call
#'   to `lftp`
#' @export
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
