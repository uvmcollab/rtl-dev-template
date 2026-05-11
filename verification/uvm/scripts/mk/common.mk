##==============================================================================
## [Filename]       common.vcs
## [Project]        -
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       GNU Makefile
## [Created]        -
## [Modified]       -
## [Description]    -
## [Notes]          -
## [Status]         stable
## [Revisions]      -
##==============================================================================

# ================================= VARIABLES ==================================
# Miscellaneous variables

CUR_DATE := $(shell date +%Y-%m-%d_%H-%M-%S)

# ------------------------------ TERMINAL COLORS -------------------------------
C_RED := \033[31m
C_GRN := \033[32m
C_BLU := \033[34m
C_YEL := \033[33m
C_CYN := \033[36m
C_RST := \033[0m

# ------------------------------ MESSAGE HELPERS -------------------------------
MSG_INFO  = @printf "$(C_BLU)[INFO]$(C_RST) %s\n"
MSG_OK    = @printf "$(C_GRN)[ OK ]$(C_RST) %s\n"
MSG_WARN  = @printf "$(C_YEL)[WARN]$(C_RST) %s\n"
MSG_ERROR = @printf "$(C_RED)[FAIL]$(C_RST) %s\n"

define print_vars
	@printf "$(C_CYN)%s$(C_RST)\n" "$(1)"
	@$(foreach var,$(2),printf "%-17s = %s\n" "$(var)" "$($(var))";)
	@printf "\n"
endef

define print_var
	@printf "$(C_CYN)%s$(C_RST)\n" "$(1)"
	@printf "%s\n" "$(strip $($(1)))";
	@printf "\n"
endef

# ================================ DIRECTORIES =================================
# Project paths and directory hierarchy

# ---------------------------------- GENERAL -----------------------------------
GIT_DIR          := $(shell git rev-parse --show-toplevel)
RTL_DIR          := $(GIT_DIR)/rtl
VRF_DIR          := $(GIT_DIR)/verification
COMMON_DIR       := $(VRF_DIR)/common
TB_DIR           := $(VRF_DIR)/uvm
GENERAL_DIR_VARS := GIT_DIR RTL_DIR VRF_DIR COMMON_DIR TB_DIR

# ------------------------------------ WORK ------------------------------------
ROOT_DIR      := $(CURDIR)
BUILD_DIR     := $(ROOT_DIR)/build
RUN_DIR       := $(ROOT_DIR)/sim
LOGS_DIR      := $(ROOT_DIR)/logs
VERDI_DIR     := $(ROOT_DIR)/verdi
COV_DIR       := $(ROOT_DIR)/cov
WORK_DIR_VARS := ROOT_DIR BUILD_DIR RUN_DIR LOGS_DIR VERDI_DIR COV_DIR

# ---------------------------------- SCRIPTS -----------------------------------
SCRIPTS_DIR      := $(TB_DIR)/scripts
MK_DIR           := $(SCRIPTS_DIR)/mk
TCL_DIR          := $(SCRIPTS_DIR)/tcl
DUMP_DIR         := $(TCL_DIR)/dump
WAVES_DIR        := $(SCRIPTS_DIR)/waves
SCRIPTS_DIR_VARS := SCRIPTS_DIR MK_DIR TCL_DIR DUMP_DIR WAVES_DIR  

# ---------------------------------- COVERAGE ----------------------------------
COV_REPORT_DIR := $(COV_DIR)/report
COV_MERGE_DIR  := $(COV_DIR)/merge
COV_DIR_VARS   := COV_DIR COV_REPORT_DIR COV_MERGE_DIR 

# ------------------------------------ UVCS ------------------------------------
UVCS_DIR := $(TB_DIR)/uvcs

# ------------------------------------ DPI -------------------------------------
DPI_DIR := $(COMMON_DIR)/dpi

# -------------------------------- REGRESSIONS ---------------------------------
REGR_DIR       := $(ROOT_DIR)/regression

EXTRA_DIR_VARS := UVCS_DIR DPI_DIR REGR_DIR

# =============================== CONFIGURATION ================================
# User-editable knobs and defaults

# ---------------------------------- TEST RUN ----------------------------------
# Test selection and basic UVM runtime options

TEST      ?= top_test
VERBOSITY ?= UVM_MEDIUM

# Options: [auto, fixed]
SEED_MODE  ?= fixed
SEED       ?= 5081996
SEED_FLAGS ?=

# Timescale
TIMESCALE ?= 1ps/100fs

# Workspace
SIMV_NAME ?= simv
JOB_NAME  ?= debug
SIMV_DIR  = $(BUILD_DIR)/$(SIMV_NAME)
JOB_DIR   = $(RUN_DIR)/$(JOB_NAME)

WORKSPACE_DIR_VARS := SIMV_DIR JOB_DIR
WORKSPACE_VARS := SIMV_NAME JOB_NAME $(WORKSPACE_DIR_VARS) 

# UCLI
# Options: [default, all, none]
DUMP_MODE    ?= default
DUMP_LIB_TCL := $(DUMP_DIR)/dump_lib.tcl
UCLI_FLAGS   ?= -ucli -do $(DUMP_DIR)/$(DUMP_MODE).tcl

export DUMP_LIB_TCL

UCLI_VARS := DUMP_MODE DUMP_LIB_TCL UCLI_FLAGS
SEED_VARS := SEED SEED_MODE SEED_FLAGS

TEST_RUN_VARS := TEST VERBOSITY TIMESCALE \
				$(SEED_VARS) \
				$(WORKSPACE_VARS) \
				$(UCLI_VARS)

# Compile extra arguments
VCS_DEFINES ?= +define+GIT_DIR=\"$(GIT_DIR)\"

# Runtime extra arguments
RUN_ARGS ?=

USER_ARG_VARS := VCS_DEFINES RUN_ARGS

# ---------------------------------- GUI MODE ----------------------------------
# Options: [true, false]
ENABLE_GUI ?= false

# Run Tcl by default
GUI_FLAGS  ?= 

GUI_VARS   := ENABLE_GUI GUI_FLAGS

# ------------------------------------ UVM -------------------------------------
# Options: [true, false]
ENABLE_UVM  ?= true
UVM_VERSION ?= 1.2

UVM_FLAGS_VCS  ?= 
UVM_FLAGS_SIMV ?= 

UVM_VARS = ENABLE_UVM UVM_VERSION UVM_FLAGS_SIMV UVM_FLAGS_VCS

# ------------------------------- CODE COVERAGE --------------------------------
# Options: [true, false]
ENABLE_CODE_COV  ?= true
CODE_COV_TYPES   ?= line+cond+fsm+branch+tgl+assert
COV_NAME         ?= $(SIMV_NAME)_cov
COV_FLAGS_COMMON ?= -cm $(CODE_COV_TYPES)

# Compile always supports coverage
COV_FLAGS_VCS ?= $(COV_FLAGS_COMMON) -cm_dir $(SIMV_DIR)/$(COV_NAME)

# Runtime collection is optional
COV_FLAGS_SIMV   ?=

CODE_COV_VARS := \
	ENABLE_CODE_COV CODE_COV_TYPES COV_NAME \
	COV_FLAGS_COMMON COV_FLAGS_VCS COV_FLAGS_SIMV

# ------------------------------------ SVA -------------------------------------
# Options: [true, false]
ENABLE_SVA     ?= false
SVA_FLAGS_VCS  ?=
SVA_FLAGS_SIMV ?=

SVA_VARS := ENABLE_SVA SVA_FLAGS_VCS SVA_FLAGS_SIMV

# ================================== CONTROL ===================================
# Derived flags / logic

# ---------------------------------- GUI MODE ----------------------------------
# Options: [true, false]
ifeq ($(ENABLE_GUI),true)
	GUI_FLAGS = -gui=verdi
endif

# ------------------------------------ UVM -------------------------------------
# Options: [true, false]
ifeq ($(ENABLE_UVM),true)
	UVM_FLAGS_VCS  = -ntb_opts uvm-$(UVM_VERSION)
	UVM_FLAGS_SIMV = +UVM_VERDI_TRACE=UVM_AWARE+RAL+HIER+TLM \
					+UVM_TR_RECORD +UVM_LOG_RECORD \
					+UVM_NO_RELNOTES
endif

# --------------------------------- SEED MODE ----------------------------------
# Options: [auto, fixed]
ifeq ($(SEED_MODE),auto)
  SEED_FLAGS = +ntb_random_seed_automatic
else
  SEED_FLAGS = +ntb_random_seed=$(SEED)
endif

# ------------------------------- CODE COVERAGE --------------------------------
# Options: [true, false]
ifeq ($(ENABLE_CODE_COV),true)
	COV_FLAGS_SIMV += $(COV_FLAGS_COMMON)
endif

# ------------------------------------ SVA -------------------------------------
# Options: [true, false]
ifeq ($(ENABLE_SVA),true)
	SVA_FLAGS_VCS  += -assert enable_diag+enable_hier
	SVA_FLAGS_SIMV += -assert summary+quiet1 \
					-assert report=$(LOGS_DIR)/$(CUR_DATE)_sva.log
endif

# ================================ TOOLS SETUP =================================

# --------------------------------- FILE LISTS ---------------------------------
RTL_FILELIST  = -F $(RTL_DIR)/rtl.f
TB_FILELIST   = -F $(TB_DIR)/uvm.f
UVCS_FILELIST = -F $(TB_DIR)/uvcs.f
FILES         = $(UVCS_FILELIST) $(RTL_FILELIST) $(TB_FILELIST)

# ------------------------------------ DPI -------------------------------------
DPI_FILE ?=

# ------------------------------------ VCS -------------------------------------
VCS_FLAGS = -full64 -sverilog \
			$(UVM_FLAGS_VCS) \
			-lca -debug_access+all -kdb \
			-timescale=$(TIMESCALE) \
			$(FILES) \
			-l $(SIMV_DIR)/$(CUR_DATE)_compile.log \
			-top tb \
			-j8 \
			-o $(SIMV_NAME) \
			$(VCS_DEFINES) \
			$(COV_FLAGS_VCS) \
			$(SVA_FLAGS_VCS) \
			$(DPI_FILE)

# ------------------------------------ SIMV ------------------------------------
SIMV_FLAGS = +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VERBOSITY) \
			$(UVM_FLAGS_SIMV) \
			-no_save \
			$(SEED_FLAGS) \
			$(COV_FLAGS_SIMV) \
			$(SVA_FLAGS_SIMV) \
			$(UCLI_FLAGS) \
			$(RUN_ARGS)

# Add a new target and flags for the gui mode $(GUI_FLAGS)
# ------------------------------------ URG -------------------------------------
URG_FLAGS = -full64 -dir $(SIMV_DIR)/$(COV_NAME).vdb -format both \
			-log $(LOGS_DIR)/$(CUR_DATE)_cov.log \
			-report $(COV_REPORT_DIR) -dbname $(COV_MERGE_DIR)/merged.vdb -show tests

# ----------------------------------- VERDI ------------------------------------
VERDI_FLAGS     = -nologo -q -ssf $(JOB_DIR)/novas.fsdb 
VERDI_COV_FLAGS = -nologo -q -cov -covdir $(COV_MERGE_DIR)/merged.vdb
VERDI_PLAY      = -play $(VERDI_FILE)
# VERDI_FLAGS    = -ssf $(RUN_DIR)/$(JOB_NAME)/novas.fsdb -dbdir simv.daidir -nologo -q

TOOLS_FLAGS_VARS = VCS_FLAGS SIMV_FLAGS URG_FLAGS VERDI_FLAGS VERDI_COV_FLAGS

# ============================== VARIABLE GROUPS ===============================

DIR_VARS := \
	$(GENERAL_DIR_VARS) \
	$(WORK_DIR_VARS) \
	$(SCRIPTS_DIR_VARS) \
	$(COV_DIR_VARS) \
	$(EXTRA_DIR_VARS) \
	$(WORKSPACE_DIR_VARS)

CONTROL_VARS := \
	TEST \
	VERBOSITY \
	TIMESCALE \
	ENABLE_UVM \
	CODE_COV_TYPES \
	ENABLE_CODE_COV \
	ENABLE_SVA \
	SEED_MODE \
	SEED \
	DUMP_MODE \
	VCS_DEFINES \
	RUN_ARGS \
	SIMV_NAME \
	JOB_NAME

SYNOPSYS_TOOLS = vcs urg verdi wv

# =================================== MACROS ===================================

# -------------------------------- COMPILATION ---------------------------------
define run_compile
	@printf "$(C_CYN)%s$(C_RST)\n" "Compiling project"
	@mkdir -p $(SIMV_DIR) $(LOGS_DIR)
	cd $(SIMV_DIR) && vcs $(VCS_FLAGS)
endef

# --------------------------------- SIMULATION ---------------------------------
define run_sim
	@printf "$(C_CYN)%s$(C_RST)\n" \
		"Running simulation SEED=$(SEED_MODE) SEED=$(SEED)"
	@mkdir -p $(JOB_DIR) $(LOGS_DIR)
	@TEST_ID="$(CUR_DATE)_$(TEST)_$$$$"; \
	LOG_FILE="-l $(JOB_DIR)/$${TEST_ID}_run.log"; \
	COV_TEST_FLAGS="-cm_test $(TEST) -cm_name $${TEST_ID}"; \
	cd $(JOB_DIR) && \
	$(SIMV_DIR)/$(SIMV_NAME) $(SIMV_FLAGS) \
		$${COV_TEST_FLAGS} $${LOG_FILE}
endef

# ================================  TARGETS  ==================================
.DEFAULT_GOAL := all
SHELL         := bash

.PHONY: all
all: help
#_______________________________________________________________________________

.PHONY: check-tools
check-tools: ## UVM: Check required Synopsys tools
	@printf "$(C_CYN)%s$(C_RST)\n" "Checking Synopsys tools..."
	@for tool in $(SYNOPSYS_TOOLS); do \
		if ! command -v $$tool >/dev/null 2>&1; then \
			printf "$(C_RED)%-7s is MISSING$(C_RST)\n" "$$tool"; \
			printf "Please source synopsys_eda_setup.[tc]sh before running Make targets\n"; \
			exit 1; \
		else \
			printf "$(C_GRN)%-7s FOUND$(C_RST)\n" "$$tool"; \
		fi; \
	done
	@printf "$(C_GRN)%s$(C_RST)\n" "All Synopsys tools are available"
#_______________________________________________________________________________

.PHONY: print-vars
print-vars: ## UVM: Print Makefile variables
	$(call print_vars,Directory variables,$(DIR_VARS))
	$(call print_vars,Workspace variables,$(WORKSPACE_VARS))
	$(call print_vars,Test variables,$(TEST_RUN_VARS))
	$(call print_vars,UVM variables,$(UVM_VARS))
	$(call print_vars,Seed variables,$(SEED_VARS))
	$(call print_vars,UCLI variables,$(UCLI_VARS))
	$(call print_vars,Coverage variables,$(CODE_COV_VARS))
	$(call print_vars,SVA variables,$(SVA_VARS))
	$(call print_vars,Control variables,$(CONTROL_VARS))
	$(call print_var,VCS_FLAGS)
	$(call print_var,SIMV_FLAGS)
	$(call print_var,URG_FLAGS)
	$(call print_var,VERDI_FLAGS)
	$(call print_var,VERDI_COV_FLAGS)
#_______________________________________________________________________________

.PHONY: compile
compile: ## UVM: Runs VCS compilation
	$(run_compile)
#_______________________________________________________________________________

.PHONY: sim
sim: ## UVM: Runs simv simulation
	$(run_sim)
#_______________________________________________________________________________

.PHONY: verdi
verdi: ## UVM: Opens Verdi GUI
	@printf "$(C_CYN)%s: %s$(C_RST)\n" \
		"Openning Verdi GUI" "$(JOB_NAME)"
	@mkdir -p $(VERDI_DIR)
	cd $(VERDI_DIR) && verdi $(VERDI_FLAGS) &
#_______________________________________________________________________________

.PHONY: verdi-play
verdi-play: ## UVM: Opens Verdi GUI running verdi.tcl file
	@echo -e "$(C_ORA)Opening Verdi running verdi.cmd$(NC)"
	cd $(RUN_DIR) && verdi $(VERDI_FLAGS) $(VERDI_PLAY) &
#_______________________________________________________________________________

.PHONY: cov
cov: ## UVM: Create coverage report
	@printf "$(C_CYN)%s: %s$(C_RST)\n" \
		"Creating coverage report" "$(JOB_NAME)"
	@mkdir -p $(COV_DIR)/report
	cd $(RUN_DIR) && urg $(URG_FLAGS)
#_______________________________________________________________________________

.PHONY: verdi-cov
verdi-cov: ## UVM: Open coverage report in Verdi
	@printf "$(C_CYN)%s: %s$(C_RST)\n" \
		"Opening coverage report in Verdi" "$(JOB_NAME)"
	@mkdir -p $(VERDI_DIR)
	cd $(VERDI_DIR) && verdi $(VERDI_COV_FLAGS) &
#_______________________________________________________________________________

.PHONY: compile-dpi
compile-dpi: ## TB: Run dpi (C/C++) compilation
	@echo -e "$(C_ORA)TB: Compiling dpi (C/C++) code$(NC)"
	g++ -fPIC -c $(DPI_FILE) -I ${VCS_HOME}/include -o $(DPI_DIR)/dpi.o
# -fPIC Flag to generate position-independent code (shared library)
# If you want to compile dpi repeatedly and include the .o to simv
# but it's better to compile from vcs command
#_______________________________________________________________________________

.PHONY: clean
clean: ## UVM: Remove all simulation files
	@printf "$(C_CYN)%s$(C_RST)\n" "Removing all generated files"
	@rm -rf $(BUILD_DIR) $(RUN_DIR) $(LOGS_DIR) $(COV_DIR)
#_______________________________________________________________________________

.PHONY: clean-logs
clean-logs: ## UVM: Remove compilation and simulation logs
	@printf "$(C_CYN)%s$(C_RST)\n" "Removing log files"
	@find $(BUILD_DIR) -name "*_compile.log" -delete
	@find $(RUN_DIR)   -name "*_run.log"     -delete
#_______________________________________________________________________________

.PHONY: fsdb2vcd
fsdb2vcd: ## TB: Convert FSDB to VCD
	@echo -e "$(C_ORA)TB: Convert FSDB to VCD$(NC)"
	cd $(JOB_DIR) && fsdb2vcd novas.fsdb -o novas.vcd -sv
#_______________________________________________________________________________

.PHONY: vcd2fsdb
vcd2fsdb: ## TB: Convert VCD to FSDB
	@echo -e "$(C_ORA)TB: Convert VCD to FSDB$(NC)"
	cd $(JOB_DIR) && vcd2fsdb novas.vcd -o novas.fsdb -sv
#_______________________________________________________________________________

# ================================= INCLUDES ================================= #

.PHONY: help
help: ## UVM: Displays help message
	@echo -e "======================================================================"
	@echo -e "                               MAKEFILE.UVC                           "
	@echo -e "======================================================================"
	@echo "Usage: make <target> <variables>"
	@echo "--------------------------- Targets ----------------------------------"
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "- make $(C_LBL)%-15s$(NC) %s\n", $$1, $$2}'
	@echo "--------------------------- Variables -------------------------------"
	@echo "  TEST              : Name of UVM_TEST"
	@echo "  VERBOSITY         : UVM_VERBOSITY of the simulation, UVM_MEDIUM"
	@echo "  SEED_MODE         : Select seed mode [auto|fixed]"
	@echo "  SEED              : Random seed used, must be an integer > 0"
	@echo "  ENABLE_GUI        : Enables to run the sim in gui mode [true|false]"
	@echo "  ENABLE_CODE_COV   : Enables code coverage [true|false]"
	@echo "  VCS_DEFINES       : Add defines to vcs command"
	@echo "  RUN_ARGS          : Add plusargs to simv command"
	@echo "  JOB_NAME          : Name of the job (simulation folder)"
	@echo "-------------------------- Variable Values --------------------------"
	@echo "  TEST              : $(TEST)"
	@echo "  VERBOSITY         : $(VERBOSITY)"
	@echo "  SEED_MODE         : $(SEED_MODE)"
	@echo "  SEED              : $(SEED)"
	@echo "  ENABLE_GUI        : $(ENABLE_GUI)"
	@echo "  ENABLE_CODE_COV   : $(ENABLE_CODE_COV)"
	@echo "  VCS_DEFINES       : $(VCS_DEFINES)"
	@echo "  RUN_ARGS          : $(RUN_ARGS)"
	@echo "  JOB_NAME          : $(JOB_NAME)"
	@echo "======================================================================"
#_______________________________________________________________________________