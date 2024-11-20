# Basic Syntax:
sed 's/pattern/replacement/' file

# Print lines after modification:
sed 's/old/new/' file  # Replace first occurrence of 'old' with 'new'.

# Replace globally:
sed 's/old/new/g' file  # Replace all occurrences of 'old' with 'new'.

# Replace with case-insensitivity:
sed 's/old/new/I' file  # Case-insensitive replace.

# Delete lines matching pattern:
sed '/pattern/d' file  # Remove lines containing 'pattern'.

# Delete a specific line:
sed '3d' file  # Delete 3rd line.

# Replace specific line:
sed '3s/old/new/' file  # Replace 'old' with 'new' in 3rd line only.

# Print specific lines:
sed -n '3p' file  # Print 3rd line only.
sed -n '3,5p' file  # Print lines 3 to 5.

# Insert a line:
sed '3i\New line here' file  # Insert text before 3rd line.

# Append a line:
sed '3a\New line here' file  # Append text after 3rd line.

# Replace with newline:
sed ':a;N;$!ba;s/pattern/\n/g' file  # Replace 'pattern' with a newline.

# Replace multiple patterns:
sed -e 's/old/new/' -e 's/foo/bar/' file  # Chain multiple replacements.

# Replace using regex groups:
echo "abc123" | sed 's/[a-z]*[0-9]*/\2-\1/'  # Outputs "123-abc".

# Replace delimiter:
sed 's|old|new|g' file  # Use '|' as a delimiter instead of '/'.

# Delete blank lines:
sed '/^$/d' file  # Remove lines with no content.

# Add line numbers:
sed = file | sed 'N;s/\n/\t/'  # Add line numbers with tab spacing.

# Print lines matching a pattern:
sed -n '/pattern/p' file  # Only print lines containing 'pattern'.

# Substitute from a file:
sed -f script.sed file  # Use a script file for commands.

# Find and replace on matched lines only:
sed '/pattern/s/old/new/' file  # Replace only on lines matching 'pattern'.

# Replace with line number:
sed '2s/.*/Line 2 is changed/' file  # Replace 2nd line with static text.

# Copy matching lines to a new file:
sed -n '/pattern/w newfile' file  # Write matched lines to 'newfile'.

# In-place editing (modify file directly):
sed -i 's/old/new/g' file  # Replace in the file without creating a copy.

# Remove trailing whitespaces:
sed 's/[[:space:]]*$//' file  # Remove spaces/tabs at end of lines.

# Use escape characters:
sed 's/\/home\/user/\/opt\/user/g' file  # Replace paths with '/'.

# Append text to every line:
sed 's/$/ appended_text/' file  # Add text at the end of each line.

# Modify specific column:
sed -E 's/([^ ]+) ([^ ]+)/\1 MODIFIED/' file  # Modify 2nd column in a file.