#!/usr/bin/env bash

##==============================================================================
## [Filename]       cov_last_run.sh
## [Project]        -
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       Bash scripting
## [Created]        -
## [Modified]       -
## [Description]    -
## [Notes]          -
##                   URG_COMMON_FLAGS is passed as a single quoted string from Make.
##                   Project paths are assumed not to contain spaces.
## [Status]         stable
## [Revisions]      -
##==============================================================================

# Exit on errors, undefined variables, and pipeline failures
set -euo pipefail

# --------------------------------- FUNCTIONS ----------------------------------

find_latest_file() {
    local search_dir="${1:?missing search_dir}"
    local pattern="${2:?missing pattern}"

    if [[ ! -d "$search_dir" ]]; then
        return 0
    fi

    find "$search_dir" -type f -name "$pattern" -printf '%T@ %p\n' |
        sort -n |
        tail -n 1 |
        cut -d' ' -f2-
}

fail() {
    printf '[FAIL] %s\n' "$1"
    exit 1
}

check_required_dir() {
    local name="$1"
    local value="${2:-}"

    [[ -n "$value" ]] || fail "$name is empty"
    [[ -d "$value" ]] || fail "$name does not exist: $value"
}

check_required_file() {
    local name="$1"
    local value="${2:-}"

    [[ -n "$value" ]] || fail "$name is empty"
    [[ -f "$value" ]] || fail "$name does not exist: $value"
}

# -------------------------------- CLI PARSING ---------------------------------

RUN_DIR="${1:?missing RUN_DIR}"
RUN_MANIFEST_GLOB="${2:?missing RUN_MANIFEST_GLOB}"
URG_COMMON_FLAGS="${3:?missing URG_COMMON_FLAGS}"

# ----------------------------- LOAD RUN MANIFEST ------------------------------

# Get the last run manifest file
RUN_MANIFEST_FILE="$(find_latest_file "$RUN_DIR" "$RUN_MANIFEST_GLOB")"

# Check if no manifest is found
if [[ -z "$RUN_MANIFEST_FILE" ]]; then
    printf '[FAIL] %s\n' "No run manifest found"
    exit 1
fi

# Load it
source "$RUN_MANIFEST_FILE"

# Check if run coverage database exists
check_required_dir "RUN_COV_DB" "${RUN_COV_DB:-}"

# --------------------------------- MAIN LOGIC ---------------------------------

# Check if code coverage was enabled at run time
if [[ "${ENABLE_CODE_COV_RUN:-false}" == "true" ]]; then

    # Check if build manifest exists
    check_required_file "BUILD_MANIFEST_FILE" "${BUILD_MANIFEST_FILE:-}"

    # Load it
    source "$BUILD_MANIFEST_FILE"

    # Check if build coverage database exists
    check_required_dir "BUILD_COV_DB" "${BUILD_COV_DB:-}"

    # Merge both databases
    printf '[INFO] %s\n' "Merging run + build coverage"
    urg -dir "$RUN_COV_DB" -dir "$BUILD_COV_DB" "$URG_COMMON_FLAGS"
else
    # Merge just run coverage
    printf '[INFO] %s\n' "Merging run coverage only"
    urg -dir "$RUN_COV_DB" "$URG_COMMON_FLAGS"
fi
