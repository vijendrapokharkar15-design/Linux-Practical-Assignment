#!/bin/bash
# Ask the user for a number
read -p "Enter a number: " num
if (( num % 2 == 0 )); then
    echo "$num is EVEN"
else
    echo "$num is ODD"
fi
exit 0
