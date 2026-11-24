#!/bin/bash
# Part 2 - grep, head and tail tasks on server.log

echo "1. ERROR lines:"
grep "ERROR" server.log

echo
echo "2. ERROR count:"
grep -c "ERROR" server.log

echo
echo "3. WARNING lines:"
grep "WARNING" server.log

echo
echo "4. Lines containing Database:"
grep "Database" server.log

echo
echo "5. First 5 lines:"
head -n 5 server.log
echo "Last 3 lines:"
tail -n 3 server.log

echo
echo "6. Case-insensitive search for error:"
grep -i "error" server.log
