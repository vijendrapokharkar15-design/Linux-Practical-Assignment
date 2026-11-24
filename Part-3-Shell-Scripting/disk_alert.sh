#!/bin/bash

threshold=80

# Get current usage of / as a plain number
usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Root filesystem usage: ${usage}%"

if [ "$usage" -gt "$threshold" ]; then
    echo "WARNING: Disk usage is above ${threshold}%"
    exit 1
else
    echo "OK: Disk usage is within limits"
fi

exit 0
