#!/bin/bash

###########################################################################################
# wget -qO - https://raw.githubusercontent.com/MrTakashi/bash-scripts/master/change-hostname.sh | bash -s %new-name%

if [ -z "$1" ]; then
    echo "[ Host name changing script ]"
    echo
    echo "Usage: $0 <new-hostname>"
    echo
    echo "script will execute <hostnamectl set-hostname new-hostname>>"
    echo "and do changes in /etc/hosts with sed -i.bak"
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
    echo "##### After all several common tasks"
    echo
    echo
    echo "[ Generate new machine-id ]"
    echo "# cat /etc/machine-id"
    echo "# rm -f /etc/machine-id && dbus-uuidgen --ensure=/etc/machine-id"
    echo
    echo
    echo "[ Setup zabbix-agent2 ]"
    echo "# wget -qO - https://raw.githubusercontent.com/MrTakashi/bash-scripts/master/change-zabbix-agent2-settings.sh | bash -s $(uname -n) 10.10.20.120"
    echo
    echo
    echo "[ Reboot ]"
    echo "# shutdown -r now"
    echo
fi

# test changes
