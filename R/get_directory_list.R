get_directory_list <- function(
    lftp_settings = NA
) {
  lftp_call_for_dir_list <- lftp_call(
    lftp_command = "cls -1",
    execute_system_call = FALSE,
    lftp_settings = lftp_settings
  )
  directory_list <- system(lftp_call_for_dir_list, intern = TRUE)
  directory_list <- gsub("@$", "", directory_list)
  directory_list <- directory_list[directory_list != "harmonised_list.txt"]
  return(directory_list)
}
