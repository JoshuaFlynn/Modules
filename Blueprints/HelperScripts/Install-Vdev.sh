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

#Commands sourced from the Arch.git package build

#Make all of the required kit
make PREFIX=/usr -C vdevd OS="LINUX"
make PREFIX=/usr -C hwdb
make PREFIX=/usr -C fs
make PREFIX=/usr -C libudev-compat

#Install it all
make -C vdevd PREFIX='/usr' ETCDIR='/etc' BINDIR='/usr/bin' SBINDIR='/usr/bin' install
make -C example PREFIX='/usr' ETCDIR='/etc' RUNDIR='/run' LOGDIR='/var/log' 	install
make PREFIX=/usr -C hwdb install
make -C fs PREFIX='/usr' SBINDIR='/usr/bin' install
make -C libudev-compat PREFIX=/usr install

#Backup copy the libudev.so files
cp /lib/libudev.so.1 /lib/libudev.so.1.bak
cp /lib/libudev.so.1.5.2 /lib/libudev.so.1.5.2.bak

#Copy over the updated ones
cp "/home/$_user/Modules/vdev/build/lib/libudev.so.1" /lib/libudev.so.1
cp "/home/$_user/Modules/vdev/build/lib/libudev.so.1.5.2" /lib/libudev.so.1.5.2

