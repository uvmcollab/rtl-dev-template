##==============================================================================
## [Filename]       project.vcs
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

# ---------------------------------- GENERAL -----------------------------------
GIT_DIR := $(shell git rev-parse --show-toplevel)
MK_DIR  := $(GIT_DIR)/verification/uvm/scripts/mk

# Main framework
include $(MK_DIR)/common.mk

# Regression Manager
-include $(MK_DIR)/regression.mk
