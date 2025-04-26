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

# Function to prompt for reboot
prompt_reboot() {
    echo "[ Next step -> Reboot ]"
    echo "Please reboot your system for changes to take effect: shutdown -r now"
}

# Main script starts here

# Check if argument is provided
if [ -z "$1" ]; then
    echo "Error: No hostname provided!" >&2
    usage
    exit 1
fi

# Main script flow
set_hostname "$1"
update_hosts_file "$1"
generate_machine_id
prompt_reboot
