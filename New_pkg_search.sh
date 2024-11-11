#!/bin/bash
#
# Author:
# Title:
# Date: 
# Desctiption:


set -e

PKG="$1"

command="apt-cache search $PKG | grep --color=always -nP $PKG"


mapfile -t output < <(eval $command)


for i in "${!output[@]}"; do
   echo -e "${output[$i]}"
done

read -p "which one: " NUM

AWK="awk NR==$NUM"

echo -e "$AWK"

apt-cache search $PKG | grep --color=always -P $PKG | $AWK




#!/bin/bash
#
# Author:
# Title:
# Date:
# Description:

set -e

PKG="$1"
BATCH_SIZE=20  # Number of results per page

# Search for the package and store the results in an array (no color for processing)
command_no_color="apt-cache search $PKG | grep --color=never -nP $PKG"
mapfile -t output < <(eval $command_no_color)

# Also store the output with color for displaying to the user
command_with_color="apt-cache search $PKG | grep --color=always -nP $PKG"
mapfile -t output_colored < <(eval $command_with_color)

# Total number of results
total_results=${#output[@]}

if [ "$total_results" -eq 0 ]; then
    echo "No results found for $PKG."
    exit 1
fi

echo "Total results: $total_results"
start=0

# Function to display results in batches
show_batch() {
    end=$((start + BATCH_SIZE))
    if [ "$end" -gt "$total_results" ]; then
        end=$total_results
    fi

    for ((i = start; i < end; i++)); do
        echo "${output_colored[$i]}"  # Show results with color
    done

    echo "Showing results $((start + 1)) to $end of $total_results."
}

# Check if a package is installed
is_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# Loop to paginate through results
while true; do
    show_batch

    # Prompt the user for action
    read -p "Enter the line number to install, (n)ext for more, (p)revious for earlier, or (q)uit: " input

    if [[ "$input" =~ ^[0-9]+$ ]]; then
        # Validate that the selected number is within range
        if [ "$input" -ge 1 ] && [ "$input" -le "$total_results" ]; then
            selected_line=${output[$((input - 1))]}
            # Extract the package name (first word on the line)
            package_name=$(echo "$selected_line" | awk '{print $2}')
            
            # Check if the package is already installed
            if is_installed "$package_name"; then
                echo "Package '$package_name' is already installed."
            else
                # Ask for confirmation before installation
                read -p "Package '$package_name' is not installed. Do you want to install it? (y/n): " confirm
                if [[ "$confirm" == "y" ]]; then
                    echo "Installing package: $package_name"
                    sudo apt-get install "$package_name"
                else
                    echo "Installation of package '$package_name' canceled."
                fi
            fi
            break
        else
            echo "Invalid selection. Please choose a number between 1 and $total_results."
        fi
    elif [[ "$input" == "n" ]]; then
        # Move to the next batch of results
        start=$((start + BATCH_SIZE))
        if [ "$start" -ge "$total_results" ]; then
            echo "No more results."
            start=$((total_results - BATCH_SIZE))
            if [ "$start" -lt 0 ]; then
                start=0
            fi
        fi
    elif [[ "$input" == "p" ]]; then
        # Move to the previous batch of results
        start=$((start - BATCH_SIZE))
        if [ "$start" -lt 0 ]; then
            echo "Already at the beginning."
            start=0
        fi
    elif [[ "$input" == "q" ]]; then
        echo "Exiting without installing."
        break
    else
        echo "Invalid input. Please enter a line number, 'n' for next batch, 'p' for previous batch, or 'q' to quit."
    fi
done


