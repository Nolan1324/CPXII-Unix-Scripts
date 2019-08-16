# CPXII-Unix-Scripts
CyberPatriot scripts/checklists created by a CyberPatriot student (me) for my team's personal use on Unix-based VMs. Not authorized for use by other teams.
## Checklist
1. Read the README
2. Do all forensics questions
3. Do any tasks outlined in the README (ex. creating groups)
4. Manage users in accordance with the README
	* Add user `adduser $user`
	* Delete user `deluser $user; delgroup $user`
	* Change insecure passwords with `passwd $user`
	* All of the above can also be done with the GUI on Ubuntu
	* Change users who should or should not be administrator
5. Manage groups inn accordance with the README
	* Add group `addgroup $group`
	* Delete group `delgroup $group`
6. Aduit `/etc/sudoers` (look for people who should not have sudo)
7. Update mirrors in `/etc/apt/sources.list` by adding these lines:
	```
	deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse
	deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse
	deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-backports main restricted universe multiverse
	deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse
	```
8. Remove unwanted packages with `apt-get purge $package` or by using the GUI
9. Update package list and upgrade installed packages
	1. `apt-get update`
	2. `apt-get upgrade`
10. Update the kernel with `apt-get install linux-image-$(uname -r)`
11. Audit system crontabs in `/etc/crontab` and user crontabs using `crontab -e -u $user` (or in `/var/spool/cron/crontabs/$user`)
12. Audit permissions and contents of home directories and system files using `ls -lA`. It is good to know what most of the core system files contain and do to save time during competition. Some **examples** of cor system files:
	* `/etc/rc.local`
	* `/etc/login.defs`
	* `/etc/crontab`
	* `/etc/sysctl.conf` - Configures the kernel. Hardening: https://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening/
	* `/etc/passwd` - Users
	* `/etc/shadow` - Password hashes
	* `/etc/group` - Groups
	* `/etc/sudoers` - Who can use sudo
	* `/var/log/*` - System logs. Usually all readable by everyone except for `auth.log*`, `btmp*`, `dmesg`, `kern.log*`, `syslog*`, and `ufw.log*` (list everyone readable files with `ls -lA | grep "^\-......r.."`)
	* `/etc/hosts` - This should exist, but be empty except for some standard lines (ex: `127.0.0.1 localhost`). If unsure, just look up the [default contents](https://askubuntu.com/a/880272) on Google and copy/paste into the file.
	* `/etc/apt/sources.list`
	* `/etc/securetty` - If the file does not exists, root can use any terminal. This is a potential security vulnerability.
	* `/etc/apt/apt.conf.d/10periodic` - https://qznc.github.io/my-homeserver/hardening.html#automatic-security-updates. Add (or edit) the following lines:
		```
		APT::Periodic::Update-Package-Lists "1";
		APT::Periodic::Download-Upgradeable-Packages "1";
		APT::Periodic::AutocleanInterval "7";
		APT::Periodic::Unattended-Upgrade "1";
		```

## Scripts
* [init.sh](init.sh) Run this first. Installs xcopy (used by other scripts) and sets up aliases
* [basic.sh](basic.sh) Standard security fixes
* [audit_setup.sh](audit_setup.sh) Setup and run auditd with a best practices rules file
* [rookit_scan.sh](rootkit_scan.sh) Install chkrookit and rkhunter and check for rootkits

## Credits
* [lib/auditd](lib/auditd) cloned from https://github.com/Neo23x0/auditd
* [util/suppress_gedit.sh](util/suppress_gedit.sh) adapted from https://askubuntu.com/a/572827
* [util/aliases.txt](/util/aliases.txt) adapted from https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions
