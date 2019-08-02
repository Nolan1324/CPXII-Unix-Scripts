#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

. suppress_gedit.sh

#Variables that change the color of text when used in echo -e
R='\033[0m' #Reset color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

function echo_status() {
   echo -e "${YELLOW}$*"
   tput sgr0
}

function line_add_msg() {
   clear
   echo_status "[Please add the following line(s) (copied to clipboard)]"
}

function line_change_msg() {
   clear
   echo_status "[Please change the following line(s)]"
}

function pause() {
   read -p "[33m$*[0m: "
}

#Opens a file in gedit at the first line that matches the grep pattern
#$1 File path
#$2 Line grep pattern
function gedit_at_line() {
   gedit $1 +$(grep $2 -m 1 -n $1 | cut -f1 -d:)
}

#Install xclip for copying text
apt-get install xclip

#Password policy
line_change_msg
echo -e "PASS_MAX_DAYS ${RED}90${R}\nPASS_MIN_DAYS ${RED}7${R}\nPASS_WARN_AGE ${RED}7${R}"
gedit_at_line /etc/login.defs ^\s*PASS_MAX_DAYS
clear

pause "[Press ENTER to install pam_cracklib]"
apt-get install libpam-cracklib
line_change_msg
echo -e "... pam_unix.so... ${RED}remember=5 minlen=8${R}"
echo -e "... pam_cracklib.so... ${RED}ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1${R}"
gedit /etc/pam.d/common-password

line_add_msg
LINES="auth required pam_tally2.so deny=5 onerr=fail unlock_time=1800"
echo $LINES | xclip -selection c
echo -e "${RED}${LINES}${R}"
gedit /etc/pam.d/common-auth

#SSH
line_change_msg
echo -e "PermitRootLogin ${RED}no${R}"
gedit_at_line /etc/ssh/sshd_config ^\s*PermitRootLogin
clear

#Network
echo_status "[Enabing the firewall]"
sudo ufw enable
echo_status "[Enabling syn cookie protection]"
sysctl -n net.ipv4.tcp_syncookies
echo_status "[Disabling IPv6 (Potentially harmful)]"
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
echo_status "[Disabling IP Forwarding]"
echo 0 | sudo tee /proc/sys/net/ipv4/ip_forward
echo_status "[Preventing IP Spoofing]"
echo "nospoof on" | sudo tee -a /etc/host.conf
