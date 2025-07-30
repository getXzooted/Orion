#!/bin/bash
#
# waydroid.sh
# Installs and initializes the Waydroid environment.


set -e


# Inherits config from Orion.sh


echo "  --> Setting up Waydroid repository..."

# Add Waydroid repo GPG key
curl -sS https://downloads.waydro.id/repo/waydroid.gpg | gpg --dearmor -o /usr/share/keyrings/waydroid.gpg

# Add the repository to sources
export DISTRO="bookworm" # Raspberry Pi OS 12 is based on Debian Bookworm
echo "deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://downloads.waydro.id/repo/ $DISTRO main" > /etc/apt/sources.list.d/waydroid.list


echo "  --> Updating package list..."
apt-get update


echo "  --> Installing Waydroid package..."
apt-get install -y waydroid


echo "  --> Initializing Waydroid (downloading system images)..."
waydroid init


echo "  --> Enabling and starting Waydroid container service..."
systemctl enable --now waydroid-container


echo "  --> Waiting for Waydroid service to be ready..."
sleep 20 # Give the service time to fully start up


echo "Waydroid setup complete."