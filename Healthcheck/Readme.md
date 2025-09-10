Health Check Script

Project Overview:
This project contains a shell script (healthcheck.sh) that collects basic system health information such as CPU load, memory usage, disk usage, uptime, and service status. The results are logged into a file (healthlog.txt) with a timestamp.
---
Features

Shows current date and time
Displays system uptime
Reports CPU load
Shows memory usage (MB)
Displays disk usage (human readable)
Lists top 5 memory-consuming processes
Checks if specific services (nginx, ssh) are running
Logs all outputs into healthlog.txt with a timestamp
---

How to Use

1. Clone the repository

2. Navigate into the project folder

3. Make the script executable:

chmod +x healthcheck.sh

4. Run the script:

./healthcheck.sh

5. Check the results in healthlog.txt