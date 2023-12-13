#!/bin/bash

output_file="pictures.csv"

# Function to process a file or directory
process_entry() {
    local entry="$1"
    local parent_path="$2"

    if [ -e "$entry" ]; then
        if [ -f "$entry" ]; then
            # Process regular file
            filename=$(basename "$entry")
            inode=$(stat -c "%i" "$entry")
            filetype=$(stat -c "%F" "$entry")
            birth_time=$(stat -c "%w" "$entry")
            access_time=$(stat -c "%x" "$entry")
            modify_time=$(stat -c "%y" "$entry")
            change_time=$(stat -c "%z" "$entry")

            echo "$filename,$inode,$filetype,$parent_path,$birth_time,$access_time,$modify_time,$change_time" >> "$output_file"
        elif [ -d "$entry" ]; then
            # Process directory
            echo "Processing directory: $entry"
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
echo "Filename,Inode,File Type,Parent Path,Birth Time,Access Time,Modify Time,Change Time" > "$output_file"

# Start processing from the specified directory
start_directory="iCloudDrive/Pictures"
process_entry "$start_directory" ""
