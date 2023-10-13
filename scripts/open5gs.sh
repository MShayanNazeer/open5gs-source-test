#set -x

# load configs 
source /local/repository/scripts/setup-config

### Enable IPv4/IPv6 Forwarding
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.ip_nonlocal_bind=1

# sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE

if [ -f $SRCDIR/open5gs-setup-complete ]; then
    echo "setup already ran; not running again"
    exit 0
fi

sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:open5gs/latest

# sudo add-apt-repository -y ppa:wireshark-dev/stable
# echo "wireshark-common wireshark-common/install-setuid boolean false" | sudo debconf-set-selections

#installing MongoDB

sudo apt update
sudo apt-get install gnupg
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
apt-key list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt update
sudo apt install mongodb-org mongodb-mongosh
sudo systemctl start mongod.service
sudo systemctl status mongod
sudo systemctl enable mongod
mongo --eval 'db.runCommand({ connectionStatus: 1 })'

#installing Open5gs
sudo apt update
sudo apt install open5gs

#installing NodeJS for webUI

cd ~
curl -sL https://deb.nodesource.com/setup_17.x -o /tmp/nodesource_setup.sh
nano /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install nodejs
node -v
npm -v
sudo apt install build-essential
sudo apt update

git clone https://github.com/open5gs/open5gs
cd open5gs/webui
npm ci
# npm run dev


# curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
#     sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
# echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | \
#     sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
# sudo apt update
# sudo apt install -y \
#     mongodb-org \
#     mongodb-mongosh \
#     iperf3 \
#     tshark \
#     wireshark


# sudo apt install -y open5gs
# sudo cp /local/repository/etc/open5gs/* /etc/open5gs/

sudo systemctl restart open5gs-mmed
sudo systemctl restart open5gs-sgwcd
sudo systemctl restart open5gs-smfd
sudo systemctl restart open5gs-amfd
sudo systemctl restart open5gs-sgwud
sudo systemctl restart open5gs-upfd
sudo systemctl restart open5gs-hssd
sudo systemctl restart open5gs-pcrfd
sudo systemctl restart open5gs-nrfd
sudo systemctl restart open5gs-ausfd
sudo systemctl restart open5gs-udmd
sudo systemctl restart open5gs-pcfd
sudo systemctl restart open5gs-nssfd
sudo systemctl restart open5gs-bsfd
sudo systemctl restart open5gs-udrd

# cd $SRCDIR
# wget https://raw.githubusercontent.com/open5gs/open5gs/main/misc/db/open5gs-dbctl
# chmod +x open5gs-dbctl
# ./open5gs-dbctl add_ue_with_apn 901700123456789 00112233445566778899aabbccddeeff 63BFA50EE6523365FF14C1F45F88737D srsapn  # IMSI,K,OPC
# ./open5gs-dbctl type 901700123456789 1  # APN type IPV4
# touch $SRCDIR/open5gs-setup-complete


# clone open5gs for dbctl script
cd /root
git clone https://github.com/open5gs/open5gs
cd open5gs/misc/db

#add default ue subscriber so user doesn't have to log into web ui
opc="E8ED289DEBA952E4283B54E88E6183CA"
upper=$(($NUM_UE_ - 1))
for i in $(seq 0 $upper); do
    newkey=$(printf "%0.s$i" {1..32}) # example: 33333333333333333333333333333333
    ./open5gs-dbctl add 99970000000000$i $newkey $opc
done                                              

#./open5gs-dbctl add 999700000000001 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA
