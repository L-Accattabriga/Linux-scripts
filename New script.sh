#!/bin/bash
set -euo pipefail

# Script Variables
SCRIPTS_DIR="/usr/local/bin"

# Function to create a new script
create_script() {
    local script_name
    local description

    # Use read -p for prompts
    read -p "Enter the name of your new script (without extension): " script_name
    script_name="${script_name}.sh"

    read -p "Enter a brief description for the script: " description

    local script_path="$SCRIPTS_DIR/$script_name"

    # Check if the script already exists
    if [[ -e "$script_path" ]]; then
        echo "Error: $script_path already exists. Choose another name."
        exit 1
    fi

    # Generate the script content
    {
        echo "#!/bin/bash"
        echo "# Author: $(whoami)"
        echo "# Date: $(date '+%Y-%m-%d')"
        echo "# Description: $description"
        echo "set -euo pipefail"
        echo
        echo "# Start writing your script below this line:"
    } > "$script_path"

    # Make the script executable
    chmod +x "$script_path"
    echo "Script created successfully: $script_path"

    # Offer to open the new script
    read -p "Do you want to open the script for editing? (y/n): " open_choice
    if [[ "$open_choice" == "y" || "$open_choice" == "Y" ]]; then
        "${EDITOR:-nano}" "$script_path"
    fi
}

# Main Execution
create_script