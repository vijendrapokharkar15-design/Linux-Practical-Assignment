# Incident 2: Application Login Failure

## Symptom
Users could not log in. The support team suspected a database connectivity problem.

## Investigation
```bash
grep "ERROR" application.log                                  # all ERROR lines (timestamp + message)
grep -c "ERROR" application.log                               # count of ERROR lines
grep "ERROR" application.log | head -n 1                      # first error
grep "ERROR" application.log | tail -n 1                      # last error
sed 's/ERROR/CRITICAL/g' application.log > application_critical.log   # separate report
```

## Findings
- 5 ERROR entries were found, all related to the database.
- First error: `10:03:20 ERROR Invalid database credentials`
- Last error: `10:10:40 ERROR Database connection refused`
- Other errors: connection refused (twice), connection timeout, connection pool exhausted.
- The errors span about 7 minutes and were followed by warnings (retry, slow response) and an application shutdown at 10:11:50.
- The first error points to an authentication problem. The later errors may be knock-on effects of it.
- The log only shows the application's side. It does not prove that the database server is down.

## Action
- Created `application_critical.log` with ERROR replaced by CRITICAL. The original `application.log` was not changed.
- Created `app_error_alert.sh`, which counts ERROR lines and prints an alert when the count is greater than 3. It reported 5 errors and raised the alert.

Next investigations to find the root cause:
1. Check whether the database credentials were changed, rotated or expired (application config or secrets manager).
2. Test connectivity from the app server to the database: `ping <db-host>` and `nc -zv <db-host> <port>`. Check security groups and firewall rules. (Demonstrated against google.com in the lab, as no database was available.)
3. Check the database server itself: whether the service is running, its own logs, and whether it has reached its maximum connections.
4. Review the application's connection pool settings (size, timeouts, connection release).
5. Check for deployments or configuration changes made around 10:03, when the first error appeared.

## Verification
```bash
grep -c "ERROR" application.log              # 5 (original unchanged)
grep -c "CRITICAL" application_critical.log  # 5 (all replaced in the report)
./app_error_alert.sh                         # ALERT raised, exit status 1
```
