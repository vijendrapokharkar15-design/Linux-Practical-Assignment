#!/bin/bash
# Part 2 - cut, awk, sort and uniq tasks on employees.txt
# columns: ID,Name,Department,Salary,City

echo "8. Names and departments:"
cut -d',' -f2,3 employees.txt

echo
echo "9. Employees in DevOps:"
awk -F',' '$3 == "DevOps"' employees.txt

echo
echo "10. Salary greater than 40000:"
awk -F',' '$4 > 40000 {print $2, $4}' employees.txt

echo
echo "11. Employees in Bangalore:"
awk -F',' '$5 == "Bangalore" {print $2, $5}' employees.txt

echo
echo "12. Employees per department:"
cut -d',' -f3 employees.txt | sort | uniq -c

echo
echo "13. Highest salary:"
sort -t',' -k4 -n employees.txt | tail -n 1

echo
echo "14. Sorted by salary:"
sort -t',' -k4 -n employees.txt
