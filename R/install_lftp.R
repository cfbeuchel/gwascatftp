#' Provide information for installing `lftp`
#'
#' This package depends on the command-line program `lftp` that must be
#' available on the system to function. It will have to be installed manually by
#' the package user, either globally, or locally using a local environment
#' manager such as `conda`.
#'
#' @returns Nothing. Prints a helpful message about where and how to install `lftp` from.
#' @export
install_lftp <- function() {
  github_link <- "https://github.com/lavv17/lftp/releases"
  main_link <- "https://lftp.yar.ru/get.html"
  installation_message <- glue::glue("Please visit `{github_link}` or `{main_link}` to download `lftp` or install it from your distribution's package repository (e.g. `apt install lftp`) or use conda (e.g. `conda create -n lftp lftp`).")
  message(installation_message)
}
