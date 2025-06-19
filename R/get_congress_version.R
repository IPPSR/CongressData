#' Get your local version of CongressData
#'
#' \code{get_congress_version} prints the current version of CongressData available through the package. It takes no arguments.
#'
#' @name get_congress_version
#' 
#' @importFrom utils read.csv
#' 
#' @return No return value, called for side effects.
#'
#' @export
#'

get_congress_version <- function() {
  vers <- tryCatch(
    suppressWarnings(read.csv(url("https://ippsr.msu.edu/congresshelper"))),
    error = function(e) NA
  )
  
  if (is.na(vers)) {
    message("CongressData version: not available")
  } else {
    message("You are using CongressData version: ", vers$version)
  }
}

