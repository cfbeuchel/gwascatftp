#' Make a call to `lftp` to query the GWAS Catalog
#'
#' Connect to the GWAS Catalog FTP server using `lftp` and execute one or a
#' series of commands.
#'
#' This function is the main interface to the `lftp` command line FTP client
#' that is used in this package to query and download from the GWAS Catalog FTP
#' server at `ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/`.
#' `lftp` and documentation are available from `https://lftp.yar.ru/`.
#'
#' @param path_from_ftp_root Character string. Per default, the `lftp` call will
#'   connect to `ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/`.
#'   Use this value to directly connect to a subdirectory of the default path.
#' @param lftp_command Character string. The `lftp` command to execute after
#'   connecting to the GWAS Catalog FTP server and before quitting. See
#'   `https://lftp.yar.ru/lftp-man.html` for available commands.
#' @param execute_system_call Logical. Whether to execute the call to `lftp`
#'   with `system()` or to return the character string containing the command.
#'
#' @returns The output of the `lftp` call or a character string of the `lftp`
#'   command when `execute_system_call` is set to `FALSE`
#' @export
lftp_call <- function(
    path_from_ftp_root = NA,
    lftp_command = NA,
    execute_system_call = TRUE
) {
  
  check_lftp_settings()
  lftp_bin <- options()$gwascatftp.lftp_bin
  use_proxy <- options()$gwascatftp.use_proxy
  ftp_proxy <- options()$gwascatftp.ftp_proxy
  ftp_root <- options()$gwascatftp.ftp_root
  
  stopifnot("Have to enter a command for `lftp`!" = !is.na(lftp_command))
  
  if (!is.na(path_from_ftp_root)) {
    ftp_path <- glue::glue("{ftp_root}/{path_from_ftp_root}")
  } else {
    ftp_path <- ftp_root
  }
  ftp_path <- clean_url(ftp_path)
  lftp_command <- glue::glue("connect {ftp_path}; {lftp_command}; quit")
  if (use_proxy == TRUE) {
    proxy_command <- glue::glue("set ftp:proxy {ftp_proxy}")
    lftp_command <- paste(proxy_command, lftp_command, sep = "; ")
  }
  full_system_call <- glue::glue("{lftp_bin} -e \"{lftp_command}\" ")
  if (isFALSE(execute_system_call)) {
    return(full_system_call)
  }
  command_output <- system(full_system_call, intern = TRUE)
  return(command_output)
}
