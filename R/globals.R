
# make CRAN happy
utils::globalVariables(c("codebook","st","state","year","year","congress","state_icpsr"
                         ,".","state.abb","variable","pull","vars","congress_number"),
                       package = "congress",
                       add = F)
