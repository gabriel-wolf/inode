#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

directory="$1"
logfile="modification_times.log"

# Check if the directory exists
if [ ! -d "$directory" ]; then
  echo "Error: Directory '$directory' not found."
  exit 1
fi

# Check if the logfile exists, create it if not
if [ ! -e "$logfile" ]; then
  touch "$logfile"
fi

# Log modification times in the background
while true; do
  find "$directory" -type f -exec stat -c '%i %n %y' {} + | while read -r line; do
    # Extract inode, filename, and modification time
    inode=$(echo "$line" | awk '{print $1}')
    filename=$(echo "$line" | awk '{print $2}')
    modification_time=$(echo "$line" | awk '{print $3, $4}')

    # Log the information to the separate file
    echo "$inode $filename $(date -d "$modification_time" +"%Y-%m-%d %H:%M:%S")" >> "$logfile"
  done
  sleep 1
done
