% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{tbenefits}
\alias{tbenefits}
\title{tbenefits dataset}
\format{A data frame with 62,775 rows and 6 variables:
\describe{
  \item{code}{This is the "spp_value_assignment" and acts as a key linking trees to their appropriate benefit values.}
  \item{region}{The region code representing a specific region.}
  \item{benefit}{The type of benefit.}
  \item{unit}{The unit of measurement for a benefit type.}
  \item{dbh}{DBH Measured in centimeters.}
  \item{value}{The value associated with the benefit.}
  ...
}}
\source{
\url{https://www.itreetools.org}
}
\usage{
tbenefits
}
\description{
A dataset containing benefits, dbh ranges, and other attributes for specific
species using the "spp_value_assignment", i-Tree's way of linking species to
their appropriate benefit values.
}
\keyword{datasets}
