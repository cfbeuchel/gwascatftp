install_lftp <- function() {
  github_link <- "https://github.com/lavv17/lftp/releases"
  main_link <- "https://lftp.yar.ru/get.html"
  installation_message <- glue::glue("Please visit `{github_link}` or `{main_link}` to download `lftp` or install it from your distribution's package repository (e.g. `apt install lftp`) or use conda (e.g. `conda create -n lftp lftp`).")
  message(installation_message)
}
