
# prints when the package is attached using library()
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Please cite:\n")
  packageStartupMessage("Grossmann, M., Lucas, C., McCrain, J, & Ostrander, I. (2022). The Congress Data.")
  packageStartupMessage("East Lansing, MI: Institute for Public Policy and Social Research (IPPSR).")
  packageStartupMessage("\nYou are using the version of the Congress Data stored in your local copy of congressData. Running `congressData::get_congress_version()` will print your local version number.\n")
}

