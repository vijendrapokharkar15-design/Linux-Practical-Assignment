#!/bin/bash

read -p "Enter log file path: " log

if [ ! -f "$log" ]; then
  echo "File not found"
  exit 1
fi

errors=$(grep -c "ERROR" "$log")
warnings=$(grep -c "WARNING" "$log")
info=$(grep -c "INFO" "$log")

echo "ERROR: $errors"
echo "WARNING: $warnings"
echo "INFO: $info"

if [ $errors -gt 3 ]; then
  echo "ALERT: too many errors"
fi
