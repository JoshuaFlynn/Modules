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
 	apt-get --force-yes --yes install git
fi

#vdev's make requires gcc
apt-get install -y gcc

_user=$(logname)

#Download vdev (woo hoo)
git clone https://github.com/jcnelson/vdev "/home/$_user/Modules/vdev"

#Download the pstat library
git clone https://github.com/jcnelson/libpstat "/home/$_user/Modules/libpstat"

#Check make is installed so we can build the above packages
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' make|grep "install ok installed")

#It's not there, install and enable it
if [ "" == "$PKG_OK" ]; then
 	apt-get --force-yes --yes install make
fi

#Move into the libpstat library so we can make it
cd /Modules/libpstat

#Make it
make OS="LINUX"

#Install it
make install PREFIX=/ INCLUDE_PREFIX=/usr

#Move into the vdev directory so we can make it
cd "/home/$_user/Modules/vdev"

#Make vdev
make -C vdevd

#Install it
make -C vdevd install

#Generate initramfs
make initramfs

#Update to vdev
make install-initscript