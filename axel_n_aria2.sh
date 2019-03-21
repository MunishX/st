yum -y install wget curl nano bzip2 zip unzip fontconfig gcc 


## axel
cd /tmp
rm -rf axel*
wget https://github.com/axel-download-accelerator/axel/releases/download/v2.16.1/axel-2.16.1.tar.gz
tar xzvf axel-2.16.1.tar.gz
rm -rf axel-2.16.1.tar.gz
cd axel-*/
./configure
make
make install


## aria2
cd /tmp
rm -rf aria2*
wget https://github.com/q3aql/aria2-static-builds/releases/download/v1.34.0/aria2-1.34.0-linux-gnu-64bit-build1.tar.bz2
tar jxvf aria2-*.tar.bz2
rm -rf jxvf aria2-*.tar.bz2
cd aria2-*/
make PREFIX=/usr/local



echo ""
echo "############ FINISHED ################"
echo ""

axel -V
aria2c -v
