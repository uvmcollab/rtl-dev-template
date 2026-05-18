##==============================================================================
## [Filename]       cov.mk
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

# ============================= COVERAGE MANIFESTS =============================

BUILD_MANIFEST_NAME ?= build_manifest.mk
RUN_MANIFEST_EXT    ?= run_manifest.mk

# File matching patterns (globs)
RUN_MANIFEST_GLOB   ?= *.$(RUN_MANIFEST_EXT)
BUILD_MANIFEST_GLOB ?= $(BUILD_MANIFEST_NAME)

# ================================ DIRECTORIES =================================

COV_MERGE_NAME ?= merged.vdb
COV_MERGE_DB   ?= $(COV_MERGE_DIR)/$(COV_MERGE_NAME)

# ================================ TOOLS SETUP =================================

URG_COMMON_FLAGS = -full64 -format both \
				 -report $(COV_REPORT_DIR) \
				 -dbname $(COV_MERGE_DB) \
				 -show tests \
				 -log $(COV_LOGS_DIR)/$(CUR_DATE)_cov.log

VERDI_COV_FLAGS ?= -q -cov -covdir $(COV_MERGE_DB)

# ================================  TARGETS  ==================================

# .PHONY: cov-list-builds
# cov-list-builds: ## COV: List all build coverage manifests
# 	@printf "$(C_CYN)%s$(C_RST)\n" "Build manifests"
# 	@find $(BUILD_DIR) -type f -name "$(BUILD_MANIFEST_GLOB)" | sort
# #______________________________________________________________________________

# .PHONY: cov-list-runs
# cov-list-runs: ## COV: List all run coverage manifests
# 	@printf "$(C_CYN)%s$(C_RST)\n" "Run manifests"
# 	@find $(RUN_DIR) -type f -name "$(RUN_MANIFEST_GLOB)" | sort
# #______________________________________________________________________________

# .PHONY: cov-last-manifest
# cov-last-manifest: ## COV: Print latest run coverage manifest
# 	@printf "$(C_CYN)%s$(C_RST)\n" "Last manifest"
# 	@find $(RUN_DIR) -type f -name "$(RUN_MANIFEST_GLOB)" -printf '%T@ %p\n' | \
# 			sort -n | tail -n -1 | cut -d' ' -f2-
# #______________________________________________________________________________

.PHONY: clean-cov
clean-cov: ## COV: Remove coverage files and manifests
	@printf "$(C_CYN)%s$(C_RST)\n" "Removing coverage merge and reports"
	@rm -rf $(COV_DIR)
	@printf "$(C_CYN)%s$(C_RST)\n" "Removing coverage manifests"
	@find $(BUILD_DIR) -type f -name "$(BUILD_MANIFEST_GLOB)" -delete
	@find $(RUN_DIR)   -type f -name "$(RUN_MANIFEST_GLOB)"   -delete
	@printf "$(C_CYN)%s$(C_RST)\n" "Removing coverage databases"
	@find $(RUN_DIR)   -depth -type d -name "*.vdb" -exec rm -rf {} +
# 	@find $(BUILD_DIR) -depth -type d -name "*.vdb" -exec rm -rf {} +
#______________________________________________________________________________

.PHONY: cov
cov: ## COV: Generating coverate from last run
	@printf "$(C_CYN)%s$(C_RST)\n" "Generating coverage from the last run"
	@mkdir -p $(COV_LOGS_DIR)
	@bash $(COMMON_COV_DIR)/last_run_cov.sh $(RUN_DIR) $(RUN_MANIFEST_GLOB) "$(URG_COMMON_FLAGS)"
#______________________________________________________________________________

.PHONY: verdi-cov
verdi-cov: ## COMMON: Open coverage report in Verdi
	@printf "$(C_CYN)%s: $(C_RST)\n" "Opening coverage report in Verdi"
	@mkdir -p $(VERDI_DIR)
	cd $(VERDI_DIR) && verdi $(VERDI_COV_FLAGS) &
#_______________________________________________________________________________

.PHONY: play
play: 
	@find $(BUILD_DIR) -depth -type d -name "*.vdb"


.PHONY: print-cov
print-cov: ## COV: Print Makefile variables
	$(call print_var,URG_COMMON_FLAGS)
	$(call print_var,VERDI_COV_FLAGS)
#______________________________________________________________________________

help-cov: ## COV: Displays help message
	@printf "%s\n" "================================================================================"
	@printf "%s\n" "                                       COB.MK                                   "
	@printf "%s\n" "================================================================================"
	@printf "%s\n" "Usage: make <target> [variables]"
	@printf "%s\n" "------------------------------------ TARGETS -----------------------------------"
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(COMMON_MK_DIR)/cov.mk | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "- make $(C_CYN)%-15s$(C_RST) %s\n", $$1, $$2}'
	@printf "%s\n" "================================================================================"
#_______________________________________________________________________________