.onLoad <- function(libname, pkgname) {
  
  packageStartupMessage("Trying to set required options")
  lftp_path <- install_lftp()
  if (!is.na(lftp_path)) {
    packageStartupMessage("Found ´lftp´ executable on system. Automatically setting options up for usage")
  } else {
    packageStartupMessage("Did not find ´lftp´ executable on system. Please use `create_lftp_settings()` and then `parse_lftp_settings()`")
  }
  
  lftp_settings <- create_lftp_settings(
    lftp_bin = lftp_path
  )
  op <- options()
  op.gwascatftp <- lftp_settings
  toset <- !(names(op.gwascatftp) %in% names(op))
  if (any(toset)) options(op.gwascatftp[toset])
  
  invisible()
}

.onUnload <- function(libname, pkgname) {

  .Options$gwascatftp.ftp_proxy <- NULL
  options(gwascatftp.ftp_proxy = NULL)
  .Options$gwascatftp.lftp_bin <- NULL
  options(gwascatftp.lftp_bin = NULL)
  .Options$gwascatftp.use_proxy <- NULL
  options(gwascatftp.use_proxy = NULL)
  .Options$gwascatftp.ftp_root <- NULL
  options(gwascatftp.ftp_root = NULL)
  
  
  
}