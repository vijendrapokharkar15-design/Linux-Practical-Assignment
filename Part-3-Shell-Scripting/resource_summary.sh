#!/bin/bash

echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"

echo
echo "Memory usage:"
free -h

echo
echo "Top 5 processes using CPU:"
ps aux --sort=-%cpu | head -6

exit 0
