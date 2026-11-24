# Incident 4: Permission Denied

## Symptom
A developer could not execute a deployment script and received `Permission denied`.

## Investigation
Reproduced the problem with a test script:
```bash
echo 'echo "Deploying application..."' > deploy.sh
./deploy.sh          # -bash: ./deploy.sh: Permission denied
ls -l deploy.sh      # -rw-rw-r-- 1 ubuntu ubuntu 32 Nov 24 14:26 deploy.sh
```

## Findings
- Permissions were `-rw-rw-r--`, owned by `ubuntu:ubuntu`.
- No execute (`x`) permission was set for anyone, which caused the error.

Explanation of `rwxr-xr-x` (755):

| Who | Permissions | Meaning |
|---|---|---|
| Owner | `rwx` | read, write and execute |
| Group | `r-x` | read and execute, cannot modify |
| Others | `r-x` | read and execute, cannot modify |

Using r = 4, w = 2, x = 1: owner 7, group 5, others 5, so 755.

## Action
```bash
chmod 750 deploy.sh
ls -l deploy.sh      # -rwxr-x--- 1 ubuntu ubuntu 32 Nov 24 14:26 deploy.sh
```
- Owner: read, write, execute. Group: read and execute. Others: no access.
- The file is not world-writable. `chmod 777` was avoided, because it would let any user modify the deployment script.

Difference between `chmod` and `chown`:
- `chmod` changes permissions: what the owner, group and others are allowed to do (read, write, execute).
- `chown` changes ownership: which user and group the file belongs to, e.g. `sudo chown ubuntu:devops deploy.sh`.
- Both may be needed. If the developer is not the owner and not in the file's group, `chmod` alone will not help, and the group or owner must be changed.

## Verification
```bash
ls -l deploy.sh      # -rwxr-x---
./deploy.sh          # Deploying application...
echo $?              # 0
```

If execution still failed, I would check:
1. The developer's user and groups: `id <developer>`.
2. Execute permission on every directory in the path: `ls -ld /opt/company /opt/company/scripts`.
3. The shebang and interpreter: `head -n 1 deploy.sh` and `ls -l /bin/bash`.
4. Windows line endings: `cat -A deploy.sh` (lines ending in `^M$`). Fix with `sed -i 's/\r$//' deploy.sh`.
5. Whether the filesystem is mounted with `noexec`: `mount | grep noexec`.
6. AppArmor or SELinux blocks in the system logs: `sudo journalctl -xe`.
