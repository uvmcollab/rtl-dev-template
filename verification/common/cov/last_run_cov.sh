#!/usr/bin/env bash

##==============================================================================
## [Filename]       last_run_cov.sh
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

##                    RUN_COV_DB
##                    BUILD_COV_DB

# Exit on errors, undefined variables, and pipeline failures
set -euo pipefail

# CLI parsing
RUN_DIR="${1:?missing RUN_DIR}"
RUN_MANIFEST_GLOB="${2:?missing RUN_MANIFEST_GLOB}"
URG_COMMON_FLAGS="${3:?missing URG_COMMON_FLAGS}"

RUN_MANIFEST_FILE="$(
    find "$RUN_DIR" -type f -name "$RUN_MANIFEST_GLOB" -printf '%T@ %p\n' |
    sort -n |
    tail -n 1 |
    cut -d' ' -f2-
)"

if [[ -z "$RUN_MANIFEST_FILE" ]]; then
    printf '[FAIL] %s\n' "No run manifest found"
    exit 1
fi

printf '[INFO] %s\n' "Using run manifest: $RUN_MANIFEST_FILE"

source "$RUN_MANIFEST_FILE"

# ----------------------------------- CHECKS -----------------------------------

if [[ -z "${RUN_COV_DB:-}" ]]; then
    printf '[FAIL] %s\n' "RUN_COV_DB is empty"
    exit 1
fi

if [[ ! -d "$RUN_COV_DB" ]]; then
    printf '[FAIL] %s\n' "RUN_COV_DB does not exist: $RUN_COV_DB"
    exit 1
fi

# --------------------------------- MAIN LOGIC ---------------------------------

if [[ "${ENABLE_CODE_COV_RUN:-false}" == "true" ]]; then
    if [[ -z "${BUILD_MANIFEST_FILE:-}" ]]; then
            printf '[FAIL] %s\n' "BUILD_MANIFEST_FILE is empty"
            exit 1
    fi

    if [[ ! -f "$BUILD_MANIFEST_FILE" ]]; then
            printf '[FAIL] %s\n' "Build manifest does not exist: $BUILD_MANIFEST_FILE"
            exit 1
    fi

    source "$BUILD_MANIFEST_FILE"

    if [[ -z "${BUILD_COV_DB:-}" ]]; then
            printf '[FAIL] %s\n' "BUILD_COV_DB is empty"
            exit 1
    fi

    if [[ ! -d "$BUILD_COV_DB" ]]; then
            printf '[FAIL] %s\n' "BUILD_COV_DB does not exist: $BUILD_COV_DB"
            exit 1
    fi

    printf '[INFO] %s\n' "Merging run + build coverage"
    eval urg -dir "\"$RUN_COV_DB\"" -dir "\"$BUILD_COV_DB\"" "$URG_COMMON_FLAGS"
else
    printf '[INFO] %s\n' "Using run coverage only"
    eval urg -dir "\"$RUN_COV_DB\"" "$URG_COMMON_FLAGS"
fi
