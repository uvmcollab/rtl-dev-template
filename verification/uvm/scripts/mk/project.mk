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

ENABLE_UVM    ?= true
UVCS_FILELIST ?= -F $(TB_DIR)/uvcs.f

# ================================== INCLUDES ==================================

# Main framework
include $(COMMON_MK_DIR)/common.mk

# DPI
-include $(COMMON_MK_DIR)/dpi.mk

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
