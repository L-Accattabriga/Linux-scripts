#!/bin/bash

# Function to confirm and execute commands
confirm_and_execute() {
    local cmd="$1"  # The command to execute
    while true; do
        read -p "Execute command: '$cmd'? (y=Yes, s=Skip, q=Quit): " ans
        case "$ans" in
            [Yy]* ) eval "$cmd"; return 0;;   # Execute the command
            [Ss]* ) echo "Skipped."; return 1;; # Skip this command
            [Qq]* ) echo "Quitting..."; exit 0;; # Exit the script
            * ) echo "Please answer y (yes), s (skip), or q (quit).";;
        esac
    done
}

# Check if any arguments are passed
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <command1> <command2> ... <commandN>"
    exit 1
fi

# Loop through arguments and process them as commands
for cmd in "$@"; do
    confirm_and_execute "$cmd"
done