#!/bin/bash

# Define paths (assuming everything is in the same directory as this script)
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_FILE="$SCRIPT_DIR/auto_commit.sh"
PLIST_FILE_NAME="com.yourusername.autogit.plist"
PLIST_DESTINATION="/Library/LaunchDaemons/$PLIST_FILE_NAME"
LOG_DIR="$SCRIPT_DIR/logs"
OUT_LOG="$LOG_DIR/auto_commit_out.log"
ERR_LOG="$LOG_DIR/auto_commit_err.log"

# Name for the launch daemon service
SERVICE_NAME="com.yourusername.autogit"

# Ensure the auto commit script is executable
chmod +x $SCRIPT_FILE

# Create logs directory if it doesn't exist
if [ ! -d "$LOG_DIR" ]; then
  echo "Creating logs directory at $LOG_DIR..."
  mkdir -p "$LOG_DIR"
fi

# Copy the plist file to /Library/LaunchDaemons
echo "Copying plist file to /Library/LaunchDaemons..."
sudo cp "$SCRIPT_DIR/$PLIST_FILE_NAME" "$PLIST_DESTINATION"

# Set the correct permissions on the plist file (owner: root, mode: 644)
echo "Setting correct permissions for plist file..."
sudo chown root:wheel "$PLIST_DESTINATION"
sudo chmod 644 "$PLIST_DESTINATION"

# Update the plist file in the target location to use the correct path for the script and log files
echo "Updating the plist file in /Library/LaunchDaemons to point to the correct script path and log files..."
sudo sed -i.bak \
  -e "s|/path/to/auto_commit.sh|$SCRIPT_FILE|g" \
  -e "s|/path/to/auto_commit_out.log|$OUT_LOG|g" \
  -e "s|/path/to/auto_commit_err.log|$ERR_LOG|g" \
  "$PLIST_DESTINATION"

# Load the service to start it
echo "Loading the launch daemon..."
sudo launchctl load "$PLIST_DESTINATION"

# Start the service manually if it should run immediately
echo "Starting the service..."
sudo launchctl start $SERVICE_NAME

echo "Service has been installed and started."
