# DEBOUNCER_UVC

This is a UVC designed to ...

## Integration guide

### Add the UVC in Your project

Clone the repository into your `uvcs/` directory.

```plain
git clone https://github.com/uvmcollab/debouncer_uvc.git
```

Alternatively, you can add the UVC as a submodule by running the
`git submodule add` command from the root directory of your main Git repository:

```plain
git submodule add git@github.com:uvmcollab/debouncer_uvc.git verification/uvm/uvcs/debouncer_uvc
```

A `.gitmodules` file will be created. Now commit the changes:

```plain
git add .gitmodules verification/uvm/uvcs/debouncer_uvc
git commit -m "feat: add debouncer_uvc as a submodule"
```

### Directory Structure Convention

The following directory structure is required to integrate the UVC:

```plain
```

### Step-by-Step

### Example sequences

## Testing

## Setup

> **Note:** The `Makefile` expects a git project to setup the environment variables

> **Note:** Before running the setup, make sure to place your own `setup_synopsys_eda.sh` file in the `scripts/setup/` directory.

> **Note:** This setup only needs to be executed once. Afterward, simply navigate to `work/uvm` and source your setup file.

From the root directory run the following:

### For bash

```bash
export GIT_ROOT="$(git rev-parse --show-toplevel)"
export UVM_WORK="$GIT_ROOT/work/uvm"
mkdir -p "$UVM_WORK" && cd "$UVM_WORK"
ln -sf $GIT_ROOT/scripts/makefiles/Makefile.vcs Makefile
ln -sf $GIT_ROOT/scripts/setup/setup_synopsys_eda.sh
source setup_synopsys_eda.sh
make
```

### For tcsh

```bash
setenv GIT_ROOT `git rev-parse --show-toplevel`
setenv UVM_WORK $GIT_ROOT/work/uvm
mkdir -p $UVM_WORK && cd $UVM_WORK
ln -sf $GIT_ROOT/scripts/makefiles/Makefile.vcs Makefile
ln -sf $GIT_ROOT/scripts/setup/setup_synopsys_eda.tcsh
source setup_synopsys_eda.tcsh
make
```


> NOTE: This UVM verification framework was generated using the [pyuvcgen](https://github.com/uvmcollab/pyuvcgen) tool to gene
