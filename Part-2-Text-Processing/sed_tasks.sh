#!/bin/bash
# Part 2 - sed task: replace ERROR with CRITICAL in a new file

sed 's/ERROR/CRITICAL/g' server.log > output/server_critical.log

echo "7. New file output/server_critical.log:"
cat output/server_critical.log

echo
echo "Original server.log still has ERROR lines:"
grep -c "ERROR" server.log
