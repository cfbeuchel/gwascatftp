
# `gwascatftp` - Access the GWAS Catalog FTP server from R

<!-- badges: start -->
<!-- badges: end -->

This R package provides functions to interact with the [GWAS
Catalog's](https://www.ebi.ac.uk/gwas/) [FTP
server](ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/) that are (as
far as I know) not covered by the [GWAS CATALOG
API](https://www.ebi.ac.uk/gwas/rest/docs/api) and by extension the R package
[`{gwasrapidd}`](https://github.com/ramiromagno/gwasrapidd). To do this, it
provides wrapper functions that call to [`lftp`](https://lftp.yar.ru/), a
command-line file transfer program.

The main goal of `{gwascatftp}` is to query the GWAS Catalog FTP server with a
user-provided study accession (e.g. `GCST009541`) and:

1. Find all associated files (documentation, meta-data, summary statistics files)
2. Identify whether [harmonised summary statistics](https://www.ebi.ac.uk/gwas/docs/methods/summary-statistics) are available
3. Download & parse the `yaml` meta-data file
4. Download all available files from the FTP server
5. Work from behind an institution's HTTP proxy server (e.g. from a university HPC cluster)

## Installation

You can install the development version of gwascatftp from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cfbeuchel/gwascatftp")
```

## Prerequisites

This package requires an installation of [`lftp`](https://lftp.yar.ru/) and the
path of the program's executable file. To get basic installation information
from within the package, call the `install_lftp()` function (`still a
placeholder`).

``` r
library(gwascatftp)
install_lftp()
```

A very easy way to install `lftp` without root access is to use
[`conda`](https://conda.io/projects/conda/en/latest/user-guide/getting-started.html).
See an example below to install `lftp` and identify the path to the executable
with `whereis`. file. If you do not have `lftp` installed in your system's
`$PATH`, you need to provide the full path when using `{gwascatftp}`.

```bash
conda create -n lftp -c conda-forge lftp
conda activate lftp
whereis lftp
#> e.g. `~/miniconda3/envs/lftp/bin/lftp`
```

## Getting Started

This is a basic example which shows you how to solve a common problem:

``` r
library(gwascatftp)
```

