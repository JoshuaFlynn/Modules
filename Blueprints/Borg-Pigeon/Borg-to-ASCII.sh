#!/bin/bash
#Version 1.0

#Do a sudo/root level check
uid=$(id -u)

#We don't have root permissions, so we can't install or upgrade anything, so we quit
[ $uid -ne 0 ] && { echo "Only root may run this Blueprint installation package."; exit 1; }

#run our first update
apt-get update

_user=$(logname)

#Download the modules configuration system
bash "/home/$_user/Modules/Blueprints/HelperScripts/Download-Github.sh" https://github.com/JoshuaFlynn/Modules "/home/$_user/" Modules

#Make a backup copy of the sources list file
cp /etc/apt/sources.list /etc/apt/jessie-sources.list.bak

#Copy in our ascii file
cp "/home/$_user/Modules/Blueprints/HelperScripts/Replacements/ascii-sources.list" /etc/apt/sources.list

#Update the new sources list
apt-get update -y

#Update apt (if any updates for it are pending)
apt-get install --force-yes -yes apt

#Upgrade the present collection
apt-get upgrade --force-yes -yes

#Remove old packages
apt-get autoremove --force-yes -yes

#Perform a distribution upgrade
apt-get dist-upgrade --force-yes -yes

#Remove old packages
apt-get autoremove --force-yes -yes

#Reboot so changes take effect
reboot