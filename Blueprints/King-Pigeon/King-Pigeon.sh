#run our first update
apt-get update

#Straight away enable security
apt-get install -y ufw
ufw enable

apt-get install -y git
