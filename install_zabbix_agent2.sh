#!/bin/bash

##############################################################################################################
# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/install_zabbix_agent2.sh | bash

# Default Zabbix Server IP
default_zabbix_server_ip="10.10.20.120"
default_agent_hostname=$(uname -n)

# Function to check if the script is running with root privileges
check_root_privileges() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Function to install Zabbix Agent 2
install_zabbix_agent() {
    # Add Zabbix repository
    wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-5+debian12_all.deb
    dpkg -i zabbix-release_6.0-5+debian12_all.deb
    apt update

    # Install Zabbix Agent 2
    apt install zabbix-agent2 -y
}

# Function to configure Zabbix Agent 2
configure_zabbix_agent() {
    # Prompt for Zabbix Server IP
    echo
    read -p "Enter Zabbix Server IP [$default_zabbix_server_ip]: " zabbix_server_ip
    zabbix_server_ip="${zabbix_server_ip:-$default_zabbix_server_ip}"

    # Set hostname
    read -p "Enter hostname for this agent [$default_agent_hostname]: " agent_hostname
    agent_hostname="${agent_hostname:-$default_agent_hostname}"
    # Configure Zabbix Agent 2
    sed -i "s/^Server=127.0.0.1/Server=$zabbix_server_ip/" /etc/zabbix/zabbix_agent2.conf
    sed -i "s/^ServerActive=127.0.0.1/ServerActive=$zabbix_server_ip/" /etc/zabbix/zabbix_agent2.conf
    sed -i "s/^Hostname=.*/Hostname=$agent_hostname/" /etc/zabbix/zabbix_agent2.conf
}

# Function to start Zabbix Agent 2
start_zabbix_agent() {
    systemctl start zabbix-agent2
    systemctl enable zabbix-agent2
    systemctl status zabbix-agent2
}

# Main function
main() {
    check_root_privileges
    install_zabbix_agent
    configure_zabbix_agent
    start_zabbix_agent
    echo "Zabbix Agent 2 installed and configured successfully."
    echo
    echo "grep Hostname= /etc/zabbix/zabbix_agent2.conf"
    grep Hostname= /etc/zabbix/zabbix_agent2.conf
    echo "grep Server= /etc/zabbix/zabbix_agent2.conf"
    grep Server= /etc/zabbix/zabbix_agent2.conf
    echo "grep ServerActive= /etc/zabbix/zabbix_agent2.conf"
    grep ServerActive= /etc/zabbix/zabbix_agent2.conf
    echo
    echo "### May be you need these commands ###"
    echo
    echo "# vim /etc/zabbix/zabbix_agent2.conf"
    echo "# tail -f /var/log/zabbix/zabbix_agent2.log"
    echo "# zabbix_agent2 -p | head"
    echo "# systemctl stop zabbix-agent2"
    echo "# systemctl status zabbix-agent2"
    echo "# systemctl start zabbix-agent2"
    echo
}

# Execute main function
main