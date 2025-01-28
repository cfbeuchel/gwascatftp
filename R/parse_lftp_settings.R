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
  stopifnot("Mising required settings (`lftp_bin`, `use_proxy` or `ftp_root`)!" = all(
    !is.na(lftp_settings$lftp_bin),
    !is.na(lftp_settings$use_proxy),
    !is.na(lftp_settings$ftp_root)
    )
    )
  for (i in seq_along(lftp_settings)) {
    assign(
      x = names(lftp_settings[i]),
      value = lftp_settings[[i]],
      envir = parent.frame()
    )
  }
}
