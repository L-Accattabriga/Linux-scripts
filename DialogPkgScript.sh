#!/bin/bash
#
# Author: [Your Name]
# Title: Package Search and Install Script (Interactive with dialog)
# Date: [Today's Date]
# Description: A script to search for Debian packages, display results interactively
#              using dialog, and allow the user to select a package to install.

set -e

PKG="$1"
BATCH_SIZE="${2:-20}"  # Allow user to set batch size via argument, default to 20

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "The 'dialog' package is required but not installed. Please install it first."
    exit 1
fi

# Function to search for the package and store results in arrays
search_package() {
    local search_cmd="apt-cache search $PKG"
    local grep_cmd="grep --color=never -nP $PKG"

    mapfile -t output < <($search_cmd | $grep_cmd)
    mapfile -t output_colored < <($search_cmd | grep --color=always -nP $PKG)
}

# Check if a package is installed
is_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# Function to display results in a dialog menu
display_menu() {
    local start="$1"
    local end=$((start + BATCH_SIZE))

    if [ "$end" -gt "$total_results" ]; then
        end=$total_results
    fi

    # Create the options list for dialog
    local options=()
    for ((i = start; i < end; i++)); do
        line_number=$((i + 1))
        package_info=$(echo "${output[$i]}" | awk '{print $2}')
        description=$(echo "${output[$i]}" | cut -d' ' -f3-)
        options+=("$line_number" "$package_info - $description")
    done

    dialog --menu "Package Search Results (Showing $((start + 1)) to $end of $total_results)" 20 80 15 \
        "${options[@]}" 2> menu_choice

    return $?
}

# Main logic
if [ -z "$PKG" ]; then
    dialog --msgbox "Usage: $0 <package-name> [batch-size]" 6 50
    exit 1
fi

# Search for the package
search_package

# Total number of results
total_results=${#output[@]}

if [ "$total_results" -eq 0 ]; then
    dialog --msgbox "No results found for $PKG." 6 50
    exit 1
fi

start=0

# Loop for pagination and selection
while true; do
    display_menu "$start"
    
    # Check if the user pressed Cancel or made a selection
    if [ $? -ne 0 ]; then
        dialog --msgbox "Exiting without installing." 6 40
        break
    fi
    
    # Read the user's choice from the menu
    choice=$(<menu_choice)
    selected_line=${output[$((choice - 1))]}
    package_name=$(echo "$selected_line" | awk '{print $2}')
    
    # Check if the package is installed
    if is_installed "$package_name"; then
        dialog --msgbox "Package '$package_name' is already installed." 6 50
    else
        dialog --yesno "Package '$package_name' is not installed. Do you want to install it?" 6 50
        if [ $? -eq 0 ]; then
            dialog --infobox "Installing package: $package_name" 5 40
            sudo apt-get install -y "$package_name" 2> /dev/null
            dialog --msgbox "Package '$package_name' installed successfully." 6 50
        else
            dialog --msgbox "Installation of package '$package_name' canceled." 6 50
        fi
    fi

    # Ask the user if they want to continue
    dialog --yesno "Do you want to search or install another package?" 6 50
    if [ $? -ne 0 ]; then
        break
    fi
done

# Cleanup
rm -f menu_choice
