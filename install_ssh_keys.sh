#!/bin/bash

###########################################################################################
# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/master/install_ssh_keys.sh | bash

if [ ! -d "/root/ssh_keys" ]
then
    echo "You have to add folder 'ssh_keys' with keys to /root, before running the script. Exit."
    exit 1
fi

echo
echo "[ Script will do several tasks: ]"
echo "[ 1 ] install root's keys (public and private)"
echo "[ 2 ] install mk's keys (public and private + github private)"
echo "[ 3 ] Create ~/.ssh/config for root"
echo "[ 4 ] Create ~/.ssh/config for mk"
echo "[ 5 ] Disable PasswordAuthentication"
echo "[ 6 ] Restart sshd"
echo "[ 7 ] Show test commands"
echo "[ 8 ] Remove ssh_keys folder"
echo

echo "[1] Install root's keys"
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
echo

echo "[2] Install mk's keys"
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
echo
echo "Coping private key for github.com: cp /root/ssh_keys/mk/mk_github_ed25519 /home/mk/.ssh/mk_github_ed25519"
cp /root/ssh_keys/mk/mk_github_ed25519 /home/mk/.ssh/mk_github_ed25519 && echo "[OK]"
echo "Changing access: chmod 400 /home/mk/.ssh/mk_github_ed25519 && chown mk:mk /home/mk/.ssh/id_ed25519"
chmod 400 /home/mk/.ssh/mk_github_ed25519 && chown mk:mk /home/mk/.ssh/mk_github_ed25519 && echo "[OK]"
echo

echo "[3] Create ~/.ssh/config for root (disable strict host key checking)"
echo "cp /root/ssh_keys/root/config /root/.ssh/config"
cp /root/ssh_keys/root/config /root/.ssh/config && echo "[OK]"
echo "chmod 600 /root/.ssh/config"
chmod 600 /root/.ssh/config && echo "[OK]"

echo "[4] Create ~/.ssh/config for mk (disable strict host key checking + specify key for github.com)"
echo "cp /root/ssh_keys/mk/config /home/mk/.ssh/config"
cp /root/ssh_keys/mk/config /home/mk/.ssh/config && echo "[OK]"
echo "chown mk:mk /home/mk/.ssh/config && chmod 600 /home/mk/.ssh/config"
chown mk:mk /home/mk/.ssh/config && chmod 600 /home/mk/.ssh/config && echo "[OK]"

echo "[5] Disabling PasswordAuthentication: \"PasswordAuthentication no\" > /etc/ssh/sshd_config.d/disable_password_auth.conf"
echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/disable_password_auth.conf
echo

echo "[6] Restarting sshd"
systemctl restart sshd && echo [OK]
echo "sshd server restarted and you can try to connect with ssh-keys"
echo

echo "[7] Test commands"
echo "su mk -c 'ssh -T git@github.com'"
echo "runuser -l mk -c 'ssh -vT git@github.com'"
echo "ssh 10.10.10.200"
echo "ssh 10.10.20.200"
echo

echo "[8] Removing ssh_keys folder"
echo "if all test passed you can remove key folder with command:"
echo "rm -r /root/ssh_keys"
echo

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
