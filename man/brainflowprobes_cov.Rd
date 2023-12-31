% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/brainflowprobes_cov.R
\name{brainflowprobes_cov}
\alias{brainflowprobes_cov}
\title{Extract coverage data for a set of regions}
\usage{
brainflowprobes_cov(REGION, PD = brainflowprobes::pd, VERBOSE = TRUE)
}
\arguments{
\item{REGION}{Either a single hg19 genomic sequence including the chromosome,
start, end, and optionally strand separated by colons (e.g.,
'chr20:10199446-10288068:+'), or a string of sequences. Must be character.
Chromosome must be proceeded by 'chr'.}

\item{PD}{A list of data.frames with the \code{sumMapped} and \code{files}
columns. Defaults to the data included in this package.}

\item{VERBOSE}{A logical value indicating whether to print updates from the
process of loading the data from the BigWig files.}
}
\value{
A list of region coverage coverage data.frame lists used by
\link{four_panels} and \link{plot_coverage}. That is, a list with one
element per dataset in \link{pd} (so four: \code{Sep}, \code{Deg}, \code{Cell}, \code{Sort}).
Each element of the output list is a list with one data.frame per input
region. In the case of \code{four_panels_example_cov} there was only one input
region hence each region coverage data.frame list has one element. A region
coverage data.frame has one column per sample and one row per genome
base-pair for the given region and dataset.
}
\description{
This function extracts the data from the BigWig coverage files that is then
used by \link{four_panels}. This function can take a while to run depending
on your internet connection. Furthermore, this function relies on
functionality in the rtracklayer package for reading BigWig files which
does not work in Windows machines. The data extracted by this function is
also used by \link{plot_coverage}.
}
\examples{

## This function loads data from BigWig files using the rtracklayer package.
## This functionality is not supported on Windows OS machines!
if (.Platform$OS.type != "windows") {
    ## How long this takes to run will depend on your internet connection.
    example_cov <- brainflowprobes_cov("chr20:10286777-10288069:+",
        PD = lapply(brainflowprobes::pd, head, n = 2)
    )

    ## Output examination:
    # A list with one element per element in brainflowprobes::pd
    stopifnot(is.list(example_cov))
    stopifnot(identical(
        names(example_cov),
        names(brainflowprobes::pd)
    ))

    # For each dataset, brainflowprobes_cov() returns a list of region
    # coverage data.frames. In this example, there was a single input region.
    stopifnot(all(
        sapply(example_cov, length) ==
            length(
                GenomicRanges::GRanges("chr20:10286777-10288069:+")
            )
    ))

    # Then each data.frame itself has 1 row per genome base-pair in the region
    stopifnot(
        all(
            sapply(example_cov, function(x) {
                nrow(x[[1]])
            }) ==
                GenomicRanges::width(
                    GenomicRanges::GRanges("chr20:10286777-10288069:+")
                )
        )
    )

    # and one column per sample in the dataset unless you subsetted the data
    # like we did earlier when creating "example_cov".
    stopifnot(identical(
        sapply(four_panels_example_cov, function(x) {
            ncol(x[[1]])
        }),
        sapply(pd, nrow)
    ))
}

## This is how the example data included in the package was made:
\dontrun{
## This can take about 10 minutes to run!
four_panels_example_cov <- brainflowprobes_cov("chr20:10286777-10288069:+")
}


## If you are interested, you could download all the BigWig files
## in the \code{brainflowprobes::pd} list of data.frames from the
## \code{files} column to your disk. Doing so will greatly increase the
## speed for \code{brainflowprobes_cov} and the functions that depend on
## this data. Then edit \code{brainflowprobes::pd} \code{files} to point to
## your local files.

## Web location of BigWig files
lapply(brainflowprobes::pd, function(x) head(x$files))
}
\author{
Leonardo Collado-Torres
}
