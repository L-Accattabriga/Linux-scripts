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

# Predefined commands (fallback)
default_commands=(
    "ls -l"
    "echo 'Hello World'"
    "uname -a"
    "pwd"
)

# If arguments are passed, use them; otherwise, use default commands
if [ "$#" -gt 0 ]; then
    commands=("$@")
else
    commands=("${default_commands[@]}")
fi

# Loop through commands and process them
for cmd in "${commands[@]}"; do
    confirm_and_execute "$cmd"
done