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

#Download vdev (woo hoo)
git clone https//github.com/jcnelson/vdev /Modules/vdev

#Move into the vdev directory so we can make it
cd /Modules/vdev

#Check make is installed
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' make|grep "install ok installed")

#It's not there, install and enable it
if [ "" == "$PKG_OK" ]; then
 	sudo apt-get --force-yes --yes install make
fi

#Make vdev
make -C vdevd

#Generate initramfs
make initramfs

#Update to vdev
make install-initscript