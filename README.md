
<!-- README.md is generated from README.Rmd. Please edit that file -->

# congress: A Tool for the Congress Data <img src="figures/congress.png" height="150" align="right"/>

**congress** is a package designed to allow a user with only basic
knowledge of R interact with *Congress Data*, a dataset that compiles
information about all US congressional districts across 1789-2021. Users
can find variables related to demographics, politics, and policy; subset
the data across multiple dimensions; and access citations in both plain
text and BibTeX for every variable. An associated web application is
available [here](https://congress.ippsr.msu.edu/congress/) and the
data-only package is [here](https://github.com/IPPSR/congressData).

## Installing this Package and the Data-only Companion Package

`congress` is a functional package that interacts with `Congress Data`.
We maintain the dataset in another package called `congressData`. You
can use the data-only package if you simply want to access the data.

We do not plan on moving these packages to CRAN in the immediate future,
so install them from GitHub like so:

``` r
# use the devtools library to download the package from GitHub
library(devtools)

# this should download congressData as well
devtools::install_github("ippsr/congress")

# if there are issue or you only want to download congressData
devtools::install_github("ippsr/congressData")
```

## Finding Variables

Use `get_var_info` to retrieve information regarding variables in
`Congress Data` and identify variables of interest. The function allows
you to search to codebook to find the years each variable is observed in
the data; a short and long description of each variable; and the source
and citation/s for each variable. Citations are available in both bibtex
and plain text. Use the function to search for broad terms like ‘tax’
with the `related_to` argument and/or partial-match variable names with
`var_names`.

## Accessing Data

Use `get_congress_data` to access all or part of `Congress Data`. Subset
by state names with `state` and years with `years` (either a single year
or a two-year vector that represents the min/max of what you want). You
can also use the `related_to` argument to search across variable names,
short/long descriptions from the codebook, and citations for non-exact
matches of a supplied term. For example, searching ‘tax’ will return
variables with words like ‘taxes’ and ‘taxable’ in any of those columns.

### Pulling Citations

Each variable in `Congress Data` was collected from external sources.
We’ve made it easy to cite the source of each variable you use with the
`get_var_info` function described above. Supply a vector of variable
names to the function with the `var_names` function and collect the
citations provided in the plain text or BibTeX columns.

In addition to citing each variable’s source, we ask that you cite
`Congress Data` if use it or this package. A recommended citation is
below.

# Citation

> Grossmann, M., Lucas, C., McCrain, J, & Ostrander, I. (2022). The
> Congress Data. East Lansing, MI: Institute for Public Policy and
> Social Research (IPPSR)
