#' Get information regarding CongressData variables
#'
#' \code{get_var_info} retrieves information regarding variables in the CongressData dataset.
#' The information available includes: the years each variable is observed in the data;
#' a short and long description of each variable; and the source and citation/s for each
#' variable. Citations are available in both bibtex and plain text.
#'
#' Specifying no arguments returns all the information for all the variables
#' in the CongressData dataset.
#'
#' @name get_var_info
#'
#' @param var_names Default is NULL. Takes a character string. If left blank the
#'   function does not subset by variable name. Note that this searches variable names,
#'   it does not subset by the specific string you provide. So "over65" will return a
#'   variable called 'over65' along with another called 'percent_over65'.
#' @param related_to Default is NULL. Takes a character string. If the user supplies
#' a character string, the function searches the other relevant fields (variable name, short/long
#' description, and source) for string matches. Not case sensitive.
#'
#' @importFrom rlang .data
#' @importFrom stringr str_detect
#' @import dplyr
#'
#' @export
#'
#' @examples
#'
#' # returns all variable information
#' get_var_info()
#'
#' # match var names that contain "over65" - note this returns multiple variables
#' get_var_info(var_names = "over65")
#'
#' get_var_info(related_to = c("pop","femal"))
#'

get_var_info <- function(var_names = NULL, related_to = NULL){

  # get codebook
  cb_temp <- tempfile()
  cb_url  <- "https://ippsr.msu.edu/congresscodebook"
  curl::curl_download(cb_url, cb_temp, mode="wb")
  data <- fst::read_fst(cb_temp)
  
  if(!is.null(var_names) & !is.character(var_names)){
    stop("var_names must be a string or character vector.")
  }

  if(!is.null(related_to) & !is.character(related_to)){
    stop("related_to must be a string or character vector.")
  }
  
  if(length(var_names) > 0){
    vars <- paste0(var_names,  collapse = "|")
    data <- data %>%
      dplyr::filter(stringr::str_detect(.data$variable,
                                        vars)
                    )
  }

  if(length(related_to) > 0){
    rels <- paste0(related_to, collapse = "|")
    data <- data %>%
      dplyr::filter_at(.vars = vars(.data$variable,
                                    .data$short_desc,
                                    .data$long_desc,
                                    .data$sources),
                       .vars_predicate = dplyr::any_vars(stringr::str_detect(tolower(.),
                                                                             tolower(rels)
                                                                             )
                       )
      )
  }

  if(nrow(data) == 0){
    stop("Your request returned no results.")
  }

  return(data)
}

