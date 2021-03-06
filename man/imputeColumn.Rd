% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/common-impute.R
\name{imputeColumn}
\alias{imputeColumn}
\title{Perform imputation on a vector}
\usage{
imputeColumn(v)
}
\arguments{
\item{v}{A vector, or column of values with NAs.}
}
\value{
A vector, or column of values now with no NAs
}
\description{
This class performs imputation on a vector. For numeric vectors
the vector-mean is used; for factor columns, the most frequent value is used.
}
\examples{
# For a numeric vector
vResult <- imputeColumn(c(1,2,3,NA))

# For a factor vector
vResult <- imputeColumn(c('Y','N','Y',NA))

# To use this function on an entire data frame:
df <- data.frame(a=c(1,2,3,NA),
                b=c('Y','N','Y',NA))
df[] <- lapply(df, imputeColumn)
head(df)
}
\references{
\url{http://healthcare.ai}
}
\seealso{
\code{\link{healthcareai}}
}
