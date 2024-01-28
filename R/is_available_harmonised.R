#' Check if harmonised GWAS Catalog files are available for a study
#'
#' A function to check whether harmonised files are available for a GWAS
#' Catalog study accession. See `https://www.ebi.ac.uk/gwas/docs/faq` for
#' information on harmonised GWAS Catalog study data.
#'
#' @inheritParams download_all_accession_data
#' @return A logical value `TRUE`/`FALSE` for whether harmonised data files are
#'   available for a given study accession.
#' @export
is_available_harmonised <- function(
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
