#!/bin/bash

###########################################################################################
# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/master/change-hostname.sh | bash -s %new-name%

if [ -z "$1" ]; then
    echo "[ Host name changing script ]"
    echo
    echo "Usage: $0 <new-hostname>"
    echo
    echo "script will execute command:"
    echo "  hostnamectl set-hostname new-hostname"
    echo "and do changes in /etc/hosts with sed -i.bak"
    echo
    echo "also script execute commands:"
    echo "  rm -f /etc/machine-id"
    echo "  dbus-uuidgen --ensure=/etc/machine-id"

else
    echo
    echo "### Try to set new hostname with command: hostnamectl set-hostname $1"
    hostnamectl set-hostname "$1"
    echo
    echo "### Checking result"
    echo "uname -n"
    uname -n
    echo
    printf "### try to update /etc/hosts with command: sed -i.bak -r s/^127.0.1.1.*/127.0.1.1\t%s.local\t%s/ /etc/hosts" "$1" "$1"
    sed -i.bak -r "s/^127.0.1.1.*/127.0.1.1\t$1.local\t$1/" /etc/hosts
    echo
    echo "### Checking result ###"
    echo "cat /etc/hosts"
    cat /etc/hosts
    echo
    echo
    echo "### Try to generate new machine-id"
    echo "# rm -f /etc/machine-id && dbus-uuidgen --ensure=/etc/machine-id"
    rm -f /etc/machine-id
    echo "# rm -f /etc/machine-id && dbus-uuidgen --ensure=/etc/machine-id"
    dbus-uuidgen --ensure=/etc/machine-id
    echo
    echo
    echo "[ Setup zabbix-agent2 ]"
    echo "# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/master/change-zabbix-agent2-settings.sh | bash -s $(uname -n) 10.10.20.242"
    echo
    echo
    echo "[ Reboot ]"
    echo "# shutdown -r now"
    echo
fi

# test changes
