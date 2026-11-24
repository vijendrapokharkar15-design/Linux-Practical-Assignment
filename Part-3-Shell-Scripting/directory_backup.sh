#!/bin/bash

read -p "Enter the directory to back up: " dir

# making sure the directory exists
if [ ! -d "$dir" ]; then
    echo "Error: $dir is not a valid directory"
    exit 1
fi

backup_dir="/opt/company/backup"
timestamp=$(date +%Y%m%d_%H%M%S)
name=$(basename "$dir")
backup_file="$backup_dir/${name}_$timestamp.tar.gz"

tar -czf "$backup_file" "$dir" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Backup successful: $backup_file"
else
    echo "Backup failed"
    exit 1
fi

exit 0
