#!/bin/bash

# /etc/profile.d/welcome_prompt.sh
# https://raw.githubusercontent.com/MrTakashi/debian_scripts/refs/heads/main/welcome_prompt.sh

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
NC='\033[0m' # No Color


# IP первого сетевого интерфейса
LOCAL_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+\.\d+\.\d+\.\d+' | grep -v '^127\.' | head -n 1)

# Hostname
HOSTNAME=$(hostname)

# OS
OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

# User
USER_NAME=$(whoami)

# Root with redcolor
if [ "$USER_NAME" = "root" ]; then
        USER_NAME="${RED}${USER_NAME}${NC}"
fi

# Load average
LOADAVG=$(awk '{print $1" "$2" "$3}' /proc/loadavg)

# Uptime
UPTIME=$(uptime -p)

# CPU count
CPU_COUNT=$(nproc)

# RAM: total, free, free_percent
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_FREE=$(free -m | awk '/Mem:/ {print $7}')
RAM_FREE_PCT=$(( RAM_FREE * 100 / RAM_TOTAL ))

# HDD: /
DISK_TOTAL_HUMAN=$(df -h / | awk 'NR==2 {print $2}')
DISK_FREE_HUMAN=$(df -h / | awk 'NR==2 {print $4}')

echo ""
echo -e "----- ${YELLOW}System Status${NC} ---------------------------------------------"
echo "IP                    ${LOCAL_IP:-N/A}"
echo -e "USER@Hostname         $USER_NAME@$HOSTNAME"
echo "OS Name               $OS"
echo "Kernel                $(uname -r) | Processes: $(ps aux | wc -l)"
echo "Uptime                $UPTIME"
echo "---------------------------------------------------------------"
echo "CPU                   ${CPU_COUNT} CPU"
echo "Load Average          $LOADAVG"
echo "RAM                   Total: ${RAM_TOTAL} MB, free: ${RAM_FREE} MB (${RAM_FREE_PCT}%)"
echo "HDD (/)               Total: ${DISK_TOTAL_HUMAN}, free: ${DISK_FREE_HUMAN} (${DISK_FREE_PCT}%)"
echo "Network"
ip -4 addr show | grep -oP '(?<=inet\s)\d+\.\d+\.\d+\.\d+' | grep -v '^127\.' | xargs -I {} echo "  {}"
if command -v docker >/dev/null; then
echo "---------------------------------------------------------------"
  RUNNING=$(docker ps -q | wc -l)
  TOTAL=$(docker container ls -aq | wc -l)
  echo "Docker: $RUNNING running / $TOTAL total containers"
fi
echo "---------------------------------------------------------------"
echo "Disks:"
df -h --output=source,fstype,size,avail,pcent,target | awk 'NR>1 {print "  " $1 " (" $2 "): " $4 " free (" $5 " used) on " $6}'
echo "---------------------------------------------------------------"
