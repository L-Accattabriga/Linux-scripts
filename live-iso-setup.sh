#!/bin/bash

echo -e "\nsudo passwd user\n"
sudo passwd user

echo -e "\nsudo passwd\n"
sudo passwd

echo -e "\nsudo apt update\n"
sudo apt update

echo -e "\nsudo apt install acpi lm-sensors vim byobu\n"
sudo apt install acpi lm-sensors vim byobu

#----------

echo -e "\nsudo sensors-detect\n"
sudo sensors-detect

echo -e "\nsudo sensors\n"
sudo sensors
