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
ln -sf $TB_SCRIPTS/setup/setup_synopsys_eda.sh
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

# How to use DPI tool

This project includes a simple example of using **SystemVerilog DPI-C** to call C++ reference  model from testebench.

The provided DPI model (`dpi.cpp`) implements a basic numerical algorithm (Euler method) and is used only to validate DPI integration. This algorithm uses the **Forward Euler method**  to approximate the solution of ordinary differential equations.
Given a differential equation:

$$\frac {dy}{dt} = (t,y) $$


the Forward Euler method computes the next values as:
 $$y(n+1) = y(n) + h * f(t(n),y(n))$$

where `h` is the step size. This approach discretizes a continous-time equation and evaluates it step by step.



## Steps to use the DPI

- 1 : Create a DPI file in **dpi/**folder where you will have the model referece  (e.g. `dpi.cpp`).
- 2 : Create a new Systemverilog  test (`test_dpi.sv`) in **tests/**folder where you can write any test to probe your DPI file.
- 3 : Modify tb.sv file  to instance `test_dpi` with interface.
- 4 : Run the simulation using `make complie-dpi` and `make sim` to observe the reference model response.




