parse_lftp_settings <- function(settings_list = NA){
  stopifnot("Have to supply settings list!" = all(!is.na(settings_list)))
  for (i in seq_along(settings_list)) {
    assign(
      x = names(settings_list[i]),
      value = settings_list[[i]],
      envir = parent.frame()
    )
  }
}
