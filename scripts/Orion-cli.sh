#!/bin/bash
#
# Orion-cli.sh
# Creates the 'orion' command line interface for Waydroid.


set -e


# Inherits config from Orion.sh


echo "  --> Creating 'orion' command..."

# Create the shared directory if it doesn't exist, and set permissions
WAYDROID_SHARED_DIR="${CALLING_USER_HOME}/waydroid/data/media/0"
mkdir -p "${WAYDROID_SHARED_DIR}"
chown -R "${CALLING_USER}:${CALLING_USER}" "${CALLING_USER_HOME}/waydroid"


# Create the main user-facing command
cat > "$CLI_COMMAND_PATH" << EOF
#!/bin/bash
#
# Orion CLI - RFO-BASIC! Runner for Waydroid


set -e


SCRIPT_FILE="\$1"
CALLING_USER_HOME=\$(getent passwd "\$(whoami)" | cut -d: -f6)
WAYDROID_SHARED_DIR="\${CALLING_USER_HOME}/waydroid/data/media/0"
RFO_PACKAGE="com.rfo.basic"
RFO_ACTIVITY="com.rfo.basic.Basic"


if [ -z "\$SCRIPT_FILE" ]; then
    echo "Usage: orion <path_to_script.bas>"
    echo "Example: orion my_program.bas"
    exit 1
fi

if [ ! -f "\$SCRIPT_FILE" ]; then
    echo "Error: File not found at '\$SCRIPT_FILE'"
    exit 1
fi


# Ensure Waydroid session is running
if ! waydroid status &> /dev/null | grep -q "RUNNING"; then
    echo "--> Starting Waydroid session..."
    waydroid session start &
    sleep 10 # Give the session time to start
fi


FILENAME=\$(basename -- "\$SCRIPT_FILE")
HOST_SCRIPT_PATH="\${WAYDROID_SHARED_DIR}/\${FILENAME}"
ANDROID_SCRIPT_PATH="file:///storage/emulated/0/\${FILENAME}"


echo "--> Copying '\$FILENAME' to Waydroid's shared storage..."
cp "\$SCRIPT_FILE" "\$HOST_SCRIPT_PATH"


echo "--> Executing script with RFO-BASIC!"
waydroid app launch "\${RFO_PACKAGE}" -d "\${ANDROID_SCRIPT_PATH}"


echo "--> NOTE: Output will appear in the RFO-BASIC! app window."
echo "    Waydroid can be viewed with a VNC client or on the physical display."
EOF


# Make the command executable
chmod +x "$CLI_COMMAND_PATH"


echo "CLI command 'orion' created at ${CLI_COMMAND_PATH}."