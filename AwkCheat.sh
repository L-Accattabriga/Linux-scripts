#!/bin/bash

# Basic Syntax:
awk 'pattern {action}' file

# Print entire file:
awk '{print}' file  # Default action is print each line.

# Print specific columns:
awk '{print $1, $3}' file  # Print 1st and 3rd columns.

# Filter lines with pattern:
awk '/pattern/' file  # Print lines matching 'pattern'.

# Using conditions:
awk '$3 > 50 {print $1, $3}' file  # Print 1st & 3rd columns where 3rd > 50.

# Calculate sum of a column:
awk '{sum += $2} END {print sum}' file  # Sum all values in 2nd column.

# Count number of lines:
awk 'END {print NR}' file  # NR = Number of Records (lines).

# Add line numbers:
awk '{print NR, $0}' file  # $0 = whole line.

# Print lines in reverse order:
awk '{lines[NR] = $0} END {for (i = NR; i > 0; i--) print lines[i]}' file

# Replace a field (column):
awk '{$2 = "REPLACED"; print}' file  # Replace 2nd column with "REPLACED".

# Print lines with length > 80:
awk 'length($0) > 80' file  # Check line length with length().

# Split a string:
echo "a:b:c" | awk -F: '{print $1, $2, $3}'  # Split on ':' delimiter.

# Find maximum in a column:
awk 'NR == 1 || $2 > max {max = $2} END {print max}' file  # Max of 2nd column.

# Print odd-numbered lines:
awk 'NR % 2 == 1' file  # NR is odd.

# Change field separator (FS):
awk -F',' '{print $1, $2}' file.csv  # Use ',' as field separator.

# Specify output field separator (OFS):
awk -F',' -v OFS="\t" '{print $1, $2}' file.csv  # Output tab-separated.

# Use BEGIN and END blocks:
awk 'BEGIN {print "Start"} {print} END {print "End"}' file  # Extra actions.

# Match multiple patterns:
awk '/pattern1/ || /pattern2/' file  # Logical OR for patterns.

# Match exact value in a field:
awk '$1 == "exact_value"' file  # Match exact value in 1st column.

# Ignore case:
awk 'BEGIN {IGNORECASE = 1} /pattern/' file  # Case-insensitive match.

# Custom variable:
awk -v threshold=10 '$2 > threshold {print}' file  # Use a custom variable.

# Print lines where a field contains a specific substring:
awk '$2 ~ /substring/' file  # Match substring in the 2nd column.

# Find and replace within a specific field:
awk '{gsub(/old/, "new", $2); print}' file  # Replace 'old' with 'new' in 2nd field.

# Display the first N lines of a file:
awk 'NR <= 10 {print}' file  # Print the first 10 lines of the file.

# Use a regular expression in a field:
awk '$1 ~ /^[A-Za-z]+$/' file  # Match only alphabetic words in the 1st column.

# Perform arithmetic operations:
awk '{print $1 * $2}' file  # Multiply values in the 1st and 2nd columns.

# Calculate average of a column:
awk '{sum += $1} END {print sum / NR}' file  # Average of the 1st column.

# Print lines based on a condition with AND logic:
awk '$1 > 10 && $2 < 5 {print $1, $2}' file  # Match lines where 1st > 10 and 2nd < 5.

# Print last N lines of a file:
awk 'NR > (NR - 5) {print}' file  # Print the last 5 lines.

# Print lines between two patterns:
awk '/start_pattern/,/end_pattern/' file  # Print lines between patterns.

# Print every other line:
awk 'NR % 2 == 0 {print}' file  # Print every even-numbered line.

# Use OFS to modify output field separator:
awk -v OFS="|" '{print $1, $2}' file  # Print columns separated by '|'.

# Print specific columns with custom separator:
awk '{print $1, $2}' OFS=":" file  # Print columns with ":" separator.

# Print the longest word in a line:
awk '{for (i=1; i<=NF; i++) if (length($i) > max) {max = length($i); word = $i}} END {print word}' file  # Longest word in each line.

# Filter lines based on column values and print specific fields:
awk '$3 > 50 {print $1, $2}' file  # Filter 3rd column > 50 and print 1st & 2nd.

# Use multiple field separators:
awk -F"[ ,]" '{print $1, $2}' file  # Use both space and comma as separators.

# Replace a character with another in the whole file:
awk '{gsub(/x/, "y"); print}' file  # Replace all occurrences of 'x' with 'y'.