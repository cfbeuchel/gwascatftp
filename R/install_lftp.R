#' Provide information for installing `lftp`
#'
#' This package depends on the command-line program `lftp` that must be
#' available on the system to function. It will have to be installed manually by
#' the package user, either globally, or locally using a local environment
#' manager such as `conda`.
#'
#' @returns If `lftp` is already installed, returns the full path to the binary. If not, it prints a helpful message about where and how to install `lftp` from.
#' @export
install_lftp <- function() {
  github_link <- "https://github.com/lavv17/lftp/releases"
  main_link <- "https://lftp.yar.ru/get.html"
  installation_message <- glue::glue(
    "Please visit `{github_link}` or `{main_link}` to download `lftp`",
    " or install it from your distribution's package repository ",
    "(e.g. `apt install lftp`) or use conda (e.g. `conda create -n lftp lftp`)."
  )
  
  whereis_output <- system2("whereis", "lftp", stdout = TRUE)
  whereis_output <- unlist(strsplit(whereis_output, split = " ", fixed = TRUE))
  
  if (length(whereis_output) ==  1) {
    message(installation_message)
    return(NA_character_)
  }
  lftp_bin <- whereis_output[2]
  lftp_help <- system2(lftp_bin, "-h", stdout = TRUE)

  if (lftp_help[1] == "Usage: lftp [OPTS] <site>") {
    message(glue::glue("`lftp` installed on system. Use path: {lftp_bin}"))
    return(lftp_bin)
  } else {
    message(installation_message)
    return(NA_character_)
  }
}
