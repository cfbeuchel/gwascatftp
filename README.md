
# `gwascatftp` - Access the GWAS Catalog FTP server from R

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

This R package provides functions to interact with the [GWAS
Catalog](https://www.ebi.ac.uk/gwas/)'s [FTP
server](ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/) that are (as
far as I know) not available in the [GWAS Catalog
API](https://www.ebi.ac.uk/gwas/rest/docs/api) and by extension the R package
[`{gwasrapidd}`](https://github.com/ramiromagno/gwasrapidd). It
provides wrapper functions that call to [`lftp`](https://lftp.yar.ru/), a
command-line file transfer program.

The main goal of `{gwascatftp}` is to query the GWAS Catalog FTP server with a
user-provided study accession (e.g. `GCST009541`) and:

1. Find all associated files (documentation, meta-data, summary statistics files)
2. Identify whether [harmonised summary statistics](https://www.ebi.ac.uk/gwas/docs/methods/summary-statistics) are available
3. Download & parse the `yaml` meta-data file
4. Download all available files from the FTP server
5. Work from behind an institution's HTTP proxy server (e.g. from a university HPC cluster)

## Use Case 

This package wants to cover this basic use case: You read a GWAS paper about
heart failure that that makes summary statistics available on the GWAS Catalog
under the study accession `GCST90162626`. You want to use the full summary
statistics for your own research. In R, `{gwasrapidd}` can be used to query the
Catalog's API to download association summary statistics with genome-wide
significance, but not the full summary statistics. These are available from the
FTP server, but the links to those files are not available in the data the API
provides. Instead, you have to have to go to the study website at
[`https://www.ebi.ac.uk/gwas/studies/GCST90162626`](https://www.ebi.ac.uk/gwas/studies/GCST90162626),
click on the [`FTP
Download`](http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90162001-GCST90163000/GCST90162626)
link and then manually copy the links to each file and download them using
`wget`, `curl`, or a similar program. Wouldn't it be much easier to do this from
within `R`, without having to manually search the FTP server in your web browser
for the links to the file? Especially when trying to download data for several
studies, this can be tedious. That is where `{gwascatftp}` comes in. It provides
a simple interface to access the GWAS Catalog FTP server using only the study
accession from within R to find and download all files associated with a
specific study accession.

## Installation

You can install the development version of `gwascatftp` from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
remotes::install_github("cfbeuchel/gwascatftp")
```

## Prerequisites

This package requires an installation of [`lftp`](https://lftp.yar.ru/) and the
path of the program's executable file. To get basic installation information
from within the package, call the `install_lftp()` function.

```r
library(gwascatftp)
install_lftp()
```

An easy way to install `lftp` without root access is to use
[`conda`](https://conda.io/projects/conda/en/latest/user-guide/getting-started.html).
See below for the commands to install `lftp` in a fresh `conda` environment and
identify the `lftp` binary's path with `whereis`. If you do not have `lftp`
installed in your system's `$PATH` (which it is not unless you activate the
environment from within your R session), you need to provide the full path when
using `{gwascatftp}`.

```bash
conda create -n lftp -c conda-forge lftp
conda activate lftp
whereis lftp
#> e.g. `~/miniconda3/envs/lftp/bin/lftp`
```

## Getting Started

Before using the package, make sure you have `lftp` installed and know where the
executable is located. When using `conda`, this should hopefully work on most
systems.

Due to interfacing with `lftp`, we need to create a simple list containing the
basic settings for getting `lftp` to run.

```r
# This returns a named list to be passed to functions calling `lftp`
my_lftp_settings <- create_lftp_settings(
  lftp_bin = "~/miniconda3/envs/lftp/bin/lftp", # Enter your path here!
  use_proxy = FALSE, # When behind a HTTP proxy, set to TRUE
  ftp_proxy = NA, # When behind a HTTP proxy, enter the link, e.g. http://proxy.my_uni.com:8080"
  ftp_root = "ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/"
)
```

When querying the GWAS Catalog, two large lists are used often. To avoid
repeatedly downloading these files, we will download them once, save them in
variables and supply those to the functions using them.

```r
my_directory_list <- get_directory_list(lftp_settings = my_lftp_settings)
my_harmonised_list <- get_harmonised_list(lftp_settings = my_lftp_settings)
```

Now we can query the GWAS Catalog FTP server using accession names. The most
high-level function is `download_all_accession_data()`, that, given a GWAS
Catalog study accession, will try to download all available files for that
accession and return the parsed meta data when available.

```r
# Supply a single accession you want to download the data from
my_study_accession <- "GCST009541"

# Call the function with all the necessary data, including the settings and pre-downloaded lists
download_all_accession_data(
    study_accession = my_study_accession,
    harmonised_list = my_harmonised_list,
    directory_list = my_directory_list,
    lftp_settings = my_lftp_settings,
    download_directory = "/PATH/TO/DOWNLOAD/TO/",
    create_accession_directory = TRUE,
    overwrite_existing_files = FALSE,
    return_meta_data = TRUE
)
```

The second high-level function, `download_multiple_accession_meta_data()` will
accept a vector of study accessions and return a `data.table` containing all
meta data available for each accession's `[...]-meta.yaml` files if available.

```r
# Prepare a list of GWAS IDs
my_mulltiple_study_accessions <- c("GCST009541", "GCST90204201")

# Call the functions including the necessary lists to download the meta data
my_meta_data <- download_multiple_accession_meta_data(
  study_accessions = my_mulltiple_study_accessions, 
  harmonised_list = my_harmonised_list, 
  directory_list = my_directory_list, 
  lftp_settings = my_lftp_settings
)
```

## See Also

* The far more extensive package to query the GWAS Catalog API is {gwasrapidd}: [https://github.com/ramiromagno/gwasrapidd/](https://github.com/ramiromagno/gwasrapidd/)
* The package {MungeSumstats} provides an interface to the [MRC IEU openGWAS Project](https://gwas.mrcieu.ac.uk/): https://github.com/neurogenomics/MungeSumstats
* The GWAS Catalog has extensive documentation at [https://www.ebi.ac.uk/gwas/docs](https://www.ebi.ac.uk/gwas/docs)
* Browse the GWAS Catalog FTP Server at [https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/](https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/)
