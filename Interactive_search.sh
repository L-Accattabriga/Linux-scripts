#!/bin/bash
#
# Author: [Your Name]
# Title: Package Search and Install Script (Interactive with dialog)
# Date: [Today's Date]
# Description: A script to search for Debian packages, display results interactively
#              using dialog, and allow the user to select a package to install.

set -e

PKG="$1"
BATCH_SIZE=20  # Number of results per page

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "The 'dialog' package is required but not installed. Please install it first."
    exit 1
fi

# Search for the package and store the results in an array (no color for processing)
command_no_color="apt-cache search $PKG | grep --color=never -nP $PKG"
mapfile -t output < <(eval $command_no_color)

# Also store the output with color for displaying to the user
command_with_color="apt-cache search $PKG | grep --color=always -nP $PKG"
mapfile -t output_colored < <(eval $command_with_color)

# Total number of results
total_results=${#output[@]}

if [ "$total_results" -eq 0 ]; then
    dialog --msgbox "No results found for $PKG." 6 50
    exit 1
fi

echo "Total results: $total_results"
start=0

# Function to display results in a dialog menu
show_batch() {
    end=$((start + BATCH_SIZE))
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

# Check if a package is installed
is_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# Loop to paginate through results
while true; do
    show_batch

    if [ $? -ne 0 ]; then
        dialog --msgbox "Exiting without installing." 6 40
        break
    fi

    # Read the user's choice from the menu
    input=$(<menu_choice)

    if [[ "$input" =~ ^[0-9]+$ ]]; then
        # Validate that the selected number is within range
        if [ "$input" -ge 1 ] && [ "$input" -le "$total_results" ]; then
            selected_line=${output[$((input - 1))]}
            # Extract the package name (first word on the line)
            package_name=$(echo "$selected_line" | awk '{print $2}')
            
            # Check if the package is already installed
            if is_installed "$package_name"; then
                dialog --msgbox "Package '$package_name' is already installed." 6 50
            else
                # Ask for confirmation before installation
                dialog --yesno "Package '$package_name' is not installed. Do you want to install it?" 6 50
                if [ $? -eq 0 ]; then
                    dialog --infobox "Installing package: $package_name" 5 40
                    sudo apt-get install "$package_name"
                    dialog --msgbox "Package '$package_name' installed successfully." 6 50
                else
                    dialog --msgbox "Installation of package '$package_name' canceled." 6 50
                fi
            fi
            break
        else
            dialog --msgbox "Invalid selection. Please choose a number between 1 and $total_results." 6 50
        fi
    elif [[ "$input" == "n" ]]; then
        # Move to the next batch of results
        start=$((start + BATCH_SIZE))
        if [ "$start" -ge "$total_results" ]; then
            dialog --msgbox "No more results." 6 50
            start=$((total_results - BATCH_SIZE))
            if [ "$start" -lt 0 ]; then
                start=0
            fi
        fi
    elif [[ "$input" == "p" ]]; then
        # Move to the previous batch of results
        start=$((start - BATCH_SIZE))
        if [ "$start" -lt 0 ]; then
            dialog --msgbox "Already at the beginning." 6 50
            start=0
        fi
    elif [[ "$input" == "q" ]]; then
        dialog --msgbox "Exiting without installing." 6 40
        break
    else
        dialog --msgbox "Invalid input. Please enter a line number, 'n' for next batch, 'p' for previous batch, or 'q' to quit." 8 50
    fi
done

# Cleanup
rm -f menu_choice