#!/bin/bash

read -p "Enter the file path: " file

# Check if the file exists
if [ -f "$file" ]; then
    echo "File '$file' exists."

    # Check read permission
    if [ -r "$file" ]; then
        echo "It is readable."
    else
        echo "It is NOT readable."
    fi

    # Check write permission
    if [ -w "$file" ]; then
        echo "It is writable."
    else
        echo "It is NOT writable."
    fi
else
    echo "File '$file' does not exist."
    exit 1
fi

exit 0
