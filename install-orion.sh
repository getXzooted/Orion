#!/bin/bash
#
# install-orion.sh
# Clones and bootstraps the Orion RFO-BASIC! Environment.


set -e


# --- Configuration ---
PROJECT_DIR="/opt/Orion"
REPO_URL="https://github.com/getXzooted/Orion.git"


echo "  ---------> Starting Orion Bootstrap <---------  "
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run as root."
    exit 1
fi


echo "  ---------> Installing prerequisites (git, curl) <---------  "
apt-get update
apt-get install -y --fix-broken git curl


echo "  ---------> Cleaning up previous installation <---------  "
rm -rf "$PROJECT_DIR"


echo "  ---------> Cloning repository: ${REPO_URL} <---------  "
git clone "${REPO_URL}" "${PROJECT_DIR}"
cd "${PROJECT_DIR}"


echo "  ---------> Running the Orion Installer <---------  "
# Pass the original username to the main script
sudo -E bash ./Orion.sh "${SUDO_USER:-$USER}"


echo "----------------------------------------------------------------"
echo " SUCCESS: Orion bootstrap complete!"
echo " The Orion service is now enabled and will start on boot."
echo " You can manage the container with: sudo systemctl [start|stop|status] orion"
echo " Please log out and log back in for Docker permissions to apply."
echo "----------------------------------------------------------------"