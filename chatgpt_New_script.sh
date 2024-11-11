#!/bin/bash
#
# Author: [Your Name]
# Title: Package Search and Install Script
# Date: [Today's Date]
# Description: A script to search for Debian packages, display results in batches,
#              and allow the user to select a package to install.

set -e

PKG="$1"
BATCH_SIZE="${2:-20}"  # Allow user to set batch size via argument, default to 20

# Function to search for the package and store results in arrays
search_package() {
    local search_cmd="apt-cache search $PKG"
    local grep_cmd="grep --color=never -nP $PKG"

    # Avoid eval, use direct command substitution
    mapfile -t output < <($search_cmd | $grep_cmd)
    mapfile -t output_colored < <($search_cmd | grep --color=always -nP $PKG)
}

# Check if a package is installed
is_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# Function to display results in batches
show_batch() {
    local start="$1"
    local end=$((start + BATCH_SIZE))
    
    if [ "$end" -gt "$total_results" ]; then
        end=$total_results
    fi

    for ((i = start; i < end; i++)); do
        echo "${output_colored[$i]}"  # Show results with color
    done

    echo "Showing results $((start + 1)) to $end of $total_results."
}

# Function to handle pagination
paginate() {
    local start=0
    while true; do
        show_batch "$start"

        # Prompt the user for action
        read -p "Enter the line number to install, (n)ext, (p)revious, or (q)uit: " input

        if [[ "$input" =~ ^[0-9]+$ ]]; then
            # Validate and select package
            if [ "$input" -ge 1 ] && [ "$input" -le "$total_results" ]; then
                selected_line=${output[$((input - 1))]}
                package_name=$(echo "$selected_line" | awk '{print $2}')
                
                # Check if the package is already installed
                if is_installed "$package_name"; then
                    echo "Package '$package_name' is already installed."
                else
                    # Confirm installation
                    read -p "Install package '$package_name'? (y/n): " confirm
                    if [[ "$confirm" == "y" ]]; then
                        echo "Installing package: $package_name"
                        sudo apt-get install "$package_name"
                    else
                        echo "Installation canceled."
                    fi
                fi
                break
            else
                echo "Invalid selection. Please choose a number between 1 and $total_results."
            fi
        elif [[ "$input" == "n" ]]; then
            # Move to the next batch
            start=$((start + BATCH_SIZE))
            if [ "$start" -ge "$total_results" ]; then
                echo "No more results."
                start=$((total_results - BATCH_SIZE))
                [ "$start" -lt 0 ] && start=0
            fi
        elif [[ "$input" == "p" ]]; then
            # Move to the previous batch
            start=$((start - BATCH_SIZE))
            [ "$start" -lt 0 ] && echo "Already at the beginning." && start=0
        elif [[ "$input" == "q" ]]; then
            echo "Exiting without installing."
            break
        else
            echo "Invalid input. Please enter a valid line number, 'n' for next, 'p' for previous, or 'q' to quit."
        fi
    done
}

# Main logic
if [ -z "$PKG" ]; then
    echo "Usage: $0 <package-name> [batch-size]"
    exit 1
fi

search_package

# Total number of results
total_results=${#output[@]}

if [ "$total_results" -eq 0 ]; then
    echo "No results found for $PKG."
    exit 1
fi

echo "Total results: $total_results"

# Start pagination
paginate