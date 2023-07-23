#!/bin/bash

echo "Script will do several work:"
echo " 1. install root's ssh-keys"
echo " 2. install mk's ssh-keys"
echo " 3. install mk's ssh key for github.com and setup ssh-connection (github.com.conf)"
echo " 4. disable PasswordAuthentication for ssh (keys auth only)"
echo " 5. disable asswordAuthentication for ssh (keys auth only)"
echo " 6. restart sshd service"
echo
echo

echo "################## [1] installing root's keys #################"
echo
echo "Preparing folder for public keys: mkdir ~/.ssh -p && chmod 700 ~/.ssh"
mkdir ~/.ssh -p && chmod 700 ~/.ssh && echo "[OK]"
echo "Coping public key: cp /root/ssh_keys/root/id_ed25519.pub ~/.ssh/authorized_keys"
cp /root/ssh_keys/root/id_ed25519.pub ~/.ssh/authorized_keys && echo "[OK]"
echo "Changing access: chmod 600 ~/.ssh/authorized_keys"
chmod 600 ~/.ssh/authorized_keys && echo "[OK]"
echo

echo "Copy private key: cp /root/ssh_keys/root/id_ed25519 ~/.ssh/id_ed25519"
cp /root/ssh_keys/root/id_ed25519 ~/.ssh/id_ed25519 && echo "[OK]"
echo "Changing access: chmod 400 ~/.ssh/id_ed25519"
chmod 400 ~/.ssh/id_ed25519 && echo "[OK]"


echo "################## [2] installing mk's keys ##################"
echo
echo "Preparing folder for public keys: mkdir /home/mk/.ssh -p && chmod 700 /home/mk/.ssh && chown mk:mk /home/mk/.ssh"
mkdir /home/mk/.ssh -p && chmod 700 /home/mk/.ssh && chown mk:mk /home/mk/.ssh && echo "[OK]"
echo "Coping public key: cp /root/ssh_keys/mk/id_ed25519.pub /home/mk/.ssh/authorized_keys"
cp /root/ssh_keys/mk/id_ed25519.pub /home/mk/.ssh/authorized_keys && echo "[OK]"
echo "Changing access: chmod 600 /home/mk/.ssh/authorized_keys && chown mk:mk /home/mk/.ssh/authorized_keys"
chmod 600 /home/mk/.ssh/authorized_keys && chown mk:mk /home/mk/.ssh/authorized_keys && echo "[OK]"
echo

echo "Coping private key: cp /root/ssh_keys/mk/id_ed25519 /home/mk/.ssh/id_ed25519"
cp /root/ssh_keys/mk/id_ed25519 /home/mk/.ssh/id_ed25519 && echo "[OK]"
echo "Changing access: chmod 400 /home/mk/.ssh/id_ed25519 && chown mk:mk /home/mk/.ssh/id_ed25519"
chmod 400 /home/mk/.ssh/id_ed25519 && chown mk:mk /home/mk/.ssh/id_ed25519 && echo "[OK]"


echo "################## [3] configuring mk's ssh-connection to github.com #################"
echo "Preparing folder for ssh-config: mkdir /etc/ssh/ssh_config.d"
mkdir /etc/ssh/ssh_config.d && echo "[OK]"

echo "Coping ssh-config: cp /root/ssh_keys/ssh_config.d/github.com.conf /etc/ssh/ssh_config.d/github.com.conf"
cp /root/ssh_keys/ssh_config.d/github.com.conf /etc/ssh/ssh_config.d/github.com.conf && echo "[OK]"

echo "Coping private key: cp /root/ssh_keys/mk/mk_github_ed25519 /home/mk/.ssh/mk_github_ed25519"
cp /root/ssh_keys/mk/mk_github_ed25519 /home/mk/.ssh/mk_github_ed25519 && echo "[OK]"
echo "Changing access: chmod 400 /home/mk/.ssh/mk_github_ed25519 && chown mk:mk /home/mk/.ssh/mk_github_ed25519"
chmod 400 /home/mk/.ssh/mk_github_ed25519 && chown mk:mk /home/mk/.ssh/mk_github_ed25519 && echo "[OK]"


echo "################## [4] disabling PasswordAuthentication #################"
echo "Edit /etc/ssh/sshd_config: sed -i -r 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config"
sed -i -r 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config && echo "[OK]"
grep -e "^PasswordAuthentication" /etc/ssh/sshd_config


echo "################## [5] configuring no strict host key checking #################"
echo "Coping ssh-config: cp /root/ssh_keys/ssh_config.d/github.com.conf /etc/ssh/ssh_config.d/github.com.conf"
cp /root/ssh_keys/ssh_config.d/no_strict_host_key_checking.conf /etc/ssh/ssh_config.d/no_strict_host_key_checking.conf && echo "[OK]"


echo "################## [6] restarting sshd-server #################"
systemctl restart sshd && echo [OK]
echo "sshd server restarted and you can try to connect with ssh-keys"


echo "################## [7] testing"
runuser -l mk -c 'ssh -vT git@github.com'

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
