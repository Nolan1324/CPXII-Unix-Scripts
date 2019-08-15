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
	* Delete group `delgroup $user`
6. Remove unwanted packages with `apt-get purge $package` or by using the GUI
7. Do package updates and upgrades
	1. `apt-get update`
	2. `apt-get upgrade`
8. Update the kernel with `apt-get install linux-image-$(uname -r)`
9. Run `sudo ./unix.sh`

##Scripts
* [init.sh](init.sh) Run this first. Installs xcopy (used by other scripts) and sets up aliases
* [basic.sh](basic.sh) Standard security fixes
* [audit_setup.sh](audit_setup.sh) Setup and run auditd with a best practices rules file
* [rookit_scan.sh](rootkit_scan.sh) Install chkrookit and rkhunter and check for rootkits.

## Credits
* [lib/auditd](lib/auditd) cloned from https://github.com/Neo23x0/auditd
* [util/suppress_gedit.sh](util/suppress_gedit.sh) adapted from https://askubuntu.com/a/572827
* [util/aliases.txt](/util/aliases.txt) adapted from https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions
