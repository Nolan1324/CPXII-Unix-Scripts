#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

#Get the directory of the script
SCRIPT_DIR="$(dirname "$0")"

. "$SCRIPT_DIR/util/common.sh"

#Systcl
echo_status "3.1.1 Ensure IP forwarding is disabled"
echo "net.ipv4.ip_forward=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo_status "3.1.2 Ensure packet redirect sending is disabled"
echo "net.ipv4.conf.all.send_redirects=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo_status "3.2.1 Ensure source routed packets are not accepted"
echo "net.ipv4.conf.all.accept_source_route=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo_status "3.2.2 Ensure ICMP redirects are not accepted"
echo "net.ipv4.conf.all.accept_redirects=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo_status "3.2.3 Ensure secure ICMP redirects are not accepted"
echo "net.ipv4.conf.all.secure_redirects=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.secure_redirects=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo_status "3.2.4 Ensure suspicious packets are logged"
echo "net.ipv4.conf.all.log_martians=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.log_martians=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo_status "3.2.5 Ensure broadcast ICMP requests are ignored"
echo "net.ipv4.icmp_echo_ignore_broadcasts=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo_status "3.2.6 Ensure bogus ICMP responses are ignored"
echo "net.ipv4.icmp_ignore_bogus_error_responses=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo_status "3.2.7 Ensure Reverse Path Filtering is enabled"
echo "net.ipv4.conf.all.rp_filter=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo_status "3.2.8 Ensure TCP SYN Cookies is enabled"
echo "net.ipv4.tcp_syncookies=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.all.accept_ra=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_ra=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.route.flush=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.all.accept_redirects=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_redirects=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.route.flush=1" | sudo tee -a /etc/sysctl.conf

echo_status "6.2.9 Ensure users own their home directories"
cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 !=
"/usr/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
if [ ! -d "$dir" ]; then
  echo "The home directory ($dir) of user $user does not exist."
else
  owner=$(stat -L -c "%U" "$dir")
  if [ "$owner" != "$user" ]; then
    echo "The home directory ($dir) of user $user is owned by $owner."
  fi
fi
done
pause "Manually change incorrect ownerships then press [Enter] to continue"

echo_status "6.2.20 Ensure shadow group is empty"
grep ^shadow:[^:]*:[^:]*:[^:]+ /etc/group
awk -F: '($4 == "<shadow-gid>") { print }' /etc/passwd
pause If anyone is in shadow, remove them hit [Enter]
