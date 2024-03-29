#!/bin/bash

##############################################################################################################
# wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/master/install_user_settings.sh | bash

echo "[ Script will do several tasks: ]"
echo "[ 1 ] install ~/.bashrc for root and for mk"
echo "[ 2 ] install ~/.vimrc for root and for mk"
echo

echo "Install ~/.bashrc for root:"
echo "wget -qO - http://i.sspx.ru/1 >> ~/.bashrc"
wget -qO - http://i.sspx.ru/1 >> ~/.bashrc && echo "[OK]"
echo

echo "Install ~/.bashrc for mk:"
echo "runuser -l mk -c 'wget -qO - http://i.sspx.ru/1 >> ~/.bashrc'"
runuser -l mk -c 'wget -qO - http://i.sspx.ru/1 >> ~/.bashrc' && echo "[OK]"
echo

echo "Install ~/.vimrc for root:"
echo "wget -qO - http://i.sspx.ru/2 >> ~/.vimrc"
wget -qO - http://i.sspx.ru/2 >> ~/.vimrc && echo "[OK]"
echo

echo "Install ~/.vimrc for mk:"
echo "runuser -l mk -c 'wget -qO - http://i.sspx.ru/2 >> ~/.vimrc'"
runuser -l mk -c 'wget -qO - http://i.sspx.ru/2 >> ~/.vimrc' && echo "[OK]"
echo
