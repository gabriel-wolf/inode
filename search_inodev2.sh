#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <inode>"
  exit 1
fi

logfile="modification_times.log"
inode="$1"

# Check if the logfile exists
if [ ! -e "$logfile" ]; then
  echo "Error: Logfile '$logfile' not found."
  exit 1
fi

# Search for the specified inode in the logfile
grep "^$inode " "$logfile" | awk '{print  $4, $5}' | uniq
