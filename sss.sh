#!/bin/bash

#  yum install wget -y && cd /tmp && wget https://github.com/munishgaurav5/st/raw/master/sss.sh && chmod 777 sss.sh && ./sss.sh
echo "SSS TEST SCRIPT - By MG"
sleep 2

echo "Updating..."
sleep 2

yum -y update

echo "Installing required Softwares..."
sleep 2

#yum -y install nano wget curl net-tools lsof bzip2 zip unzip epel-release git sudo make cmake sed 
yum -y install nano wget curl net-tools zip unzip epel-release sudo

echo "Creating Test Folder at /tmp/sss_test "
sleep 2

rm -rf /tmp/sss_test
mkdir -p /tmp/sss_test
cd /tmp/sss_test

echo "Downloading SSS APP ..."
sleep 2

wget http://185.63.254.20/sss.zip
unzip sss.zip
rm -rf sss.zip
chmod -R 777 bin

echo "Downloading Test Video ..."
sleep 2

wget http://trailers.divx.com/divx_prod/divx_plus_hd_showcase/BigBuckBunny_DivX_HD720p_ASP.divx 

echo "Showing Test Folder Contents ..."
sleep 2

ls -al

echo "Running SSS APP ..."
sleep 2

bin/sss -c 3 -r 3 -h 100 -T '' -o '.jpg' -k 000000 -j 90 -g 1 '' -F 'FFFFFF:10:'bin/arial.ttf':FFFFFF:000000:10' -f 'bin/arial.ttf' -b 0.60 -B 0.0 -C 6000 -D 8 -L '4:2' -E 0.0 'BigBuckBunny_DivX_HD720p_ASP.divx'

echo "Showing Test Folder Contents Again (it should have 1 .jpg file now )..."
sleep 2

ls -al

echo ""
echo "END !!!"
sleep 2
exit 1
