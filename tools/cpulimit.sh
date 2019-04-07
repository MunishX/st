#!/bin/bash
# cpulimit install

yum -y install zip unzip

cd /tmp
rm -rf cpulimit*
wget -O cpulimit.zip https://github.com/opsengine/cpulimit/archive/v0.2.zip
unzip cpulimit.zip
cd cpulimit*/
make
mv src/cpulimit /usr/local/bin/
cd /tmp
rm -rf cpulimit*

cpulimit -v

echo ""
echo "#### FINISH ####"
echo ""

