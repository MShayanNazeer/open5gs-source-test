#!/bin/bash

#n this script should be run as root
# print every command
set -x

# load configs 
source /local/repository/scripts/setup-config

### Enable IPv4/IPv6 Forwarding
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.ip_nonlocal_bind=1
#echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
#sysctl -p /etc/sysctl.conf

# # disable kernel sctp for now
# # modprobe -rf sctp

# ### Add NAT Rule
# # Probably need to change these values?
# # sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
# # sudo ip6tables -t nat -A POSTROUTING -s 2001:230:cafe::/48 ! -o ogstun -j MASQUERADE

# #install mongosh

# # Import the MongoDB GPG key
# wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -

# # Add the MongoDB repository
# echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

# # Update the package list
# sudo apt-get update

# # Install MongoDB Shell
# sudo apt-get install -y mongodb-mongosh
# export PATH="/usr/bin/mongosh:$PATH"


# # install open5gs
# apt -y update
# apt -y install software-properties-common
# add-apt-repository ppa:open5gs/latest
# apt -y update
# apt -y install npm open5gs # might have to press enter here

sudo apt-get update

sudo apt-get install -y gnupg wget curl

# install mongoDb
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt update

#Failing installation of Mongodb? Follow this https://askubuntu.com/questions/1403619/mongodb-install-fails-on-ubuntu-22-04-depends-on-libssl1-1-but-it-is-not-insta

#MongoDB 6.0 is now installable from mongodb repositories on Jammy, without requiring libssl1.1 Original answer

#MongoDb has no official build for ubuntu 22.04 at the moment.

#Ubuntu 22.04 has upgraded libssl to 3 and does not propose libssl1.1

#You can force the installation of libssl1.1 by adding the ubuntu 20.04 source:

echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list

sudo apt-get update && sudo apt-get install libssl1.1 

#Then delete the focal-security list file you just created:

sudo rm /etc/apt/sources.list.d/focal-security.list

apt install -y mongodb-org mongodb-org-database

systemctl start mongod

systemctl enable mongod

#Install NodeJs

sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update && sudo apt-get install nodejs -y

# curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# sudo apt install nodejs

#Install Open5GS

add-apt-repository ppa:open5gs/latest

apt-get install -y software-properties-common

apt-get -y update && apt install -y open5gs

#Install the webui

curl -fsSL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -



echo Now install Open5GS Web UI

# # install open5gs web UI
# curl -sL https://deb.nodesource.com/setup_12.x | bash -
# apt -y install nodejs
# curl -sL https://open5gs.org/open5gs/assets/webui/install | bash -
# #curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# #curl -sL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -


# echo "Setup 4G/ 5G NSA Core"

# cp /local/repository/config/mme.yaml /etc/open5gs/mme.yaml
# cp /local/repository/config/sgwu.yaml /etc/open5gs/sgwu.yaml

# systemctl restart open5gs-mmed
# systemctl restart open5gs-sgwud

# echo "Setup 5G Core"

# cp /local/repository/config/amf.yaml /etc/open5gs/amf.yaml
# cp /local/repository/config/upf.yaml /etc/open5gs/upf.yaml

# replace_in_file() {
#     # $1 is string to find, $2 is string to replace, $3 is filename
#     sed -i "s/$1/$2/g" $3
# }

# # amf.yaml is templated at one spot where the dev interface is, since this changes between
# # POWDER builds. For now, do an easy variable injection with sed. If there grows to be
# # lots of templating we may want a more concrete solution.
# localiface=$(route | grep 10.10.1.0 | grep -o '[^ ]*$')
# replace_in_file {{local-interface}} $localiface /etc/open5gs/amf.yaml

# systemctl restart open5gs-amfd
# systemctl restart open5gs-upfd

# clone open5gs for dbctl script
cd /root
git clone https://github.com/open5gs/open5gs
cd open5gs/misc/db

# add default ue subscriber so user doesn't have to log into web ui
# opc="E8ED289DEBA952E4283B54E88E6183CA"
# upper=$(($NUM_UE_ - 1))
# for i in $(seq 0 $upper); do
#     newkey=$(printf "%0.s$i" {1..32}) # example: 33333333333333333333333333333333
#     ./open5gs-dbctl add 90170000000000$i $newkey $opc
# done                                              
