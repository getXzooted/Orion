#!/bin/bash
#
# docker.sh
# Installs Docker and sets up the Android container.


set -e


# Inherits config from Orion.sh
echo "  --> Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker "${CALLING_USER}"
    echo "Docker installed. User '${CALLING_USER}' added to the docker group."
else
    echo "Docker is already installed."
fi


echo "  --> Pulling Android image: ${DOCKER_IMAGE}"
docker pull "${DOCKER_IMAGE}"


echo "  --> Stopping and removing any existing container named ${CONTAINER_NAME}"
docker stop "${CONTAINER_NAME}" >/dev/null 2>&1 || true
docker rm "${CONTAINER_NAME}" >/dev/null 2>&1 || true


echo "  --> Starting new Android container: ${CONTAINER_NAME}"
# Note: We run it without -d because systemd will manage the process.
# --rm is removed so the container persists across reboots.
docker run --privileged \
    --name "${CONTAINER_NAME}" \
    -v /dev/binderfs:/dev/binderfs \
    -v /dev/ashmem:/dev/ashmem \
    -p 5555:5555 \
    "${DOCKER_IMAGE}" &

echo "Container starting in background. Waiting for boot..."
sleep 60 # Give it time to initialize before the next stage.