##==============================================================================
## [Filename]       all.tcl
## [Project]        -
## [Author]         Ciro Bermudez - cirofabian.bermudezmarquez@ba.infn.it
## [Language]       Tcl (Tool Command Language)
## [Created]        -
## [Modified]       -
## [Description]    Tcl file to run and dump signals to FSDB
## [Notes]          This file is passed to the ./simv command
##                  using the -ucli -do dump.tcl flag
##
##                  For more information refer to:
##                    Unified Command Line Interface (UCLI) User Guide W-2024.09
##                    dump - pag. 106
## [Status]         stable
## [Revisions]      -
##==============================================================================

# Configure directories
set tcl_dir [file dirname [info script]]

# Source dependencies
source [file join $tcl_dir dump_lib.tcl]

# Call function
dump_all
