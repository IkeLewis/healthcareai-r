#' @title
#' Last observation carried forward
#'
#' @description
#' Carries the last observed value forward for all columns in a data.table
#' grouped by an id.
#'
#' @param df data frame sorted by an ID column and a time or sequence number
#' column.
#' @param id A column name (in ticks) in df to group rows by.
#' @return A data frame where the last non-NA values are carried forward
#' (overwriting NAs) until the group ID changes.
#'
#' @import data.table
#' @export
#' @references \url{http://healthcare.ai}
#' @seealso \code{\link{healthcareai}}
#' @examples
#' df <- data.frame(personID=c(1,1,2,2,3,3,3),
#'                 wt=c(.5,NA,NA,NA,.3,.7,NA),
#'                 ht=c(NA,1,3,NA,4,NA,NA),
#'                 date=c('01/01/2015','01/15/2015','01/01/2015','01/15/2015',
#'                        '01/01/2015','01/15/2015','01/30/2015'))
#'
#' head(df,n=7)
#'
#' dfResult <- groupedLOCF(df, 'personID')
#'
#' head(dfResult, n = 7)
groupedLOCF <- function(df, id) {
  # Note that the object that results acts as both a data frame and datatable
  df <- data.table::setDT(df)
  
  # Create a vector of booleans where each element is mapped to a row in the
  # data.table.  Each value is FALSE unless the corresponding row is the first row
  # of a person.  In other words, each TRUE represents a change of PersonID in the
  # data.table.
  changeFlags <- c(TRUE, get(id, df)[-1] != get(id, df)[-nrow(df)])
  
  # A helper that finds the last non-NA value for a given column x in df.
  locf <- function(x) x[cummax(((!is.na(x)) | changeFlags) * seq_len(nrow(df)))]
  
  # By avoiding using the 'by' operator of data.table, we're reducing the number of
  # calls from (N rows / P people) * C columns to just C columns; this is just once
  # for each column in the data.table.
  dfResult <- df[, lapply(.SD, locf)]
  dfResult
}

#' @title
#' Perform imputation on a vector
#'
#' @description This class performs imputation on a vector. For numeric vectors
#' the vector-mean is used; for factor columns, the most frequent value is used.
#' @param v A vector, or column of values with NAs.
#' @return A vector, or column of values now with no NAs
#'
#' @export
#' @references \url{http://healthcare.ai}
#' @seealso \code{\link{healthcareai}}
#' @examples
#' # For a numeric vector
#' vResult <- imputeColumn(c(1,2,3,NA))
#'
#' # For a factor vector
#' vResult <- imputeColumn(c('Y','N','Y',NA))
#'
#' # To use this function on an entire data frame:
#' df <- data.frame(a=c(1,2,3,NA),
#'                 b=c('Y','N','Y',NA))
#' df[] <- lapply(df, imputeColumn)
#' head(df)
imputeColumn <- function(v) {
  if (is.numeric(v)) {
    v[is.na(v)] <- mean(v, na.rm = TRUE)
  } else {
    v[is.na(v)] <- names(which.max(table(v)))
  }
  v
}