#!/usr/bin/env bash

##==============================================================================
## [Filename]       check_run.sh
## [Project]        -
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       Bash scripting
## [Created]        -
## [Modified]       -
## [Description]    Checks the la
## [Notes]          -
##                   URG_COMMON_FLAGS is passed as a single quoted string from Make.
##                   Project paths are assumed not to contain spaces.
## [Status]         stable
## [Revisions]      -
##==============================================================================

# Exit on errors, undefined variables, and pipeline failures
set -euo pipefail

# --------------------------------- FUNCTIONS ----------------------------------

fail() {
    printf '[FAIL] %s\n' "$1"
    exit 1
}

pass() {
    printf '[PASS] %s\n' "$1"
    exit 0
}

check_required_file() {
    local name="$1"
    local value="${2:-}"

    [[ -n "$value" ]] || fail "$name is empty"
    [[ -f "$value" ]] || fail "$name does not exist: $value"
}


check_non_empty() {
    local name="$1"
    local value="${2:-}"

    [[ -n "$value" ]] || fail "$name is empty"
}

# -------------------------------- CLI PARSING ---------------------------------

RUN_MANIFEST_FILE="${1:?missing RUN_MANIFEST_FILE}"
check_required_file "RUN_MANIFEST_FILE" "$RUN_MANIFEST_FILE"

# ------------------------------------ LOAD ------------------------------------

# Load manifest
source "$RUN_MANIFEST_FILE"

# Check RUN_LOG
check_required_file "RUN_LOG" "${RUN_LOG:-}"

# Check SIM_STATUS
check_non_empty "SIM_STATUS" "${SIM_STATUS:-}"

# Gate 1: simulator exit code
if [[ "$SIM_STATUS" != "0" ]]; then
    fail "TEST_ID=${TEST_ID:-unknown} SIM_STATUS=$SIM_STATUS"
fi

# Gate 2: UVM summary counts
uvm_errors=$(grep -oP 'UVM_ERROR\s*:\s*\K[0-9]+' "$RUN_LOG" | tail -1 || true)
uvm_fatals=$(grep -oP 'UVM_FATAL\s*:\s*\K[0-9]+' "$RUN_LOG" | tail -1 || true)

if [[ "${uvm_errors:-0}" -gt 0 || "${uvm_fatals:-0}" -gt 0 ]]; then
    fail "TEST_ID=${TEST_ID:-unknown} UVM_ERROR=${uvm_errors:-0} UVM_FATAL=${uvm_fatals:-0}"
fi

# Gate 3: crash/timeout patterns (sim may have died before printing summary)
FAIL_PATTERNS=(
    'Assertion.*failed'
    'TIMEOUT'
    'TEST FAILED'
    'Segmentation fault'
    'core dumped'
    'FAILED:\s*[1-9][0-9]*'   # project-specific: non-zero FAILED count
)

for pattern in "${FAIL_PATTERNS[@]}"; do
    match=$(grep -nP "$pattern" "$RUN_LOG" 2>/dev/null | head -1 || true)
    if [[ -n "$match" ]]; then
        fail "TEST_ID=${TEST_ID:-unknown} matched '$pattern': ${RUN_LOG}:${match}"
    fi
done

pass "TEST_ID=${TEST_ID:-unknown} SIM_STATUS=0 and no fail pattern matched"