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

# -------------------------------- CLI PARSING ---------------------------------

RUN_DIR="${1:?missing RUN_DIR}"
RUN_MANIFEST_GLOB="${2:?missing RUN_MANIFEST_GLOB}"
URG_COMMON_FLAGS="${3:?missing URG_COMMON_FLAGS}"

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

# ------------------------------------ LOAD ------------------------------------

# Get the last run manifest file
RUN_MANIFEST_FILE="$(find_latest_file "$RUN_DIR" "$RUN_MANIFEST_GLOB")"

# Check if no manifest is found
if [[ -z "$RUN_MANIFEST_FILE" ]]; then
    printf '[FAIL] %s\n' "No run manifest found"
    exit 1
fi

# printf '[INFO] %s\n' "Using run manifest: $RUN_MANIFEST_FILE"
source "$RUN_MANIFEST_FILE"

# ----------------------------------- CHECKS -----------------------------------

check_required_dir "RUN_COV_DB" "${RUN_COV_DB:-}"

# Check if the value exists in the manifest
# if [[ -z "${RUN_COV_DB:-}" ]]; then
#     printf '[FAIL] %s\n' "RUN_COV_DB is empty"
#     exit 1
# fi

# Check if the directory exists
# if [[ ! -d "$RUN_COV_DB" ]]; then
#     printf '[FAIL] %s\n' "RUN_COV_DB does not exist: $RUN_COV_DB"
#     exit 1
# fi

# --------------------------------- MAIN LOGIC ---------------------------------

# Check if code coverage was enabled at run time
if [[ "${ENABLE_CODE_COV_RUN:-false}" == "true" ]]; then

    # Check if the value exists
    # if [[ -z "${BUILD_MANIFEST_FILE:-}" ]]; then
    #     printf '[FAIL] %s\n' "BUILD_MANIFEST_FILE is empty"
    #     exit 1
    # fi

    # Check if manifest exists
    # if [[ ! -f "$BUILD_MANIFEST_FILE" ]]; then
    #     printf '[FAIL] %s\n' "Build manifest does not exist: $BUILD_MANIFEST_FILE"
    #     exit 1
    # fi

    check_required_file "BUILD_MANIFEST_FILE" "${BUILD_MANIFEST_FILE:-}"

    source "$BUILD_MANIFEST_FILE"

    # Check if the value exists
    # if [[ -z "${BUILD_COV_DB:-}" ]]; then
    #     printf '[FAIL] %s\n' "BUILD_COV_DB is empty"
    #     exit 1
    # fi

    # Check if the directory exists
    # if [[ ! -d "$BUILD_COV_DB" ]]; then
    #     printf '[FAIL] %s\n' "BUILD_COV_DB does not exist: $BUILD_COV_DB"
    #     exit 1
    # fi
    check_required_dir "BUILD_COV_DB" "${BUILD_COV_DB:-}"

    printf '[INFO] %s\n' "Merging run + build coverage"
    urg -dir "$RUN_COV_DB" -dir "$BUILD_COV_DB" "$URG_COMMON_FLAGS"
else
    printf '[INFO] %s\n' "Using run coverage only"
    urg -dir "$RUN_COV_DB" "$URG_COMMON_FLAGS"
fi
