#!/bin/bash
#
# Orion.sh
# Main orchestrator for setting up the Waydroid RFO-BASIC! environment.


set -e


# --- Main Configuration ---
export RFO_BASIC_APK_URL="https://github.com/RFO-BASIC/Basic/releases/download/v01.92/BASIC_v01.92.apk"
export RFO_BASIC_APK_FILE="/tmp/BASIC_v01.92.apk"
export CLI_COMMAND_PATH="/usr/local/bin/orion"
export CALLING_USER="${1:-$USER}" # The user who ran sudo
export CALLING_USER_HOME=$(getent passwd "${CALLING_USER}" | cut -d: -f6)


# --- Script Paths ---
ORION_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="${ORION_BASE_DIR}/scripts"
WAYDROID_SCRIPT="${SCRIPTS_DIR}/waydroid.sh"
RFO_SCRIPT="${SCRIPTS_DIR}/rfo.sh"
CLI_SCRIPT="${SCRIPTS_DIR}/Orion-cli.sh"


echo "  ==> Stage 1: Waydroid Setup"
bash "${WAYDROID_SCRIPT}"

echo "  ==> Stage 2: RFO-BASIC! Installation"
bash "${RFO_SCRIPT}"

echo "  ==> Stage 3: CLI Command Setup"
bash "${CLI_SCRIPT}"


echo "Orchestration complete."