

#!/bin/bash

directory="/mnt/c/Users/gabee/iCloudDrive/"

# Ensure the specified directory exists
if [ -d "$directory" ]; then
    # Use find to locate all files in the directory and its subdirectories
    find "$directory" -type f -exec bash -c '
        for file; do
            inode=$(stat -c "%i" "$file")
            echo "File: $file, Inode: $inode"
        done
    ' _ {} +
else
    echo "Directory not found: $directory"
fi


