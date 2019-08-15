#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

#Get the directory of the script
SCRIPT_DIR="$(dirname "$0")"

. "$SCRIPT_DIR/util/common.sh"

#Audits
echo_status "[Installing auditd]"
apt-get install auditd
echo_status "[Enabling audits]"
auditctl -e 1
AUDIT_BAK="/etc/audit/audit.rules.bak"
if [ ! -f $AUDIT_BAK ]; then
   echo_status "[Backing up audit.rules file]"
   mv /etc/audit/audit.rules $AUDIT_BAK  
fi
echo_status "[Copying best practices audit.rules file into /etc/audit/]"
cp $SCRIPT_DIR/lib/auditd/audit.rules /etc/audit
echo_status "[Restarting auditd service]"
service auditd restart
pause_general
