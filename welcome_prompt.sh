#!/bin/bash

# /etc/profile.d/welcome_prompt.sh


# Colors
RED='\033[0;31m'
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

#
DISK_TOTAL=$(df -k / | awk 'NR==2 {print $2}')
DISK_FREE=$(df -k / | awk 'NR==2 {print $4}')
DISK_FREE_PCT=$(( DISK_FREE * 100 / DISK_TOTAL ))

echo ""
echo "-------------------------------------------------------"
echo "IP                   : ${LOCAL_IP:-N/A}"
echo -e "USER@Hostname     : $USER_NAME@$HOSTNAME"
echo "OS Name              : $OS"
#echo -e "USER                  : $USER_NAME"
echo "Uptime               : $UPTIME"
echo "Load Average         : $LOADAVG"
echo "Uptime               : $UPTIME"
echo "-------------------------------------------------------"
echo "CPU                  : ${CPU_COUNT} CPU"
echo "RAM                  : ${RAM_TOTAL} MB, ${RAM_FREE} MB (${RAM_FREE_PCT}%) free"
echo "HDD (/)              : ${DISK_TOTAL_HUMAN}, ${DISK_FREE_HUMAN} (${DISK_FREE_PCT}%) free"
echo "-------------------------------------------------------"
