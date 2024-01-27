# is the study available harmonized?
is_available_harmonized <- function(
    study_accession = NA,
    harmonised_list = NA
) {
  stopifnot("Have to supply accession and list!" = (all(!is.na(study_accession)) | all(!is.na(harmonised_list))))
  file_available <- any(
    grepl(
      pattern = study_accession,
      x = harmonised_list,
      fixed = TRUE
    )
  )
  return(file_available)
}
