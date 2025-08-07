
# prints when the package is attached using library()
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Please cite:\n")
  packageStartupMessage('Grossmann, Matt, Caleb Lucas, and Benjamin Yoel. "Introducing CongressData and Correlates of State Policy." Scientific Data 12, no. 1 (2025): 1185.')
  packageStartupMessage("\nRun `CongressData::get_congress_version()` to print the version of CongressData the package is using.\n")
}