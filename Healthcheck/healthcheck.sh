#!/usr/bin/env bash
# Portable healthcheck.sh

LOGFILE="./healthlog.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

{
echo "========================"
echo " System Health Check - $DATE"
echo "========================"

# Date & Time
echo -e "\n Date & Time:"
date

# Uptime
echo -e "\n⏱ Uptime:"
if command -v uptime >/dev/null 2>&1; then
  uptime -p
else
  awk '{printf "up %.0f minutes\n", $1/60}' /proc/uptime
fi

# CPU Load
echo -e "\n CPU Load:"
if command -v uptime >/dev/null 2>&1; then
  uptime | awk -F'load average:' '{print $2}'
else
  awk '{print $1", "$2", "$3}' /proc/loadavg
fi

# Memory Usage
echo -e "\n Memory Usage:"
if command -v free >/dev/null 2>&1; then
  free -m
else
  awk '/MemTotal/ {total=$2} /MemFree/ {free=$2} /Buffers/ {buffers=$2} /Cached/ {cached=$2} 
       END {printf "Total: %d MB, Free: %d MB, Used: %d MB\n", total/1024, free/1024, (total-free)/1024}' /proc/meminfo
fi

# Disk Usage
echo -e "\n Disk Usage:"
df -h

# Top 5 memory-consuming processes
echo -e "\n Top 5 Memory-Consuming Processes:"
if ps aux --help 2>&1 | grep -q sort; then
  ps aux --sort=-%mem | head -n 6
else
  ps aux | sort -rk 4 | head -n 6
fi

# Service checks
echo -e "\n Service Status:"
for svc in nginx ssh sshd; do
  if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active --quiet "$svc" && echo "$svc:  Running" || echo "$svc: ❌ Not Running"
  elif command -v service >/dev/null 2>&1; then
    service "$svc" status >/dev/null 2>&1 && echo "$svc:  Running" || echo "$svc: ❌ Not Running"
  else
    pgrep -x "$svc" >/dev/null 2>&1 && echo "$svc:  Running" || echo "$svc: ❌ Not Running"
  fi
done

echo -e "\n----------------------------------"
echo ""
} >> "$LOGFILE"