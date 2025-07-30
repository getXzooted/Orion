#!/bin/bash
#
# Orion.sh
# Main orchestrator for setting up the RFO-BASIC! environment.


set -e


# --- Main Configuration ---
export DOCKER_IMAGE="redroid/redroid:16.0.0_64only-latest"
export CONTAINER_NAME="orion-android"
export RFO_BASIC_APK_URL="https://github.com/RFO-BASIC/Basic/releases/download/v01.91/BASIC_v01.91.apk"
export RFO_BASIC_PACKAGE="com.rfo.basic"
export RFO_BASIC_ACTIVITY="com.rfo.basic.Basic"
export CLI_COMMAND_PATH="/usr/local/bin/orion"
export CALLING_USER="${1:-$USER}" # The user who ran sudo


# --- Script Paths ---
ORION_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="${ORION_BASE_DIR}/scripts"
DOCKER_SCRIPT="${SCRIPTS_DIR}/docker.sh"
RFO_SCRIPT="${SCRIPTS_DIR}/rfo.sh"
CLI_SCRIPT="${SCRIPTS_DIR}/Orion-cli.sh"
SERVICE_FILE_SRC="${ORION_BASE_DIR}/Orion.service"
SERVICE_FILE_DEST="/etc/systemd/system/orion.service"


echo "  ==> Stage 1: Docker Setup"
bash "${DOCKER_SCRIPT}"

echo "  ==> Stage 2: RFO-BASIC! Setup"
bash "${RFO_SCRIPT}"

echo "  ==> Stage 3: CLI and Service Setup"
bash "${CLI_SCRIPT}"


echo "  --> Installing and enabling systemd service..."
cp "${SERVICE_FILE_SRC}" "${SERVICE_FILE_DEST}"
# Replace placeholder in service file with the actual container name
sed -i "s/%%CONTAINER_NAME%%/${CONTAINER_NAME}/g" "${SERVICE_FILE_DEST}"
systemctl daemon-reload
systemctl enable --now orion.service


echo "Orchestration complete."