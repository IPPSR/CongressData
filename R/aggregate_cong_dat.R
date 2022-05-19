#' Load Congress Data into the R environment
#'
#' \code{aggregate_cong_dat} loads either a full or subsetted version of the full
#' Congress Data dataset into the R environment as a dataframe.
#'
#' @name aggregate_cong_dat
#'
#' @param states Default is NULL. If left blank, returns all states. Takes a
#'   string or vector of strings of state names.
#' @param related_to Default is "". Provide a string to search a variable's name,
#' short/long descriptions from the codebook, and its citation for non-exact matches o
#' f a search term. For example, searching 'tax' will return variables with words
#' like 'taxes' and 'taxable' in any of those columns.
#' @param sessions Default is NULL. If left blank, returns all sessions. Input can be
#' a single session (e.g. 50) or a two sessions that represent the first and last
#' that you want in the outputted dataframe (such as `c(1, 20)`).
#' @param census_nonperc_vars Default is 'Mean'. Method to aggregate from member-years to member-sessions.
#' One of "Mean", "Sum", or "First". Requires a string.
#' @param census_perc_vars Default is 'Mean'. Method to aggregate from member-years to member-sessions.
#' One of "Mean", "Sum", or "First". Requires a string.
#' @param bill_vars Default is 'Mean'. Method to aggregate from member-years to member-sessions.
#' One of "Mean", "Sum", or "First". Requires a string.
#' @param com_vars Default is 'Mean'. Method to aggregate from member-years to member-sessions.
#' One of "Mean", "Sum", or "First". Requires a string.
#' @param else_vars Default is 'Mean'. Method to aggregate from member-years to member-sessions.
#' One of "Mean", "Sum", or "First". Requires a string.
#'
#' @importFrom dplyr "%>%" filter arrange left_join bind_rows group_by
#'   if_else mutate distinct rename n
#' @importFrom tidyselect all_of any_of
#'
#' @export
#'


aggregate_cong_dat <- function(states     = NULL,
                               related_to = NULL,
                               sessions   = NULL,
                               census_nonperc_vars = "Mean",
                               census_perc_vars = "Mean",
                               bill_vars = "Mean",
                               com_vars = "Mean",
                               else_vars = "Mean"){

  check_agg_input <- function(vec){
    if(!vec %in% c("Mean","Sum","First")){
      stop("Please choose 'Mean' or 'Sum' or 'First' for the variable aggregations")
    }
  }

  lapply(c(census_nonperc_vars,
           census_perc_vars,
           bill_vars,
           com_vars,
           else_vars),
         check_agg_input)

  codebook <- congressData::codebook

  panel_vars <- c("state","st","firstname","lastname","bioguide","year","start","end",
                  "district_number","congress_number",
                  "bioguide","govtrack","wikipedia","wikidata",
                  "google_entity_id","house_history","icpsr"
  )

  #---- census p --------#
  if(census_nonperc_vars == "Mean"){
    cenes_np_dat <- congressData::mean_census_np
  }
  if(census_nonperc_vars == "Sum"){
    cenes_np_dat <- congressData::sum_census_np
  }
  if(census_nonperc_vars == "First"){
    cenes_np_dat <- congressData::first_census_np
  }

  #---- census np --------#
  if(census_perc_vars == "Mean"){
    cenes_p_dat <- congressData::mean_census_p
  }
  if(census_perc_vars == "Sum"){
    cenes_p_dat <- congressData::sum_census_p
  }
  if(census_perc_vars == "First"){
    cenes_p_dat <- congressData::first_census_p
  }

  #---- bills --------#
  if(bill_vars == "Mean"){
    bills_dat <- congressData::mean_bills
  }
  if(bill_vars == "Sum"){
    bills_dat <- congressData::sum_bills
  }
  if(bill_vars == "First"){
    bills_dat <- congressData::first_bills
  }

  #---- coms --------#
  if(com_vars == "Mean"){
    com_dat <- congressData::mean_com
  }
  if(com_vars == "Sum"){
    com_dat <- congressData::sum_com
  }
  if(com_vars == "First"){
    com_dat <- congressData::first_com
  }

  #---- else --------#
  if(else_vars == "Mean"){
    else_dat <- congressData::mean_else
  }
  if(else_vars == "Sum"){
    else_dat <- congressData::sum_else
  }
  if(else_vars == "First"){
    else_dat <- congressData::first_else
  }

  #---- MERGE THE CUSTOM DAT --------#
  data <- suppressMessages(left_join(com_dat, cenes_p_dat) %>%
    left_join(., cenes_np_dat) %>%
    left_join(., bills_dat) %>%
    left_join(., else_dat))

  #---- related -------#
  if(!is.null(related_to)){
    rels <- paste0(related_to, collapse = "|")
    related <- codebook %>%
      dplyr::filter_at(.vars = vars(.data$variable, .data$short_desc, .data$long_desc,
                                    .data$category, .data$sources),
                       .vars_predicate = dplyr::any_vars(stringr::str_detect(., rels))) %>%
      pull(variable)
    dropper <- function(x){
      x <- gsub("_sum$","",x)
      x <- gsub("_first$","",x)
      x <- gsub("_mean$","",x)
    }
    data <- data[dropper(colnames(data)) %in% c(related,panel_vars)]
  }

  #---- states --------#
  if(!is.null(states)) {
    data <- data %>%
      dplyr::filter(state %in% states)
  }

  #---- congresses ----#
  if(!is.null(sessions)){
    if(length(sessions) == 2){
      data <- data %>%
        dplyr::filter(congress_number >= sessions[1],
                      congress_number <= sessions[2])
    }
    if(length(sessions) == 1){
      data <- data %>%
        dplyr::filter(congress_number == sessions)
    }
  }

  return(data)
}








