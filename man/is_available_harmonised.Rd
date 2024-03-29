% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/is_available_harmonised.R
\name{is_available_harmonised}
\alias{is_available_harmonised}
\title{Check if harmonised GWAS Catalog files are available for a study}
\usage{
is_available_harmonised(study_accession = NA, harmonised_list = NA)
}
\arguments{
\item{study_accession}{single character string Input. GWAS Catalog study ID
to download data for. Must be an accession number beginning with “GCST”.
Use the package `{gwasrapidd}` or browse the GWAS Catalog website
(https://www.ebi.ac.uk/gwas/) to get accessions for studies you want to
download data from.}

\item{harmonised_list}{character vector. Use `get_harmonised_list()` to
create. Contains the content of the FTP file
`ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/harmonised_list.txt`.
Should be downloaded once and saved in a variable to be then passed to
functions using this field.}
}
\value{
A logical value `TRUE`/`FALSE` for whether harmonised data files are
  available for a given study accession.
}
\description{
A function to check whether harmonised files are available for a GWAS
Catalog study accession. See `https://www.ebi.ac.uk/gwas/docs/faq` for
information on harmonised GWAS Catalog study data.
}
