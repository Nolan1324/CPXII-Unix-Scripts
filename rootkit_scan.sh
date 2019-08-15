#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

#Get the directory of the script
SCRIPT_DIR="$(dirname "$0")"

. "$SCRIPT_DIR/util/common.sh"

#RootKit Protection 1
echo_status "[Installing chkrootkit]"
apt-get install chkrootkit
pause_general
chkrootkit | tee chkrootkit.txt
pause_general

#RootKit Protection 2
echo_status "[Installing and running rkhunter]"
apt-get install rkhunter
rkhunter --update
pause_general
rkhunter --check
pause_general
