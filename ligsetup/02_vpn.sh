#!/bin/bash

## GET IP
#IPADDR=$(ip a s eth0 |grep "inet "|awk '{print $2}'| awk -F '/' '{print $1}')
IPADDR="$(hostname -I)"

yum -y update
yum -y install git zip unzip curl nano sudo wget
yum -y install nano wget curl net-tools lsof bzip2 zip unzip rar unrar epel-release 
yum -y groupinstall "Development Tools"
yum -y update


sudo tee -a /etc/yum.repos.d/mongodb-org-3.2.repo << EOF
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
EOF

sudo tee -a /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Repository
baseurl=http://repo.pritunl.com/stable/yum/centos/7/
gpgcheck=1
enabled=1
EOF




sudo yum -y install epel-release
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp


sudo yum -y install pritunl mongodb-org
sudo systemctl start mongod pritunl
sudo systemctl enable mongod pritunl
sudo systemctl status mongod pritunl

echo ""
echo ""
echo "SETUP KEY : "

OUTPUT="$(pritunl setup-key)"
echo "${OUTPUT}"


echo ""
echo ""
echo " TIPS : Select text to 'Copy' Text! "
echo ""
#echo -e "VISIT https://$IPADDR/ and Setup VPN. Then Press 'Y' to continue. : \c "
TEMP_INPUT=''

   while [[ $TEMP_INPUT = "" ]]; do # to be replaced with regex       
       read -p "VISIT https://$IPADDR/ and Setup VPN. Then Press 'Y' to continue. :  " TEMP_INPUT
       #$MAIN_IP
    done

sudo sh -c 'echo "* hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* soft nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root soft nofile 64000" >> /etc/security/limits.conf'

pritunl set app.server_port 789
pritunl set app.redirect_server false

systemctl restart pritunl
systemctl status pritunl

# yum -y install wget && cd /tmp && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/vpn.sh && chmod 777 vpn.sh && ./vpn.sh
