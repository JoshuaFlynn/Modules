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

_user=$(logname)

#Make our deployment directory
#mkdir "/home/$_user/Modules"
#if [ $? -ne 0 ] ; then
#	echo "Failed to make a /home/$_user/Modules/ directory. Quitting."
#	exit 1;
#fi

#tell git to change it's directory (we want it to drop the module files in the right place for copying purposes)

#Download the modules configuration system
cd "/home/$_user"; git clone https://github.com/JoshuaFlynn/Modules.git

echo ls

#Delete the garbage files off the desktop
rm "/home/$_user/Desktop/_RELEASE_NOTES"
rm "/home/$_user/Desktop/SMALLER_FONTS.desktop"
rm "/home/$_user/Desktop/LARGER_FONTS.desktop"

#Navigate to the new directory
cd "/home/$_user/Modules"

#Transfer a copy of the sources.list file (which should be correctly configured)
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/sources.list" /etc/apt

#Now we've updated the sources.list file to include everything, update our own cache
apt-get update

#GIMP is a nice program, but to trim off the fat, it has to go
apt-get purge -y gimp

#Get rid of bloat office packages
apt-get purge -y libreoffice libreoffice-base libreoffice-math libreoffice-calc libreoffice-writer libreoffice-bin libreoffice-draw libreoffice-impress

#Get rid of the web browser
apt-get purge -y firefox-esr iceweasel w3m

#install a mini-web browser
apt-get install -y midori

#and printer support
apt-get purge -y hplip

#and more printer support
apt-get purge -y cups cups-browsed cups-bsd cups-client cups-common cups-core-drivers cups-daemon cups-filters cups-filters-core-drivers cups-pk-helper cups-ppdc cups-server-common

#and screen reader support
apt-get purge -y gnome-orca

#get rid of their xarchiver
apt-get purge -y xarchiver xarchiver-debug

#bring in our preferred file archiving program
apt-get install -y file-roller

#Get rid of evince (for now)
apt-get purge -y evince-common

#and get rid of their music support
apt-get purge -y vlc

#and CD burning capabilities
apt-get purge -y xfburn

#and scanning abilities
apt-get purge -y xsane

#Eww, Vim
apt-get purge -y vim

#Mousepad will be gone
apt-get purge -y mousepad

#Replace it with leafpad
apt-get install -y leafpad

#Get rid of audio garbage
apt-get purge -y exfalso quodlibet

#Get rid of XFCE entirely
apt-get purge -y xfconf xfce4-utils xfwm4 xfce4-session thunar xfdesktop4 exo-utils xfce4-panel xfce4-terminal xfce4-taskmanager

#Remove everything in the background images base
rm /usr/share/images/desktop-base/*

#Bring in LXDE
apt-get install -y lxde-core

#Pull in the terminal specifically for LXDE
apt-get install -y lxterminal

#Install a basic image viewer
apt-get install -y gpicview

#Get rid of the default display manager
apt-get purge -y slim

#Install the lightdm
apt-get install -y lightdm

#Finally, get rid of everything for realsies
apt-get autoremove -y

#Purge the usr/share folder containing the XFCE4 junk we no longer need, which isn't removed when XFCE goes
rm -rf "/usr/share/xfce4"

#Reinstall wicd, because for some reason this gets violently removed by one of the earlier libraries, but we actually need it
apt-get install -y wicd

#Add the King Pigeon Background
cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/King-Pigeon-Space.png" /usr/share/images/desktop-base/

#Add the King Pigeon icon
cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/King-Pigeon-Logo-Mini.png" /usr/share/pixmaps

#Set up the login screen's details
cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/lightdm-gtk-greeter.conf" /etc/lightdm

#Update the openbox rc file
cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/lxde-rc.xml" "/home/$_user/.config/openbox/"

cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/panel" "/home/$_user/.config/lxpanel/LXDE/panels/"

#Change the desktop background
#lxterminal --command "pcmanfm --set-wallpaper=/usr/share/images/desktop-base/King-Pigeon-Space.png"

#Installed UEFI grub support
apt-get install -y grub-efi-amd64

#Install offline apt support
apt-get install -y apt-offline

#Update the .img file pre-emptively for the snapshot
update-initramfs -u

#Clear out useless xfce4 folder
rm -rf /etc/xdg/xfce4

#Clear out useless Thundar folder
rm -rf /etc/xdg/Thundar

#Clean out the archive space of debian packages to free up disk space
apt-get clean

#Reboot so the changes take effect
reboot