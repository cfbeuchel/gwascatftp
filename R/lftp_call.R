lftp_call <- function(
    path_from_ftp_root = NA,
    lftp_command = NA,
    execute_system_call = TRUE,
    lftp_settings = NA
) {
  stopifnot("Have to enter a command for `lftp`!" = !is.na(lftp_command))
  parse_lftp_settings(lftp_settings)

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
