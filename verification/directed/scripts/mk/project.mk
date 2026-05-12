##==============================================================================
## [Filename]       project.mk
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

# ================================ DIRECTORIES =================================
# Project paths and directory hierarchy

GIT_DIR       := $(shell git rev-parse --show-toplevel)
TB_DIR        ?= $(GIT_DIR)/verification/directed
COMMON_MK_DIR := $(GIT_DIR)/verification/common/mk
DPI_DIR       := $(GIT_DIR)/verification/common/dpi

# =============================== CONFIGURATION ================================
# Project-specific defaults

ENABLE_UVM ?= false
DPI_FILE   ?= $(DPI_DIR)/lib/libdpi.so

# ================================== INCLUDES ==================================

# Main framework
include $(COMMON_MK_DIR)/common.mk

# DPI
-include $(COMMON_MK_DIR)/dpi.mk

# Regression Manager
-include $(MK_DIR)/regression.mk
