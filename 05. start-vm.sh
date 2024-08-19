#!/bin/bash

# активируем опцию, которая прерывает выполнение скрипта, если любая команда завершается с ненулевым статусом
set -e

# настроим часовой пояс
echo -e "\n====================\nSetting timezone\n===================="
timedatectl set-timezone Europe/Moscow
systemctl restart systemd-timesyncd.service
timedatectl
echo -e "\nDONE\n"

# выключим ipv6
echo -e "\n====================\nDisabling ipv6\n===================="

while true; do
  read -r -n 1 -p "Continue or Skip? (c|s) " cs
  case $cs in
  [Cc]*)
    echo -e "\n\n"
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&ipv6.disable=1 /' /etc/default/grub
    sed -i 's/^GRUB_CMDLINE_LINUX="/&ipv6.disable=1 /' /etc/default/grub
    update-grub
    echo -e "\nDONE\n"
    break
    ;;

  [Ss]*)
    echo -e "\n"
    break
    ;;
  *) echo -e "\nPlease answer C or S!\n" ;;
  esac
done

echo -e "\nOK\n"
exit 0