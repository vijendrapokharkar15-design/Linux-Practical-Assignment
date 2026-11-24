# Linux Practical Assignment

**Name:** Vijendra Pokharkar
**Batch:** NOV-2026 AI DevOps with AWS

## About
This repository contains my solutions for the Linux practical assignment. It covers basic Linux commands, text processing and log analysis, shell scripting, incident troubleshooting, and a server health monitoring script.

## Environment
- **OS:** Ubuntu 26.04.1 LTS
- **Platform:** AWS EC2 instance (t3.micro, eu-west-2 London)
- **Shell:** Bash
- **Access:** EC2 Instance Connect (browser terminal)

## Repository structure
| Folder | Contents |
|---|---|
| `Part-1-Basic-Linux/` | Commands used to build the `/opt/company` directory structure, and the saved directory listing |
| `Part-2-Text-Processing/` | grep, sed, awk and cut scripts for `server.log` and `employees.txt`, with outputs in `output/` |
| `Part-3-Shell-Scripting/` | Six shell scripts: even/odd, file check, disk alert, resource summary, directory backup, log summary |
| `Part-4-Incident-Scenarios/` | Investigation notes for four incidents (symptom, investigation, findings, action, verification), plus the alert script and reports |
| `Part-5-Health-Monitoring/` | `server_health.sh` and the generated `server_report.txt` |
| `Screenshots/` | Screenshots of commands and outputs for each part |

## How to run the scripts
Clone the repository and make the scripts executable:
```bash
git clone https://github.com/vijendrapokharkar15-design/Linux-Practical-Assignment.git
cd Linux-Practical-Assignment
chmod +x */*.sh
```

Examples:
```bash
cd Part-2-Text-Processing
./grep_tasks.sh
./sed_tasks.sh
./awk_cut_tasks.sh

cd ../Part-3-Shell-Scripting
./even_odd.sh                 # asks for a number
./file_check.sh               # asks for a file path
./disk_alert.sh
./resource_summary.sh
./directory_backup.sh         # asks for a directory path
./log_summary.sh              # asks for a log file path

cd ../Part-4-Incident-Scenarios
./app_error_alert.sh

cd ../Part-5-Health-Monitoring
./server_health.sh cron       # pass the process name to check
```

Note: `directory_backup.sh` and `server_health.sh` write to `/opt/company/...` paths, which were created in Part 1.

## Completed tasks
- [x] Part 1: Directory structure (all 8 steps)
- [x] Part 2: Text processing and log analysis (all 14 tasks)
- [x] Part 3: Shell scripting (all 6 scripts)
- [x] Part 4: Incident scenarios (all 4 incidents)
- [x] Part 5: Server health monitoring (steps 1 to 9)
- [x] Bonus: cron job, daily at 9:00 AM

Crontab entry:
```
0 9 * * * /opt/company/scripts/server_health.sh cron
```
Verified with `crontab -l`. The server runs on UTC, so the job runs at 9:00 UTC.

## Notes
- Part 1 used `/opt/company` (created with `sudo`, ownership changed with `chown`), so the `~/company` fallback was not needed.
- In Incident 1, remediation was simulated because the lab disk was only 34% full.
- In Incident 2, no database was available, so connectivity commands were demonstrated against google.com.
- All tasks were completed. No tasks were left incomplete.
