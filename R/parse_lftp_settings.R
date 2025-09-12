#' Make `lftp` settings available
#'
#' This function exports the values in `lftp_settings` to the session's options in the
#' function's parent environment. This overrides all settings, so make sure the 
#' list supplied to `lftp_settings` contains all neccessary elements!
#'
#' @param lftp_settings List. The settings to parse as session-wide options. By default
#' this list is automatically created by calling `create_lftp_settings()` but when settings
#' need to be manually adapted, the user needs to supply the custom settings
#'  to `create_lftp_settings()`. 
#' @param check_settings Logical. Whether or not to run `check_lftp_settings()` 
#' on the parsed settings. Default is FALSE 
#' @seealso [create_lftp_settings()]
#' @returns Nothing. Check `options()` to see changes.
#' @export
parse_lftp_settings <- function(
    lftp_settings = create_lftp_settings(),
    check_settings = FALSE
){
  stopifnot("Mising required settings (`lftp_bin`, `use_proxy`, `ftp_root`)!" = any(
    !is.na(lftp_settings$gwascatftp.lftp_bin),
    !is.na(lftp_settings$gwascatftp.use_proxy),
    !is.na(lftp_settings$gwascatftp.ftp_root)
  )
  )
  op.gwascatftp <- lftp_settings
  options(op.gwascatftp)
  
  if (check_settings == TRUE) {
    check_lftp_settings(verbose = TRUE)
  }
}
