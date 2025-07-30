#!/bin/bash
#
# Orion-cli.sh
# Creates the 'orion' command line interface.


set -e


# Inherits config from Orion.sh


echo "  --> Creating 'orion' command..."



# Create the main user-facing command
cat > "$CLI_COMMAND_PATH" << EOF
#!/bin/bash
#
# Orion CLI - RFO-BASIC! Runner


set -e


CONTAINER_NAME="${CONTAINER_NAME}"
PACKAGE="${RFO_BASIC_PACKAGE}"
ACTIVITY="${RFO_BASIC_ACTIVITY}"
SCRIPT_FILE="\$1"


if [ -z "\$SCRIPT_FILE" ]; then
    echo "Usage: orion <path_to_script.bas>"
    echo "Example: orion my_program.bas"
    exit 1
fi

if [ ! -f "\$SCRIPT_FILE" ]; then
    echo "Error: File not found at '\$SCRIPT_FILE'"
    exit 1
fi


# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "^\${CONTAINER_NAME}\$"; then
    echo "Orion container is not running. Starting it with 'sudo systemctl start orion'..."
    sudo systemctl start orion
    echo "Waiting for container to settle..."
    sleep 15
fi

FILENAME=\$(basename -- "\$SCRIPT_FILE")
CONTAINER_SCRIPT_PATH="/data/local/tmp/\$FILENAME"


echo "--> Copying '\$FILENAME' to the Android container"
docker cp "\$SCRIPT_FILE" "\${CONTAINER_NAME}:\${CONTAINER_SCRIPT_PATH}"


echo "--> Executing script with RFO-BASIC!"
docker exec "\${CONTAINER_NAME}" adb shell am start -n "\${PACKAGE}/\${ACTIVITY}" -d "file://\${CONTAINER_SCRIPT_PATH}"


echo "--> NOTE: Output will appear in the RFO-BASIC! app window."
echo "    Connect with a VNC client to localhost:5555 to see the GUI."
EOF



# Make the command executable
chmod +x "$CLI_COMMAND_PATH"


echo "CLI command 'orion' created at ${CLI_COMMAND_PATH}."