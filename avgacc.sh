#!/bin/bash

output_file="bash_output.csv"

# Function to process a file or directory
process_entry() {
    local entry="$1"
    local parent_path="$2"

    if [ -e "$entry" ]; then
        if [ -f "$entry" ]; then
            # Process regular file
            access_time=$(stat -c "%x" "$entry")
            echo "$access_time,$parent_path" >> "$output_file"
        elif [ -d "$entry" ]; then
            # Process directory
            for subentry in "$entry"/*; do
                process_entry "$subentry" "$entry"
            done
        else
            echo "Not a regular file or directory: $entry"
        fi
    else
        echo "File not found: $entry"
    fi
}

# Initialize output file
echo "Access Time,Parent Path" > "$output_file"

# Start processing from the specified directory
start_directory="iCloudDrive/Documents/Classes"
process_entry "$start_directory" ""

# Calculate average access time for each directory
awk -F, '{sum[$2]+=$1; count[$2]+=1} END {for (dir in sum) print dir "," sum[dir]/count[dir]}' "$output_file" > "average_access_time.csv"

echo "Average access time calculated successfully."