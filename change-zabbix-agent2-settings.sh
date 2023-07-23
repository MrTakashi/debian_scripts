#!/bin/bash

###########################################################################################
# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/master/change-zabbix-agent2-settings.sh | bash -s `uname -n` 10.10.20.120
# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/master/change-zabbix-agent2-settings.sh | bash -s `uname -n` 10.10.20.242


if [ -z "$1" ]; then
    echo "[ Zabbix agent2 Hostname= and Server= settings changing script ]"
    echo
    echo "Usage: $0 %new_Hostname% %new_Server%"
    echo
    echo "script will execute:"
    echo "cp /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf.bak"
    echo "sed -i -r 's/^Hostname=.*/Hostname=%s/' /etc/zabbix/zabbix_agent2.conf" "$1"
    echo "sed -i -r 's/^Server=.*/Server=%s/' /etc/zabbix/zabbix_agent2.conf" "$2"
    echo "sed -i -r 's/^ServerActive=/#ServerActive=/' /etc/zabbix/zabbix_agent2.conf" "$2"
else
    echo
    echo "cp /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf.bak"
    cp /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf.bak
    echo "grep Hostname= /etc/zabbix/zabbix_agent2.conf"
    grep Hostname= /etc/zabbix/zabbix_agent2.conf
    echo "grep Server= /etc/zabbix/zabbix_agent2.conf"
    grep Server= /etc/zabbix/zabbix_agent2.conf
    echo "grep ServerActive= /etc/zabbix/zabbix_agent2.conf"
    grep ServerActive= /etc/zabbix/zabbix_agent2.conf
    echo
    printf "### try to update /etc/zabbix/zabbix_agent2.conf with command: sed -i -r s/^Hostname=.*/Hostname=%s/ /etc/zabbix/zabbix_agent2.conf" "$1"
    sed -i -r "s/^Hostname=.*/Hostname=$1/" /etc/zabbix/zabbix_agent2.conf
    echo
    printf "### try to update /etc/zabbix/zabbix_agent2.conf with command: sed -i -r s/^Server=.*/Server=%s/ /etc/zabbix/zabbix_agent2.conf" "$2"
    sed -i -r "s/^Server=.*/Server=$2/" /etc/zabbix/zabbix_agent2.conf
    echo
    printf "### try to update /etc/zabbix/zabbix_agent2.conf with command: sed -i -r s/^ServerActive=.*/#ServerActive/ /etc/zabbix/zabbix_agent2.conf"
    sed -i -r "s/^ServerActive=/#ServerActive=/" /etc/zabbix/zabbix_agent2.conf
    echo
    echo "### Checking result ###"
    echo
    echo "grep Hostname= /etc/zabbix/zabbix_agent2.conf"
    grep Hostname= /etc/zabbix/zabbix_agent2.conf
    echo "grep Server= /etc/zabbix/zabbix_agent2.conf"
    grep Server= /etc/zabbix/zabbix_agent2.conf
    echo "grep ServerActive= /etc/zabbix/zabbix_agent2.conf"
    grep ServerActive= /etc/zabbix/zabbix_agent2.conf
    echo
    echo "### After all ###"
    echo
    echo "# If all seems correct, run:"
    echo "# tail -f /var/log/zabbix/zabbix_agent2.log"
    echo "# zabbix_agent2 -p | head"
    echo "# systemctl enable --now zabbix-agent2"
    echo "# systemctl start zabbix-agent2"
    echo "# systemctl status zabbix-agent2"
    echo "# systemctl stop zabbix-agent2"
    echo "# systemctl restart zabbix-agent2"
    echo


fi

# test changes
