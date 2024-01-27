# Command to get the list of all harmonized files
get_harmonised_list <- function(
    lftp_settings = NA
) {
  lftp_call_for_harmonised_list <- lftp_call(
    lftp_settings = lftp_settings,
    lftp_command = "cat harmonised_list.txt",
    execute_system_call = FALSE
  )
  harmonised_list <- system(lftp_call_for_harmonised_list, intern = TRUE)
  return(harmonised_list)
}
