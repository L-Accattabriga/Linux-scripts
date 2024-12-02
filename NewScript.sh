#!/bin/bash


set -eo pipefail
#set -x

# Script Variables
sName="$1"
#sName="$sName.sh"
sDirs="$HOME/bin"
sPath="$sDirs/$sName"


# if statement to error check arg
if [ "$#" -ne 1 ]; then
    echo -e "ATTTENTION NO SCRIPT NAME PROVIDED!"
    exit 1
fi

# if statement to check the directory exists
if [[ ! -d "$sDirs" ]]; then
    echo -e "*** ERROR $sDirs DOES NOT EXIST ***"
    ls -l $HOME
    read -p "Create $HOME/bin? " ans
    
        if [[ -z "$ans" ]]; then
            mkdir $HOME/bin
        fi
      
fi


# if statement to check if the filename is already in use in correct directory
if [[ ! -e "$sPath" ]]; then
    echo -e "Creating $sPath"
else
    echo -e "*** THIS FILE NAME IS TAKEN *** "
    echo -e "\n$ ls -1 $sDirs"
    ls -1 $sDirs
    echo -e "\n*** Enter a new file name ***"
    exit 1
fi

read -p "Enter a brief description of the script: " description

# Generate the script content
{
    echo -e "#!/bin/bash"
    echo -e "# Author: $(whoami)"
    echo -e "# Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "# Description: $description"
    echo
    echo -e "# set -e"
    echo -e "# set -x"
    echo -e "# set -o pipefail"
    echo -e "# set -u"
    echo
    echo -e "# Variables"
    echo
    echo
    echo
    echo
    echo -e "# Script start "
    echo
    echo
    echo
    echo -e "#########"
} > $sPath

# Make script executable
chmod +x "$sPath"
echo -e "$sName created successfully"

# Offer to open file to edit
read -p "Open script to start coding? " choice

if [[ -z "$choice" ]]; then
    "${EDITOR:-vim}" "$sPath"
fi
