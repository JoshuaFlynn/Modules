#!/bin/bash
#Version 1.0

#Do a sudo/root level check
uid=$(id -u)

#We don't have root permissions, so we can't install or upgrade anything, so we quit
[ $uid -ne 0 ] && { echo "Only root may run this Blueprint installation package."; exit 1; }

#run our first update
apt-get update

#Check for UFW
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' ufw|grep "install ok installed")

#It's not there, install and enable it
if [ "" == "$PKG_OK" ]; then
 	sudo apt-get --force-yes --yes install ufw
	#Enable the firewall
	ufw enable
fi

#Check for github so we can pull down the blueprint package files
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")

#It's not there, install and enable it
if [ "" == "$PKG_OK" ]; then
 	sudo apt-get --force-yes --yes install git
fi

#_user=$SUDO_USER

#Make our deployment directory
#mkdir "/home/$_user/Modules"
#if [ $? -ne 0 ] ; then
#	echo "Failed to make a /home/$_user/Modules/ directory. Quitting."
#	exit 1;
#fi

#Download the modules configuration system
git clone https://github.com/JoshuaFlynn/Modules.git

#Navigate to the new directory
cd "/home/$_user/Modules"

#Transfer a copy of the sources.list file (which should be correctly configured)
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp ./Blueprints/King-Pigeon/Replacements/sources.list /etc/apt

update-initramfs -u