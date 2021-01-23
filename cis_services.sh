#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

#Get the directory of the script
SCRIPT_DIR="$(dirname "$0")"

. "$SCRIPT_DIR/util/common.sh"


apt purge xinetd
apt-get remove openbsd-inetd
apt install chrony
apt install ntp
systemctl enable systemd-timesyncd.service
systemctl start systemd-timesyncd.service
timedatectl set-ntp true
systemctl --now disable avahi-daemon
systemctl --now disable cups
systemctl --now disable isc-dhcp-server
systemctl --now disable isc-dhcp-server6
systemctl --now disable slapd
systemctl --now disable nfs-server
systemctl --now disable rpcbind
systemctl --now disable bind9
systemctl --now disable vsftpd
systemctl --now disable apache2
systemctl --now disable dovecot
systemctl --now disable smbd
systemctl --now disable squid
systemctl --now disable snmpd

systemctl disable rsync
systemctl disable nis

apt-get remove nis
apt-get remove rsh-client rsh-redone-client
apt-get remove talk
apt-get remove telnet
apt-get remove ldap-utils

pause "[PAUSED] Script finished"
