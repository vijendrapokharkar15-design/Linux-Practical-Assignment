# Incident 3: High CPU and Memory

## Symptom
The application server was slow. Monitoring reported CPU at 95% and memory at 90%.

## Investigation
```bash
uptime                                       # load average (1, 5, 15 min)
free -h                                      # memory usage
top                                          # live view of CPU, memory and processes
ps aux --sort=-%cpu | head -n 6              # top 5 processes by CPU
ps aux --sort=-%mem | head -n 6              # top 5 processes by memory
ps -p 606 -o pid,user,%cpu,%mem,etime,cmd    # inspect one process by PID
```

Other ways to inspect a process by PID:
- `top -p <PID>` shows a live view of just that process.
- `cat /proc/<PID>/status` shows its state, memory (VmRSS) and threads.
- `ls -l /proc/<PID>/cwd` shows the directory it is running from.

## Findings
- Load average was 0.00, 0.00, 0.00 on a 2-CPU instance, so there was no CPU queue.
- `top` showed CPU 99.7% idle and 562.7 MiB of memory available out of 908.6 MiB.
- No process was using significant CPU. The top entries were kernel worker threads at 0.0%.
- The largest memory user was `snapd` (PID 606) at 4.6%, a normal system service, running for about 3 hours 54 minutes.
- In the lab the server was healthy. In the real incident, the same commands would show a load average above the CPU count, a very low idle value, low available memory, and the process responsible at the top of the `ps` lists.

## Action
Difference between `kill` and `kill -9`:
- `kill <PID>` sends SIGTERM (signal 15). It asks the process to stop, so it can save data, close files and connections, and exit cleanly. This should always be tried first.
- `kill -9 <PID>` sends SIGKILL (signal 9). The kernel stops the process immediately, with no chance to clean up. It should only be used when a process does not respond to a normal kill.

Force termination should be avoided:
- On databases, because it can corrupt data or leave transactions incomplete.
- On processes writing files, which can be left half-written.
- On applications holding locks or temp files, which may stop them restarting.
- On system processes such as `systemd` (PID 1) or `snapd`.
- Before the cause is understood, because the evidence is lost and the problem may come back.

Safer order in a real incident: identify the process, confirm with the application owner, try `sudo systemctl restart <service>`, then `kill <PID>`, and only use `kill -9 <PID>` if it is still stuck.

Demonstrated safely with test processes:
```bash
sleep 300 &
sleep 300 &
kill 3160        # result: Terminated
kill -9 3172     # result: Killed
ps aux | grep sleep
```

## Verification
After stopping the test processes, `ps aux | grep sleep` showed only the grep command itself, confirming both were gone. In a real incident I would re-run `uptime`, `free -h` and `top` to confirm that load, CPU and memory had returned to normal.
