#!/bin/bash

echo "=================================================="
echo "          SERVER DIAGNOSTIC REPORT"
echo "=================================================="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "User: $(whoami)"
echo "Kernel: $(uname -a)"

echo -e "\n[1] MEMORY USAGE"
free -h

echo -e "\n[2] DISK USAGE"
df -h /

echo -e "\n[3] CPU INFO"
nproc --all
echo "Load Average: $(uptime)"

echo -e "\n[4] DOCKER INFO"
if command -v docker &> /dev/null; then
    docker info | grep -E "Server Version|Total Memory|CPUs|Architecture"
    echo "Running Containers:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo "ERROR: Docker is not installed or not in PATH"
fi

echo -e "\n[5] NETWORK CONNECTIVITY (NPM Mirror)"
echo "Testing connectivity to registry.npmmirror.com..."
if curl -s -I --connect-timeout 5 https://registry.npmmirror.com/ > /dev/null; then
    echo "SUCCESS: Can reach npmmirror"
else
    echo "WARNING: Cannot reach npmmirror (or timeout)"
fi

echo -e "\n[6] RECENT SYSTEM ERRORS (OOM Check)"
# Try to read dmesg, might require sudo but user is likely root
if dmesg &> /dev/null; then
    dmesg | grep -i -E "oom|kill|out of memory" | tail -n 10
else
    echo "Cannot read dmesg (permission denied or not available)"
fi

echo -e "\n[7] PORT 3002 STATUS"
if command -v netstat &> /dev/null; then
    netstat -tulpn | grep 3002
else
    echo "netstat not found, skipping port check"
fi

echo "=================================================="
