# RTL Development Template

## Setup

From the root directory run the following:

### For `bash`

```bash
export GIT_ROOT="$(git rev-parse --show-toplevel)"
export TB_WORK="$GIT_ROOT/work/tb"
export TB_SCRIPTS="$GIT_ROOT/verification/directed/scripts"
mkdir -p "$TB_WORK" && cd "$TB_WORK"
ln -sf $TB_SCRIPTS/makefiles/Makefile.vcs Makefile
ln -sf $TB_SCRIPTS/setup/setup_synopsys_eda.tcsh
make
```

### For `tcsh`

```bash
setenv GIT_ROOT `git rev-parse --show-toplevel`
setenv TB_WORK $GIT_ROOT/work/tb
setenv TB_SCRIPTS $GIT_ROOT/verification/directed/scripts
mkdir -p $TB_WORK && cd $TB_WORK
ln -sf $TB_SCRIPTS/makefiles/Makefile.vcs Makefile
ln -sf $TB_SCRIPTS/setup/setup_synopsys_eda.sh
source setup_synopsys_eda.sh
make
```
