#!/bin/bash
#Version 1.0

#Do a sudo/root level check
uid=$(id -u)

#We don't have root permissions, so we can't install or upgrade anything, so we quit
[ $uid -ne 0 ] && { echo "Only root may run this Blueprint installation package."; exit 1; }

#run our first update
apt-get update

#Check for github so we can pull down the blueprint package files
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")

#It's not there, install and enable it
if [ "" == "$PKG_OK" ]; then
 	sudo apt-get --force-yes --yes install git
fi

_user=$(logname)

#Download the modules configuration system
cd "/home/$_user"; git clone https://github.com/JoshuaFlynn/Modules.git

#Make a backup copy of the sources list file
cp /etc/apt/sources.list /etc/apt/jessie-sources.list.bak

#Copy in our ascii file
cp "/home/$_user/Modules/Blueprints/HelperScripts/Replacements/ascii-sources.list" /etc/apt/sources.list

#Update the new sources list
apt-get update -y

#Update apt (if any updates for it are pending)
apt-get install -y apt

#Upgrade the present collection
apt-get upgrade -y

#Remove old packages
apt-get autoremove -y

#Perform a distribution upgrade
apt-get dist-upgrade -y

#Remove old packages
apt-get autoremove -y

#Reboot so changes take effect
reboot