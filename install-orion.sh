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


echo "  ---------> Updating package lists <---------  "
apt-get update


echo "  ---------> Installing kernel modules and base prerequisites <---------  "
# Install the extra modules package first, as it's a host system requirement.
apt-get install -y linux-modules-extra-$(uname -r)
# Install other prerequisites needed before adding new repos.
apt-get install -y curl gpg lxc


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


echo "  ---------> Setting up Waydroid repository <---------  "
# Add Waydroid repo GPG key
curl -sS https://downloads.waydro.id/repo/waydroid.gpg | gpg --dearmor -o /usr/share/keyrings/waydroid.gpg

# Add the repository to sources
export DISTRO="bookworm" # Raspberry Pi OS 12 is based on Debian Bookworm
echo "deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://downloads.waydro.id/repo/ $DISTRO main" > /etc/apt/sources.list.d/waydroid.list

echo "  --> Updating package list to include Waydroid repo..."
apt-get update


echo "  ---------> Installing Waydroid and its dependencies <---------  "
# Now install Waydroid and its specific dependencies like python3-gbinder
apt-get install -y waydroid python3-gbinder


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