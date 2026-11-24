#!/bin/bash
# alert if application.log has more than 3 errors

log="application.log"

if [ ! -f "$log" ]; then
  echo "Log file not found"
  exit 1
fi

count=$(grep -c "ERROR" "$log")
echo "Error count: $count"

if [ $count -gt 3 ]; then
  echo "ALERT: more than 3 errors in application.log"
  exit 1
else
  echo "OK: error count is normal"
fi
