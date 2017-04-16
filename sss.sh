#!/bin/bash

#  yum install wget -y && cd /tmp && rm -rf sss.sh && wget http://185.63.254.20/sss.sh && chmod 777 sss.sh && ./sss.sh  
echo ""
echo "[1/10] SSS TEST SCRIPT - By MG"
echo ""
sleep 2

echo ""
echo "[2/10] Updating..."
echo ""
sleep 2

yum -y update

echo ""
echo "[3/10] Installing required Softwares..."
echo ""
sleep 2

#yum -y install nano wget curl net-tools lsof bzip2 zip unzip epel-release git sudo make cmake sed 
yum -y install nano wget curl net-tools zip unzip epel-release sudo

echo ""
echo "[4/10] Creating Test Folder at /tmp/sss_test "
echo ""
sleep 2

rm -rf /tmp/sss_test
mkdir -p /tmp/sss_test
cd /tmp/sss_test

echo ""
echo "[5/10] Downloading SSS APP ..."
echo ""
sleep 2

wget http://185.63.254.20/sss.zip
unzip sss.zip
rm -rf sss.zip
chmod -R 777 bin

echo ""
echo "[6/10] Downloading Test Video ..."
echo ""
sleep 2

wget http://trailers.divx.com/divx_prod/divx_plus_hd_showcase/BigBuckBunny_DivX_HD720p_ASP.divx 

echo ""
echo "[7/10] Showing Test Folder Contents ..."
echo ""
sleep 2

ls -al

echo ""
echo "[8/10] Running SSS APP ..."
echo ""
sleep 2

bin/sss -c 3 -r 3 -h 100 -T '' -o '.jpg' -k 000000 -j 90 -g 1 '' -F 'FFFFFF:10:'bin/arial.ttf':FFFFFF:000000:10' -f 'bin/arial.ttf' -b 0.60 -B 0.0 -C 6000 -D 8 -L '4:2' -E 0.0 'BigBuckBunny_DivX_HD720p_ASP.divx'

echo ""
echo "[9/10] Showing Test Folder Contents Again (it should have 1 .jpg file now )..."
echo ""
sleep 2

ls -al

echo ""
echo "[10/10] END !!!"
echo ""
sleep 2
exit 1
