#!/bin/bash
#Version 1.0
#Assumes the target system it's being deployed on is Devuan Jessie

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

#tell git to change it's directory (we want it to drop the module files in the right place for copying purposes)

#Download the modules configuration system
cd "/home/$_user"; git clone https://github.com/JoshuaFlynn/Modules.git

#Delete the garbage files off the desktop
rm "/home/$_user/Desktop/_RELEASE_NOTES"
rm "/home/$_user/Desktop/SMALLER_FONTS.desktop"
rm "/home/$_user/Desktop/LARGER_FONTS.desktop"

#Navigate to the new directory
cd "/home/$_user/Modules"

#Transfer a copy of the sources.list file (which should be correctly configured)
cp  /etc/apt/sources.list /etc/apt/jessie-sources.list.bak
cp  "/home/$_user/Modules/Blueprints/HelperScripts/Replacements/jessie-sources.list" /etc/apt/sources.list

#Now we've updated the sources.list file to include everything, update our own cache
apt-get update

#GIMP is a nice program, but to trim off the fat, it has to go
apt-get purge -y gimp

#Get rid of bloat office packages
apt-get purge -y libreoffice
apt-get purge -y  libreoffice-base
apt-get purge -y  libreoffice-math
apt-get purge -y  libreoffice-calc
apt-get purge -y  libreoffice-writer
apt-get purge -y  libreoffice-bin
apt-get purge -y  libreoffice-draw
apt-get purge -y  libreoffice-impress

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

#Reinstall wicd, because for some reason this gets violently removed by one of the earlier libraries, but we actually need it
apt-get install -y wicd

#Finally, get rid of everything for realsies
apt-get autoremove -y

#Purge the usr/share folder containing the XFCE4 junk we no longer need, which isn't removed when XFCE goes
rm -rf "/usr/share/xfce4"

#Add the King Pigeon Background
mkdir -p "/usr/share/images/desktop-base/"
cp  "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/King-Pigeon-Space.png" /usr/share/images/desktop-base/

#Add the King Pigeon icon
mkdir -p "/usr/share/pixmaps"
cp  "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/King-Pigeon-Logo-Mini.png" /usr/share/pixmaps

#Set up the login screen's details
mkdir -p /etc/lightdm
cp  "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/lightdm-gtk-greeter.conf" /etc/lightdm

#Update the openbox rc file
mkdir -p "/home/$_user/.config/openbox/"
cp  "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/lxde-rc.xml" "/home/$_user/.config/openbox/"

#Copy over the menu logo
mkdir -p "/usr/share/lxde/images/"
cp  "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/King-Pigeon-Logo-Mini-Simple-2b-Menu.png" "/usr/share/lxde/images/"

#Copy over the panel configuration to make things look nice
mkdir -p "/home/$_user/.config/lxpanel/LXDE/panels/"
cp  "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/panel" "/home/$_user/.config/lxpanel/LXDE/panels/"

#Copy over the logout banner
mkdir -p "/usr/share/lxde/images/"
cp  "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/logout-banner.png" "/usr/share/lxde/images/"

#Copy over the background desktop setup
mkdir -p "/home/$_user/.config/pcmanfm/LXDE"
cp  "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/desktop-items-0.conf" "/home/$_user/.config/pcmanfm/LXDE"

#Installed UEFI grub support
apt-get install -y grub-efi-amd64

#Install offline apt support
apt-get install -y apt-offline

#Now to rip out the systemd surrogate
apt-get purge -y libsystemd0

#gnome-sushi
#gvfs
#gvfs-backends
#gvfs-daemons
#gvfs-fuse
#nautilus

#Clear out useless xfce4 folder
rm -rf /etc/xdg/xfce4

#Clear out useless Thundar folder
rm -rf /etc/xdg/Thundar

mkdir -p "/etc/apt/preferences.d"
cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/avoid-libsystemd0" "/etc/apt/preferences.d"
cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/avoid-systemd-container" "/etc/apt/preferences.d"
cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/avoid-libsystemd-dev" "/etc/apt/preferences.d"
cp "/home/$_user/Modules/Blueprints/King-Pigeon/Replacements/avoid-systemd-coredump" "/etc/apt/preferences.d"

#Clean out the archive space of debian packages to free up disk space
apt-get clean

#Clean out the removed packages fully
apt-get autoremove -y

#Update the .img file pre-emptively for the snapshot
update-initramfs -u

#Reboot so the changes take effect
reboot