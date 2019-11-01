#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

#Get the directory of the script
SCRIPT_DIR="$(dirname "$0")"

. "$SCRIPT_DIR/util/common.sh"

#Netowrk 
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
sudo sysctl -p

#System Maintenance
echo_status "6.1.2 Ensure permissions on /etc/passwd are configured"
chown root:root /etc/passwd
chmod 644 /etc/passwd
echo_status "6.1.3 Ensure permissions on /etc/shadow are configured"
chown root:shadow /etc/shadow
chmod o-rwx,g-wx /etc/shadow
echo_status "6.1.4 Ensure permissions on /etc/group are configured"
chown root:root /etc/group
chmod 644 /etc/group
echo_status "6.1.5 Ensure permissions on /etc/gshadow are configured"
chown root:shadow /etc/gshadow
chmod o-rwx,g-rw /etc/gshadow
echo_status "6.1.6 Ensure permissions on /etc/passwd- are configured"
chown root:root /etc/passwd-
chmod u-x,go-wx /etc/passwd-
echo_status "6.1.7 Ensure permissions on /etc/shadow- are configured"
chown root:root /etc/shadow-
chown root:shadow /etc/shadow-
chmod o-rwx,g-rw /etc/shadow-
echo_status "6.1.8 Ensure permissions on /etc/group- are configured"
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-
echo_status "6.1.9 Ensure permissions on /etc/gshadow- are configured"
chown root:root /etc/gshadow-
chown root:shadow /etc/gshadow-
chmod o-rwx,g-rw /etc/gshadow-

#User and Group Setting
echo_status "6.2.1 Ensure password fields are not empty"
cat /etc/shadow | awk -F: '($2 == "" ) { print $1 " does not have a password "}'
pause "[PAUSED] Provide these users strong passwords. \"passwd -l <username>\""
echo_status "6.2.2 Ensure no legacy \"+\" entries exist in /etc/passwd"
grep '^\+:' /etc/passwd
echo_status "6.2.3 Ensure no legacy \"+\" entries exist in /etc/shadow"
grep '^\+:' /etc/shadow
echo_status "6.2.4 Ensure no legacy \"+\" entries exist in /etc/group"
grep '^\+:' /etc/group
pause "[PAUSED] Remove lines found in the files in 6.2.2-4"
echo_status "6.2.5 Ensure root is the only UID 0 account"
cat /etc/passwd | awk -F: '($3 == 0) { print $1 }'
pause "[PAUSED] Change the UID of users listed other than root. \"usermod -u <new-uid> <username>\""
echo_status "6.2.6 Ensure root PATH Integrity"
if [ "`echo $PATH | grep :: `" != "" ]; then
 echo "Empty Directory in PATH (::)"
fi
if [ "`echo $PATH | grep :$`" != "" ]; then
echo "Trailing : in PATH"
fi
p=`echo $PATH | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'`
set -- $p
while [ "$1" != "" ]; do
if [ "$1" = "." ]; then
 echo "PATH contains ."
 shift
 continue
fi
if [ -d $1 ]; then
 dirperm=`ls -ldH $1 | cut -f1 -d" "`
 if [ `echo $dirperm | cut -c6 ` != "-" ]; then
  echo "Group Write permission set on directory $1"
 fi
 if [ `echo $dirperm | cut -c9 ` != "-" ]; then
  echo "Other Write permission set on directory $1"
 fi
 dirown=`ls -ldH $1 | awk '{print $3}'`
 if [ "$dirown" != "root" ] ; then
  echo $1 is not owned by root
 fi
else
 echo $1 is not a directory
fi
shift
done
pause "[PAUSED] Fix any issues listed"
echo_status "6.2.7-12 User home directory auditing"
cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/usr/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
if [ ! -d "$dir" ]; then
  echo "The home directory ($dir) of user $user does not exist."
