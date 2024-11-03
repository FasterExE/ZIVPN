#!/bin/bash

# Path to configuration and log files
CONFIG_FILE="/etc/zivpn/config.json"
LOG_FILE="/etc/zivpn/user.log"

# Prompt the user for a username and validity period in days
read -p "Enter username to add: " username
read -p "Enter validity period in days: " days_valid

# Calculate the expiration date
expiry_date=$(date -d "+$days_valid days" +"%d/%m/%Y")

# Use sed to insert the username before the closing bracket of the config array
sed -i "/\"config\": \[/ s/\]/,\"$username\"\]/" "$CONFIG_FILE"
sudo systemctl restart zivpn
# Check if the update was successful
if [ $? -eq 0 ]; then
    # Log the username and expiration date in user.log
    echo "$username:$expiry_date" >> "$LOG_FILE"
    echo "User added successfully and logged in user.log."
else
    echo "Error: Could not update config.json."
fi
