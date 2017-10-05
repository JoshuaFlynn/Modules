#!/bin/bash
#Version 1.0

#Do a sudo/root level check
uid=$(id -u)

#We don't have root permissions, so we can't install or upgrade anything, so we quit
[ $uid -ne 0 ] && { echo "Only root may run this Module installation package."; exit 1; }

_user=$(logname)

#run our first update
apt-get update

#gcc is required to make
#Make required to, err, make the packages
#fstik requires pthread (pthread packages), fuse.h (found in the libfuse-dev library)
#libfskit requires the xattr heads, which are found under libattr1-dev
bash "/home/$_user/Modules/Blueprints/HelperScripts/Bash-Install.sh" gcc make libfuse-dev libattr1-dev libevent-pthreads-2.0-5 libevent-pthreads-2.0-5 libpthread-stubs0-dev libpthread-workqueue0

#Download the pstat library (used by vdev)
bash "/home/$_user/Modules/Blueprints/HelperScripts/Download-Github.sh" https://github.com/jcnelson/libpstat "/home/$_user/Modules" libpstat

#Download the fskit (optional dependency used by vdev)
bash "/home/$_user/Modules/Blueprints/HelperScripts/Download-Github.sh" https://github.com/jcnelson/fskit "/home/$_user/Modules" fskit

#Download vdev (woo hoo)
bash "/home/$_user/Modules/Blueprints/HelperScripts/Download-Github.sh" https://github.com/jcnelson/vdev "/home/$_user/Modules" vdev

#============
# Make libfskit
#============

cd "/home/$_user/Modules/fskit"

#Make it
make PREFIX=/usr/local

#Install it
make install PREFIX=/usr/local

#Build libfskit_fuse
make -C fuse/ PREFIX=/usr/local

#Install it
make -C fuse/ install PREFIX=/usr/local

#===============
# Make libpstat
#===============

#Move into the libpstat library so we can make it
cd "/home/$_user/Modules/libpstat"

#Make it
make OS="LINUX"

#Install it
make install PREFIX=/ INCLUDE_PREFIX=/usr

#==========
# Make vdev
#==========

#Move into the vdev directory so we can make it
cd "/home/$_user/Modules/vdev"

#Make vdev
make -C vdevd OS="LINUX"

#Install it
make -C vdevd install

#Make vdevd's hardware database
make -C hwdb

#Install it
make -C hwdb install

#Make vdev udev compatibility
make -C libudev-compat

#Install vdev udev compatibility
make -C libudev-compat install DESTDIR= PREFIX= INCLUDE_PREFIX=/usr

#Make vdevfs
make -C fs

#Install vdevfs
make -C fs install

#Generate initramfs
make initramfs

#Update to vdev
make install-initscript