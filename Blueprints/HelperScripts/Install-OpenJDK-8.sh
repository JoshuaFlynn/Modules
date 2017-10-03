#!/bin/bash
#Version 1.0

#Install the source code binary maker
apt-get install -y make

#Install the java source code repository system
apt-get install -y mercurial

#Install required packages
apt-get install -y libXtst-dev libXt-dev libXrender-dev libcups2-dev libasound2-dev libxft-dev libisfreetype-java ccache

#Clone the required JDK8 from the source code repository
hg clone http://hg.openjdk.java.net/jdk8/jdk8/

#Move into the JDK8 directory
cd jdk8

#Run the 'get source' script
bash get_source.sh

#Required for configure
apt-get install -y unzip zip openjdk-7-jdk libfreetype6-dev

#Create a symlink for freetype so configure doesn't puke on itself trying to find it
ln -s /usr/include/freetype2/ft2build.h /usr/include/
ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so* /usr/lib/

#Configure it
bash configure

#Unset the variables
unset CLASSPATH
unset JAVA_HOME

#Copy over a supposed hotfix
cp "/home/$_user/Modules/Blueprints/HelperScripts/Replacements/adjust-mflags.sh" "/hotspot/make/linux/makefiles/"

#Construct it
make all

#Move into the binary directory
cd ./build/linux-x86_64-normal-server-release/images/j2sdk-image/bin


