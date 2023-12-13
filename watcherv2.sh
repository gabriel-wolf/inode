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
  find "$directory" -type f -exec stat -c '%i %Y %n' {} + | while read -r line; do
    # Extract inode, modification time, and filename
    inode=$(echo "$line" | awk '{print $1}')
    modification_time=$(echo "$line" | awk '{print $2}')
    filename=$(echo "$line" | awk '{print $3}')

    # Check if the combination of inode and modification time is already in the logfile
    if ! grep -q "$inode $modification_time" "$logfile"; then
      # Log the information to the separate file
      echo "$inode $modification_time $filename $(date -d "@$modification_time" +"%Y-%m-%d %H:%M:%S")" >> "$logfile"
    fi
  done
  sleep 1
done
