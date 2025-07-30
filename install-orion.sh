#!/bin/bash
#
# install-orion.sh
# Clones and bootstraps the Orion RFO-BASIC! Environment using Waydroid.


set -e


# --- Configuration ---
PROJECT_DIR="/opt/Orion"
REPO_URL="https://github.com/YourUsername/Orion.git" # <-- CHANGE THIS


echo "  ---------> Starting Orion Waydroid Bootstrap <---------  "
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run as root."
    exit 1
fi


echo "  ---------> Installing prerequisites and kernel modules <---------  "
apt-get update

# Install standard packages AND the extra kernel modules required for Waydroid
apt-get install -y curl gpg lxc python3-gbinder linux-modules-extra-$(uname -r)


echo "  ---------> Enabling required kernel modules for Waydroid <---------  "

# Load modules for the current session
echo "  --> Loading binder_linux and ashmem_linux for this session..."
modprobe binder_linux || echo "binder_linux module failed to load or was already loaded."
modprobe ashmem_linux || echo "ashmem_linux module failed to load or was already loaded."

# Ensure modules load on boot
cat > /etc/modules-load.d/waydroid.conf << EOF
binder_linux
ashmem_linux
EOF
echo "  --> Configured modules to load on boot."


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
echo " Waydroid is now installed and configured."
echo " You can now use the 'orion' command to run BASIC scripts."
echo "----------------------------------------------------------------"