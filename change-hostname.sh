#!/bin/bash

###########################################################################################
# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/master/change-hostname.sh | bash -s %new-name%

# Function to display script usage
usage() {
    cat <<EOF
[ Hostname Changing Script ]

Usage: $0 <new-hostname>

This script changes the hostname and updates /etc/hosts accordingly.
It also generates a new machine-id and optionally configures zabbix-agent2.

Options:
  <new-hostname>   The new hostname to set.

Example:
  $0 my-new-hostname
EOF
}

# Function to set hostname
set_hostname() {
    echo "[ 1/3 Setting new hostname: $1 ]"
    hostnamectl set-hostname "$1" && echo "[OK]"
    echo
}

# Function to update /etc/hosts
update_hosts_file() {
    echo "Updating /etc/hosts"
    sed -i.bak -r "s/^127.0.1.1.*/127.0.1.1\t$1.local\t$1/" /etc/hosts && echo "[OK]"
    echo
}

# Function to generate new machine-id
generate_machine_id() {
    echo "[ 2/3 Generating new machine-id ]"
    rm -f /etc/machine-id && echo "[OK]"
    dbus-uuidgen --ensure=/etc/machine-id && echo "[OK]"
    echo
}

# Function to configure zabbix-agent2
configure_zabbix_agent2() {
    echo "[ 3/3 Configuring zabbix-agent2 ]"
    wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/master/change-zabbix-agent2-settings.sh | bash -s $(uname -n) 10.10.20.242
    echo "[OK]"
    echo
}

# Function to prompt for reboot
prompt_reboot() {
    echo "[ Next step -> Reboot ]"
    echo "Please reboot your system for changes to take effect: shutdown -r now"
}

# Main script starts here

# Check if argument is provided
if [ -z "$1" ]; then
    usage
    exit 1
fi

# Main script flow
set_hostname "$1"
update_hosts_file "$1"
generate_machine_id

# Prompt user whether to configure zabbix-agent2
read -p "Do you want to configure zabbix-agent2? (Y/N, default=N): " configure_zabbix
configure_zabbix=${configure_zabbix:-N}  # Default value is N if user presses Enter

if [ "$configure_zabbix" = "Y" ] || [ "$configure_zabbix" = "y" ]; then
    configure_zabbix_agent2
fi

prompt_reboot
