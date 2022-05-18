#' Load Congress Data into the R environment
#'
#' \code{get_congress_data} loads either a full or subsetted version of the full
#' Congress Data dataset into the R environment as a dataframe.
#'
#'@name get_congress_data
#'
#' @param states Default is NULL. If left blank, returns all states. Takes a
#'   string or vector of strings of state names.
#' @param related_to Default is "". Provide a string to search a variable's name,
#' short/long descriptions from the codebook, and its citation for non-exact matches o
#' f a search term. For example, searching 'tax' will return variables with words
#' like 'taxes' and 'taxable' in any of those columns.
#' @param years Default is NULL. If left blank, returns all years Input can be
#' a single year (e.g. 2001) or a two year that represent the first and last
#' that you want in the outputted dataframe (such as `c(1989, 20001)`).
#'
#' @importFrom dplyr "%>%" filter arrange bind_rows group_by
#'   if_else mutate distinct rename n
#' @importFrom tidyselect all_of any_of
#'
#' @export
#'


get_cong_data <- function(states = NULL,
                          related_to = "",
                          years = NULL){

  congress <- congressData::congress
  codebook <- congressData::codebook

  panel_vars <- c("state","st","firstname","lastname","bioguide","year","start","end",
                  "district_number","congress_number",
                  "bioguide","govtrack","wikipedia","wikidata",
                  "google_entity_id","house_history","icpsr"
  )

  #---- related ----#
  if(related_to != ""){
    rels <- paste0(related_to, collapse = "|")
    related <- codebook %>%
      dplyr::filter_at(.vars = vars(.data$variable, .data$short_desc, .data$long_desc,
                                    .data$category, .data$sources),
                       .vars_predicate = dplyr::any_vars(stringr::str_detect(., rels))) %>%
      pull(variable)
    congress <- congress[colnames(congress) %in% c(related, panel_vars)]
  }

  #---- states ----#
  if(!is.null(states)) {
    congress <- congress %>%
      dplyr::filter(state %in% states)
  }

  #---- years ----#
  if(!is.null(years)){
    if(length(years) == 2){
      congress <- congress %>%
        dplyr::filter(year >= years[1],
                      year <= years[2])
    }
    if(length(years) == 1){
      congress <- congress %>%
        dplyr::filter(year == years)
    }
  }

  return(congress)
}






