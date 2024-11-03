#!/bin/bash

# Path to configuration and log files
CONFIG_FILE="/etc/zivpn/config.json"
LOG_FILE="/etc/zivpn/user.log"

# Prompt the user for a username and validity period in days
while true; do
    read -p "Enter username to add (letters only): " username
    # Check if username contains only letters
    if [[ "$username" =~ ^[a-zA-Z]+$ ]]; then
        # Check if username already exists in config.json or user.log
        if grep -q "\"$username\"" "$CONFIG_FILE" || grep -q "^$username:" "$LOG_FILE"; then
            echo "Error: Username '$username' already exists. Please try another."
        else
            break  # Username is valid and doesn't exist, so exit the loop
        fi
    else
        echo "Error: Username must contain letters only."
    fi
done

while true; do
    read -p "Enter validity period in days (numbers only): " days_valid
    # Check if days_valid contains only numbers
    if [[ "$days_valid" =~ ^[0-9]+$ ]]; then
        break
    else
        echo "Error: Validity period must be a number."
    fi
done

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
