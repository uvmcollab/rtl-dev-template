## [Filename]       dump.tcl
## [Project]        -
## [Author]         Ciro Bermudez - cirofabian.bermudezmarquez@ba.infn.it
## [Language]       Tcl (Tool Command Language)
## [Created]        2025/04/02
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
##=============================================================================

proc dump_signals {} {
    # Dump signals to FSDB (RECOMMENDED)
    puts "\[TCL-CUSTOM\]: Dumping signals to novas.fsdb"
    dump -file novas.fsdb -type FSDB
    dump -add tb.dut -depth 0 -fid FSDB0
    run
    quit
}


proc dump_all {} {
    # Dumps everything to FSDB from root including complex data type
    puts "\[TCL-CUSTOM\]: Dumping all signals to novas.fsdb"
    dump -file novas.fsdb -type FSDB
    dump -add / -aggregates -fid FSDB0
    run
    quit
}


proc dump_top {} {
    # Dump signals to FSDB from dut just ports
    puts "\[TCL-CUSTOM\]: Dumping port signals to novas.fsdb"
    dump -file novas.fsdb -type FSDB
    dump -add tb.dut -depth 1 -ports -fid FSDB0
    run
    quit
}


proc dump_custom {} {
    # Dump signals to FSDB specific signals
    puts "\[TCL-CUSTOM\]: Dumping specific signals to novas.fsdb"
    dump -file novas.fsdb -type FSDB
    dump -add tb.dut.clk_i -fid FSDB0
    dump -add tb.dut.db_level_o -fid FSDB0
    dump -add tb.dut.db_tick_o -fid FSDB0
    run
    quit
}

#==============================================================================
#========================== RUN FUNCTIONS HERE ================================
#==============================================================================

dump_signals
