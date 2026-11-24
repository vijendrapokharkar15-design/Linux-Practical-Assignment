# Incident 1: Disk Space Critical

## Symptom
Monitoring reported 95% disk utilisation on the production server. Users could not upload files.

## Investigation
```bash
df -h                                                           # filesystem usage and mount points
sudo du -h --max-depth=1 / 2>/dev/null | sort -h | tail -n 10   # largest top-level directories
sudo find / -xdev -type f -size +500M 2>/dev/null               # files larger than 500 MB
sudo du -sh /var/log                                            # total size of logs
sudo find /var/log -mtime +7                                    # logs older than 7 days
journalctl --disk-usage                                         # systemd journal size
```

## Findings
- The affected mount point is `/` on `/dev/root` (6.7G). In the lab it was at 34%, not 95%.
- Largest directories: `/usr` (1.8G, system software, not safe to clean), `/var` (512M), `/snap` (461M).
- No files larger than 500 MB were found.
- `/var/log` uses 18M, of which 16M is the systemd journal. No log files older than 7 days were found.

## Action
Remediation was simulated because the lab disk was not full. On a real server I would:
- Archive old rotated logs (`*.1`, `*.gz`) with `tar -czf` or move them to S3 before removing them.
- Trim the systemd journal by age: `sudo journalctl --vacuum-time=7d`.
- Check that `logrotate` is configured for application logs.
- Never delete active log files that services are still writing to. If one is very large, truncate it with `sudo truncate -s 0 <file>` only after confirming it is not needed.

Before removing any data, I would confirm with the application owner:
- Log retention requirements (compliance, audit).
- Whether any logs are needed for an ongoing investigation.
- Whether logs are already shipped to a central system (e.g. CloudWatch).
- Which files are safe to remove.

## Verification
```bash
df -h /
```
Root filesystem usage after review: 34% (2.3G used, 4.4G available).
