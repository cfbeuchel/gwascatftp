% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_raw_meta_data.R
\name{parse_raw_meta_data}
\alias{parse_raw_meta_data}
\title{Return parsed GWAS accession meta-data}
\usage{
parse_raw_meta_data(raw_meta_data_list)
}
\arguments{
\item{raw_meta_data_list}{A named list. Should be used with the output of
`get_accession_meta_data()`}
}
\value{
A data.table containing the parsed meta-data with one row per file.
}
\description{
Function to parse the raw meta-data as downloaded with
`get_accession_meta_data()`.
}
\seealso{
[get_accession_meta_data()]
}