else
  dirperm=`ls -ld $dir | cut -f1 -d" "`
  owner=$(stat -L -c "%U" "$dir")
  if [ `echo $dirperm | cut -c6` != "-" ]; then
   echo "Group Write permission set on the home directory ($dir) of user $user"
  fi
  if [ `echo $dirperm | cut -c8` != "-" ]; then
   echo "Other Read permission set on the home directory ($dir) of user $user"
  fi
  if [ `echo $dirperm | cut -c9` != "-" ]; then
   echo "Other Write permission set on the home directory ($dir) of user $user"
  fi
  if [ `echo $dirperm | cut -c10` != "-" ]; then
  echo "Other Execute permission set on the home directory ($dir) of user $user"
  fi
  if [ "$owner" != "$user" ]; then
    echo "The home directory ($dir) of user $user is owned by $owner."
  fi
  for file in $dir/.[A-Za-z0-9]*; do
   if [ ! -h "$file" -a -f "$file" ]; then
    fileperm=`ls -ld $file | cut -f1 -d" "`
    if [ `echo $fileperm | cut -c6` != "-" ]; then
      echo "Group Write permission set on file $file"
    fi
    if [ `echo $fileperm | cut -c9` != "-" ]; then
     echo "Other Write permission set on file $file"
    fi
    if [ ! -h "$file" -a -f "$file" ]; then
     echo ".rhosts file in $dir"
    fi
  done
  if [ ! -h "$dir/.forward" -a -f "$dir/.forward" ]; then
   echo ".forward file $dir/.forward exists"
  fi
  if [ ! -h "$dir/.netrc" -a -f "$dir/.netrc" ]; then
   echo ".netrc file $dir/.netrc exists"
  fi
fi
done
pause "[PAUSED] Fix any of the problems listed"
echo_status "6.2.15 Ensure all groups in /etc/passwd exist in /etc/group"
for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
  grep -q -P "^.*?:[^:]*:$i:" /etc/group
  if [ $? -ne 0 ]; then
    echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group"
  fi
done
echo_status "6.2.16 Ensure no duplicate UIDs exist"
cat /etc/passwd | cut -f3 -d":" | sort -n | uniq -c | while read x ; do [ -z "${x}" ] && break
  set - $x
  if [ $1 -gt 1 ]; then
    users=`awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs`
    echo "Duplicate UID ($2): ${users}"
  fi
done
echo_status "6.2.17 Ensure no duplicate GIDs exist"
cat /etc/group | cut -f3 -d":" | sort -n | uniq -c | while read x ; do [ -z "${x}" ] && break
  set - $x
  if [ $1 -gt 1 ]; then
    groups=`awk -F: '($3 == n) { print $1 }' n=$2 /etc/group | xargs`
  echo "Duplicate GID ($2): ${groups}"
  fi
done
echo_status "6.2.18 Ensure no duplicate user names exist"
cat /etc/passwd | cut -f1 -d":" | sort -n | uniq -c | while read x ; do [ -z "${x}" ] && break
  set - $x
  if [ $1 -gt 1 ]; then
    uids=`awk -F: '($1 == n) { print $3 }' n=$2 /etc/passwd | xargs`
    echo "Duplicate User Name ($2): ${uids}"
  fi
done
echo_status "6.2.19 Ensure no duplicate group names exist"
cat /etc/group | cut -f1 -d":" | sort -n | uniq -c | while read x ; do [ -z "${x}" ] && break
  set - $x
  if [ $1 -gt 1 ]; then
    gids=`gawk -F: '($1 == n) { print $3 }' n=$2 /etc/group | xargs`
    echo "Duplicate Group Name ($2): ${gids}"
  fi
done
pause "[PAUSED] Fix any of the problems listed in 6.2.15-19"
echo_status "6.2.20 Ensure shadow group is empty"
grep ^shadow:[^:]*:[^:]*:[^:]+ /etc/group
awk -F: '($4 == "<shadow-gid>") { print }' /etc/passwd
pause "[PAUSED] If anyone is in shadow, remove them"
