#!/bin/bash
# server health report

app=$1
report=/opt/company/server_report.txt
disk=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Server Health Report - $(date)" > $report
echo "Hostname: $(hostname)" >> $report
echo "Disk usage: $disk%" >> $report
echo "Available memory: $(free -h | awk 'NR==2 {print $7}')" >> $report
echo "Uptime: $(uptime -p)" >> $report
echo "Top 5 CPU processes:" >> $report
ps aux --sort=-%cpu | head -6 >> $report

if [ $disk -gt 80 ]; then
  echo "WARNING: disk usage above 80%" >> $report
fi

if pgrep -x "$app" > /dev/null; then
  echo "$app is running" >> $report
else
  echo "ALERT: $app is not running" >> $report
fi

cat $report
