#!/bin/bash
#Version 1.0

_user=$(logname)

#If no arguments are supplied, it's presumed the JoshuaFlynn Modules github itself is required for self-deployment
if (( $# == 0 )); then

bash ./Download-Github.sh https://github.com/JoshuaFlynn/Modules "/home/$_user/" Modules

exit 0;

elif (( $# != 3 )); 
then

echo "Download-Github.sh takes three arguments which are:"
echo "Github URL"
echo "Target directory (to deploy the files into)"
echo "Repository name"
echo "E.G.:"
echo "bash ./Download-Github.sh https://github.com/JoshuaFlynn/Modules /home/user Modules"
exit 2;

else

#Do a sudo/root level check
uid=$(id -u)

#We don't have root permissions, so we can't install or upgrade anything, so we quit
[ $uid -ne 0 ] && { echo "Only root may run this Blueprint installation package."; exit 1; }

#Check for curl so we can pull down from github
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' curl|grep "install ok installed")

#It's not there, install and enable it
if [ "" == "$PKG_OK" ]; then
 	apt-get --force-yes --yes install curl
fi

#Check for unzip so we can extract the files
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' unzip|grep "install ok installed")

#It's not there, install and enable it
if [ "" == "$PKG_OK" ]; then
 	apt-get --force-yes --yes install unzip
fi

GITHUB_ZIP_SOURCE=$1
TARGET_DIR=$2
REPO_NAME=$3

#https://github.com/JoshuaFlynn/Modules/archive/master.zip

#Make the target directory (in the rare instance it doesn't actually exist)
mkdir -p "$TARGET_DIR"

#Download the git via the get .zip button and feed it into a zip file
curl -L "$GITHUB_ZIP_SOURCE/archive/master.zip" > "$TARGET_DIR/Temp_Github.zip"

#Extract it to destination
unzip "$TARGET_DIR/Temp_Github.zip" -d "$TARGET_DIR"

#Rename the folder (to get rid of the '-master' part)
mv "$TARGET_DIR/$REPO_NAME-master" "$TARGET_DIR/$REPO_NAME"

#Give the regular user permissions to delete the folder and files (-R is recursive)
chown -R "$_user" "$TARGET_DIR/$REPO_NAME"

#Get rid of the .zip file now our task is complete
rm "$TARGET_DIR/Temp_Github.zip"

exit 0;

fi

