#!/bin/bash
#
# rfo.sh
# Installs RFO-BASIC! into the container.


set -e


# Inherits config from Orion.sh
RFO_BASIC_APK_FILE="/tmp/BASIC_v01.92.apk"


echo "  --> Downloading RFO-BASIC! APK..."
curl -L "${RFO_BASIC_APK_URL}" -o "${RFO_BASIC_APK_FILE}"


echo "  --> Connecting ADB to the container..."
docker exec "${CONTAINER_NAME}" adb connect localhost:5555


# Wait for the device to be fully booted
echo "  --> Waiting for Android boot to complete..."
until docker exec "${CONTAINER_NAME}" adb shell getprop sys.boot_completed | grep -m 1 "1"; do
    echo "Waiting..."
    sleep 10
done


echo "  --> Installing RFO-BASIC! APK inside the container..."
docker cp "${RFO_BASIC_APK_FILE}" "${CONTAINER_NAME}:/data/local/tmp/basic.apk"
docker exec "${CONTAINER_NAME}" adb install /data/local/tmp/basic.apk


echo "RFO-BASIC! installation complete."