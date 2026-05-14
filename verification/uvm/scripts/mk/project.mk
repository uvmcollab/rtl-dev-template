##==============================================================================
## [Filename]       project.mk
## [Project]        -
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       GNU Makefile
## [Created]        -
## [Modified]       -
## [Description]    UVM project
## [Notes]          -
## [Status]         stable
## [Revisions]      -
##==============================================================================

# ================================ DIRECTORIES =================================
# Project paths and directory hierarchy

GIT_DIR       := $(shell git rev-parse --show-toplevel)
TB_DIR        ?= $(GIT_DIR)/verification/uvm
COMMON_MK_DIR := $(GIT_DIR)/verification/common/mk

# =============================== CONFIGURATION ================================
# Project-specific defaults

ENABLE_UVM           ?= true
ENABLE_DEBUG_DB      ?= false
ENABLE_UVM_RECORDING ?= false
DUMP_MODE            ?= none
UVCS_FILELIST        ?= -F $(TB_DIR)/uvcs.f
DPI_FILE             ?= $(DPI_DIR)/lib/libdpi.so
COMPILE_ARGS         ?=
#-cm_hier $(ROOT_DIR)/cov.cfg

# Coverage
ENABLE_CODE_COV_COMPILE ?= false
CODE_COV_TYPES_COMPILE ?= line+cond+tgl

ENABLE_CODE_COV_RUN ?= false
CODE_COV_TYPES_RUN ?= line+cond+tgl

RUN_ARGS ?= +uvm_set_config_int=uvm_test_top.m_env.vsqr,m_cli_iter,100 \
			+uvm_set_config_int=uvm_test_top.m_env.vsqr,m_cli_cycles_asserted,120 \
			+uvm_set_config_int=uvm_test_top.m_env.vsqr,m_cli_cycles_deasserted,120

# ================================== INCLUDES ==================================

# Main framework
include $(COMMON_MK_DIR)/common.mk

# DPI
-include $(COMMON_MK_DIR)/dpi.mk

# Coverage
-include $(COMMON_MK_DIR)/cov.mk

# Regression Manager
-include $(MK_DIR)/regression.mk

# ================================= HELP MENU ==================================

.PHONY: help
help: ## COMMON: Displays help message
	@printf "%s\n" "================================================================================"
	@printf "%s\n" "                                    PROJECT.MK                                  "
	@printf "%s\n" "================================================================================"
	@printf "%s\n" "Usage: make <target> [variables]"
	@printf "%s\n" "------------------------------------ TARGETS -----------------------------------"
	@grep -h -E '^help-[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "- make $(C_CYN)%-15s$(C_RST) %s\n", $$1, $$2}'
	@printf "%s\n" "================================================================================"
