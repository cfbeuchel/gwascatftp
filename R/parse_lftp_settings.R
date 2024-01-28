#' Make `lftp` settings available
#'
#' This function exports the values in `lftp_settings` to local variables in the
#' function's parent environment.
#'
#' @inheritParams download_all_accession_data
#' @seealso [create_lftp_settings()]
#' @returns Local variables named after the elements of  containing the
#' @export
parse_lftp_settings <- function(lftp_settings = NA){
  stopifnot("Have to supply settings list!" = all(!is.na(lftp_settings)))
  for (i in seq_along(lftp_settings)) {
    assign(
      x = names(lftp_settings[i]),
      value = lftp_settings[[i]],
      envir = parent.frame()
    )
  }
}
