#!/usr/bin/env python2

from bs4 import BeautifulSoup
import requests
import pwd
import grp

#url = raw_input("Paste full README URL: ")
url = "https://www.uscyberpatriot.org/Pages/Readme/cpxiii_training_se_ubu16_readme_civo4h5532.aspx"
page = requests.get(url)

soup = BeautifulSoup(page.text, 'html.parser')
contents = soup.find("pre").contents

you = ""
all_users = []
admins = []

nextAdmins = False
nextUsers = False
for c in contents:
	if nextAdmins:
		for u in c.strip().split("\n"):
			u = str(u.strip())
			if "you" in u.lower():
				you = u[:u.find(" ")]
			elif not "password" in u.lower():
				all_users.append(u)
				admins.append(u)
		nextAdmins = False

	if nextUsers:
		for u in c.strip().split("\n"):
			u = str(u.strip())
			all_users.append(u)
		nextUsers = False
	if "Administrators" in str(c): nextAdmins = True
	if "Users" in str(c): nextUsers = True

pwd_users = []
for p in pwd.getpwall():
	#TODO read UID range from /etc/adduser.conf
	if p.pw_uid >= 1000 and p.pw_uid <= 29999:
		pwd_users.append(p.pw_name)
#grp_users = grp.getgrnam("users").gr_mem
grp_sudo = grp.getgrnam("sudo").gr_mem

#Remove people from admins
for u in grp_sudo:
	if not u in admins and u != you:
		print("\033[96m" + u + "\033[0m removed from admins")

#Add people to admins
for u in admins:
	if not u in grp_sudo:
		print("\033[33m" + u + "\033[0m added to admins")

#Remove users
for u in pwd_users:
	if not u in all_users and u != you:
		print("\033[91m" + u + "\033[0m deleted")
