#!/bin/bash

# Prompt for user input
read -p "Enter script name: " NAME
read -p "Enter location: " LOCATION
read -p "Enter author: " AUTHOR
read -p "Enter date: " DATE
read -p "Enter revision number: " REVISION

# Set paths
TEMPLATE_SCRIPT="/path/to/template_script.sh"
NEW_SCRIPT="/path/to/new_script.sh"

# Create the new script by replacing placeholders
sed -e "s/{{NAME}}/$NAME/g" \
    -e "s/{{LOCATION}}/$LOCATION/g" \
    -e "s/{{AUTHOR}}/$AUTHOR/g" \
    -e "s/{{DATE}}/$DATE/g" \
    -e "s/{{REVISION}}/$REVISION/g" \
    "$TEMPLATE_SCRIPT" > "$NEW_SCRIPT"

# Set the new script as executable
chmod +x "$NEW_SCRIPT"

echo "New script created at $NEW_SCRIPT"