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

The user need to modify just:
- `uvm.f`
- `uvc.f`
- `verification/uvm/`
    - `env/*`
    - `tests/*`
    - `uvcs/*`

Touch only if you know what you are doing:
- `common.mk`


## Basic control variables

```plain
TEST              = top_test
VERBOSITY         = UVM_MEDIUM
CODE_COV_TYPES    = line+cond+fsm+branch+tgl+assert
ENABLE_CODE_COV   = true
ENABLE_SVA        = false
SEED_MODE         = fixed
SEED              = 5081996
VCS_DEFINES       = +define+GIT_DIR="/home/bermudez/Documents/uvmcollab/rtl-dev-template"
DUMP_MODE         = default
RUN_ARGS          = 
SIMV_NAME         = simv
JOB_NAME          = debug
```