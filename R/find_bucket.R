# Get the bucket of an accession
find_bucket <- function(
    study_accession,
    directory_list = NA
) {
  stopifnot(
    "Have to supply accession and directory list! Use `get_harmonised_list()` to generate the list." = (
      !is.na(study_accession) | all(!is.na(directory_list)))
  )
  accession <- as.numeric(gsub("GCST", "", study_accession))
  directory_ranges <- gsub(pattern = "GCST", "", directory_list, fixed = TRUE)
  directory_ranges <- gsub(pattern = "\\/$", "", directory_ranges)
  directory_ranges <- strsplit(directory_ranges, split = "-")
  dat <- data.table::data.table(
    ftp_directory = directory_list,
    lower_dir = as.numeric(sapply(directory_ranges, `[[`, 1)),
    upper_dir = as.numeric(sapply(directory_ranges, `[[`, 2))
  )
  dat[, accession_location := ifelse(
    (accession >= lower_dir) & (accession <= upper_dir),
    TRUE,
    FALSE
  )]
  return(dat[accession_location == TRUE, ftp_directory])
}
