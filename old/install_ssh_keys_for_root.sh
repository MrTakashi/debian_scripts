#!/bin/bash

# активируем опцию, которая прерывает выполнение скрипта, если любая команда завершается с ненулевым статусом
set -e

#########################################################################################################
# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/install_ssh_keys_for_root.sh | bash

if [ ! -d "/root/ssh_keys" ]
then
    echo "You have to add folder 'ssh_keys' with keys to /root, before running the script. Exit."
    exit 1
fi

echo
echo "[ Script will do several tasks: ]"
echo "[ 1 ] install root's keys (public and private)"
echo "[ 2 ] Create ~/.ssh/config for root"
echo "[ 3 ] Disable PasswordAuthentication for SSH"
echo "[ 4 ] Restart sshd"
echo "[ 5 ] Remove folder: rm -rf /root/ssh_keys"
echo "[ 6 ] Show next commands"
echo

############################################################################################################
echo "[1] Install root's keys"
echo "Preparing folder for keys: mkdir ~/.ssh -p && chmod 700 ~/.ssh"
mkdir ~/.ssh -p && chmod 700 ~/.ssh && echo "[OK]"
echo "Moving key: cp /root/ssh_keys/root/id_ed25519.pub ~/.ssh/authorized_keys"
mv /root/ssh_keys/root/id_ed25519.pub ~/.ssh/authorized_keys && echo "[OK]"
echo "Changing access: chmod 600 ~/.ssh/authorized_keys"
chmod 600 ~/.ssh/authorized_keys && echo "[OK]"
echo
echo "Moving private key: cp /root/ssh_keys/root/id_ed25519 ~/.ssh/id_ed25519"
mv /root/ssh_keys/root/id_ed25519 ~/.ssh/id_ed25519 && echo "[OK]"
echo "Changing access: chmod 400 ~/.ssh/id_ed25519"
chmod 400 ~/.ssh/id_ed25519 && echo "[OK]"
echo

############################################################################################################
echo "[2] Create ~/.ssh/config for 'root' (disable strict host key checking)"
echo "Moving config: mv /root/ssh_keys/root/config /root/.ssh/config"
mv /root/ssh_keys/root/config /root/.ssh/config && echo "[OK]"
echo "chmod 600 /root/.ssh/config"
chmod 600 /root/.ssh/config && echo "[OK]"
echo

############################################################################################################
echo "[3] Disabling PasswordAuthentication for SSH: \"PasswordAuthentication no\" > /etc/ssh/sshd_config.d/no_pass_auth.conf"
echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/no_pass_auth.conf
echo

############################################################################################################
echo "[4] Restarting sshd"
systemctl restart sshd && echo [OK]
echo "sshd server restarted - you can try to connect with ssh-keys"
echo

############################################################################################################
echo "[5] Remove folder: /root/ssh_keys"
echo "rm -rf /root/ssh_keys"
rm -rf /root/ssh_keys && echo "[OK]"
echo

############################################################################################################
echo "[6] Next commands"
echo
#echo "runuser -l mk -c 'ssh -vT git@github.com'"
#echo "ssh 10.10.10.200"
#echo "ssh 10.10.20.200"
#echo
echo "sudo ansible zabbix -m command -a uptime"
echo "sudo ansible-playbook playbooks/debian/00_update_system_and_install_packages.yml -l $(uname -n)"
echo "sudo ansible-playbook playbooks/debian/10_bashrc_root.yml -l $(uname -n)"
echo "sudo ansible-playbook playbooks/debian/11_vimrc_root.yml -l $(uname -n)"

###### add several hosts to ~/.ssh/known_hosts
#echo
#echo "Try to add [10.10.10.200, github.com] to ~/.ssh/known_hosts:"
#echo
#ssh-keyscan -t ed25519 -H 10.10.10.200 > ~/.ssh/known_hosts
#ssh-keyscan -t ed25519 -H github.com >> ~/.ssh/known_hosts
#runuser -l mk -c 'ssh-keyscan -t ed25519 -H 10.10.10.200 > ~/.ssh/known_hosts'
#runuser -l mk -c 'ssh-keyscan -t ed25519 -H github.com >> ~/.ssh/known_hosts'
#echo "10.10.10.200 and github.com added to ~/.ssh/known_hosts"

###### PermitRootLogin yes
#sed -i -r 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
#echo "/etc/ssh/sshd_config updated: PermitRootLogin yes"
