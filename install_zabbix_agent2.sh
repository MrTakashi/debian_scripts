#!/bin/bash

##############################################################################################################
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/install_zabbix_agent2.sh)"
# bash -c "$(wget -O- https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/install_zabbix_agent2.sh)"
# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/install_zabbix_agent2.sh | bash

# Default Zabbix Server IP
default_zabbix_server_address="10.10.20.120, prutik.ddns.net"
default_agent_hostname=$(uname -n)

# Function to check if the script is running with root privileges
check_root_privileges() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Function to choose Zabbix Agent 2 version to install
display_menu() {
    echo "Select Zabbix version to install:"
    options=("6.0" "6.4" "Quit")
    select opt in "${options[@]}"; do
        case "$opt" in
            "6.0")
                install_zabbix_agent "6.0"
                break
                ;;
            "6.4")
                install_zabbix_agent "6.4"
                break
                ;;
            "Quit")
                echo "Exiting..."
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}

# Function to install Zabbix Agent 2
install_zabbix_agent() {
    local version="$1"
    local package_url

    case "$version" in
        "6.0")
            package_url="https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-5+debian12_all.deb"
            ;;
        "6.4")
            package_url="https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian12_all.deb"
            ;;
        *)
            echo "Unsupported version: $version"
            return 1
            ;;
    esac

    # Add Zabbix repository
    wget "$package_url"
    dpkg -i "$(basename "$package_url")"
    apt update

    # Install Zabbix Agent 2
    apt install zabbix-agent2 -y
}

# Function to configure Zabbix Agent 2
configure_zabbix_agent() {
    # Prompt for Zabbix Server IP
    echo
    read -p "Enter Zabbix Server IP [$default_zabbix_server_address]: " zabbix_server_address
    zabbix_server_address="${zabbix_server_address:-$default_zabbix_server_address}"

    # Set hostname
    read -p "Enter hostname for this agent [$default_agent_hostname]: " agent_hostname
    agent_hostname="${agent_hostname:-$default_agent_hostname}"
    # Configure Zabbix Agent 2
    sed -i "s/^Server=127.0.0.1/Server=$zabbix_server_address/" /etc/zabbix/zabbix_agent2.conf
#    sed -i "s/^ServerActive=127.0.0.1/ServerActive=$zabbix_server_address/" /etc/zabbix/zabbix_agent2.conf
    sed -i "s/^Hostname=.*/Hostname=$agent_hostname/" /etc/zabbix/zabbix_agent2.conf
}

# Function to stop Zabbix Agent 2
stop_zabbix_agent() {
#    systemctl start zabbix-agent2
#    systemctl enable zabbix-agent2
    systemctl stop zabbix-agent2
#    systemctl status zabbix-agent2
}

start_zabbix_agent() {
    systemctl start zabbix-agent2
#    systemctl enable zabbix-agent2
#    systemctl stop zabbix-agent2
#    systemctl status zabbix-agent2
}

# Main function
main() {
    check_root_privileges

    # Ask for confirmation before installing Zabbix Agent
    read -p "Do you want to install Zabbix Agent? [Y/n]: " install_zabbix
    install_zabbix="${install_zabbix:-Y}" # Default to yes if no option provided

    if [[ $install_zabbix =~ ^[Yy]$ ]]; then
        display_menu
    else
        echo "Zabbix Agent installation skipped."
    fi

    stop_zabbix_agent
    configure_zabbix_agent
    start_zabbix_agent

    tail -f /var/log/zabbix/zabbix_agent2.log

    echo "Zabbix Agent 2 installed and configured successfully."
    echo
    echo "grep -E '^Hostname|^Server|^ServerActive' /etc/zabbix/zabbix_agent2.conf"
    grep -E '^Hostname|^Server|^ServerActive' /etc/zabbix/zabbix_agent2.conf
    echo
    echo "### May be you need these commands ###"
    echo
    echo "# vim /etc/zabbix/zabbix_agent2.conf"
    echo
    echo "# tail -f /var/log/zabbix/zabbix_agent2.log"
    echo "# zabbix_agent2 -p | head"
    echo
    echo "# systemctl stop zabbix-agent2"
    echo "# systemctl status zabbix-agent2"
    echo "# systemctl start zabbix-agent2"
    echo "# systemctl enable zabbix-agent2"
    echo
}

# Execute main function
main