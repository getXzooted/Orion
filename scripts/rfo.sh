#!/bin/bash
#
# rfo.sh
# Installs RFO-BASIC! into the Waydroid environment.


set -e


# Inherits config from Orion.sh


echo "  --> Downloading RFO-BASIC! v1.92 APK..."
curl -L "${RFO_BASIC_APK_URL}" -o "${RFO_BASIC_APK_FILE}"

echo "  --> Installing APK into Waydroid..."
waydroid app install "${RFO_BASIC_APK_FILE}"


echo "RFO-BASIC! installation complete."