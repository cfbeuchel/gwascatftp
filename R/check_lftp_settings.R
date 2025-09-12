#' Check `lftp` settings availability in session options
#'
#' This function ensures that the `lftp` settings are accessible for the package's functions or returns an error
#'
#' @param verbose Boolean. Whether or not to display a short message after the check
#' @seealso [create_lftp_settings()] and [parse_lftp_settings()]
#' @returns Nothing. Throws an error in case of missing functions
#' @export
check_lftp_settings <- function(verbose = FALSE){
  
  op <- options()
  stopifnot(
    "Missing 'lftp_bin': No path to 'lftp' set!" = !is.null(op$gwascatftp.lftp_bin),
    "Missing 'ftp_root': No path to GWASCatalog FTP root set!" = !is.null(op$gwascatftp.ftp_root),
    "Missing 'use_proxy': No indicator whether behind proxy or not!" = !is.null(op$gwascatftp.use_proxy)
  )
  
  if (isTRUE(op$gwascatftp.use_proxy) && is.null(op$gwascatftp.ftp_proxy)) {
    stop("'use_proxy' is TRUE but ftp_proxy was not set")
  }
  
  lftp_exit <- system2(op$gwascatftp.lftp_bin, "-v", stdout = FALSE, stderr = FALSE)
  if (lftp_exit != 0) {
    stop("Trying to execute 'lftp' returned a non-zero exit code")
  }
  
  if (verbose == TRUE) {
    message("Settings look OK! Give it a try!")
  }
  
  invisible()
}
