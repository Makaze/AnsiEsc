#!/bin/bash
input_file="de.log"
output_file="stream_into.log"
> "$output_file"  # Clear the output file

# Get the file size in bytes
file_size=$(wc -c < "$input_file")

# Loop over every character in the file
for (( i=1; i<=file_size; i++ )); do
  # Read one byte (character) at a time
  char=$(dd if="$input_file" bs=1 count=1 skip=$((i-1)) 2>/dev/null)
  # Append the character to the output file
  echo -n "$char" >> "$output_file"
done
