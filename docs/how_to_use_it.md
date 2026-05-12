# How to use it?

1. Copy and paste in your `setup_synopsys_eda.sh` file:
   
```bash
cp $HOME/snps_scripts/setup_synopsys_eda.sh verification/common/setup
```

2. The first time from the root directory run:
```bash
source verification/uvm/scripts/setup/setup_uvc.sh
```

> Remember: this should be run JUST ONCE

The user needs to modify just:
- `tb.f`
- `uvc.f`
- `verification/uvm/`
    - `env/*`
    - `tests/*`
    - `uvcs/*`

Touch only if you know what you are doing:
- `common.mk`

## Control variables

```plain
TEST                 = top_test
VERBOSITY            = UVM_MEDIUM
TIMESCALE            = 1ps/100fs
ENABLE_DEBUG_DB      = false
ENABLE_UVM           = true
ENABLE_UVM_RECORDING = false
CODE_COV_TYPES       = line
ENABLE_CODE_COV      = false
ENABLE_SVA           = false
SEED_MODE            = fixed
SEED                 = 5081996
DUMP_MODE            = none
DEFINES              = 
COMPILE_ARGS         = 
RUN_ARGS             = 
SIMV_NAME            = simv
JOB_NAME             = debug
UVCS_FILELIST        = -F /home/bermudez/Documents/uvmcollab/rtl-dev-template/verification/uvm/uvcs.f
DPI_FILE             = 
```
