#!/bin/bash
# keydb custom install

# cd /tmp && rm -rf keydb_install.sh  && wget https://github.com/munishgaurav5/st/raw/master/tools/keydb_install.sh && chmod 777 keydb_install.sh  && ./keydb_install.sh 

# install info https://docs.keydb.dev/docs/build/

#openssl 
#https://www.openssl.org/source/openssl-1.1.0.tar.gz

#export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/usr/local/lib64:/usr/lib64

keydb_suffix=$1
add_suffix=$1
if [[ $keydb_suffix == "" ]]; then
   while [[ $add_suffix = "" ]]; do # to be replaced with regex
       read -p "Add Suffix to KeyDB (like: keydb-suff) (y/n): " add_suffix
    done


  if [ $add_suffix != "n" ]; then
      while [[ $keydb_suffix = "" ]]; do # to be replaced with regex       
       read -p "Enter suffix for KeyDB (-suff) : " keydb_suffix
      done
  fi
fi

keydb_port=$2
   while [[ $keydb_port = "" ]]; do # to be replaced with regex
       read -p "Enter KeyDB port to be used.. (6379): " keydb_port
    done

save_db=$3
   while [[ $save_db = "" ]]; do # to be replaced with regex
       read -p "Make KeyDB save database automatically.. (y/n): " save_db
    done

keydb_bind_public=$4
   while [[ $keydb_bind_public = "" ]]; do # to be replaced with regex
       read -p "Make KeyDB available on Public IP (y/n): " keydb_bind_public
    done

#gcc 9 install
#yum install -y centos-release-scl
#yum install -y devtoolset-9

#export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/usr/local/lib64:/usr/lib64

# DELETE KEYDB
#ls /etc/systemd/system/keydb*
#systemctl stop keydb-fast
#systemctl disable keydb-fast

#ls /var/lib/keydb*
#rm -rf /var/lib/keydb-fast
#ls /etc/keydb*
#rm -rf /etc/keydb-fast
#ls /etc/systemd/system/keydb*
#rm -rf /etc/systemd/system/keydb-fast.service

#ls /usr/local/bin/keydb*
#rm -rf /usr/local/bin/{keydb*-fast}



#keydb_link=https://github.com/EQ-Alpha/KeyDB/archive/refs/tags/v6.2.1.zip
keydb_link=https://github.com/EQ-Alpha/KeyDB/archive/refs/tags/v6.2.2.zip

#keydb_suffix=-btc
#keydb_port=6379
#save_db=1

#sudo yum install libatomic -y 
#sudo apt install libatomic1 -y



sudo yum install -y scl-utils centos-release-scl
sudo yum install -y devtoolset-7 libuuid-devel
sudo source scl_source enable devtoolset-7
source scl_source enable devtoolset-7
sudo yum install -y openssl openssl-devel curl-devel devtoolset-7-libatomic-devel tcl tcl-devel git wget epel-release
sudo yum install -y tcltls libzstd


#sudo apt update
#sudo apt install nano wget curl 
#sudo apt install build-essential nasm autotools-dev autoconf libjemalloc-dev tcl tcl-dev uuid-dev libcurl4-openssl-dev git


cd /tmp
rm -rf KeyDB-* keydb.zip
wget -O keydb.zip ${keydb_link}
unzip keydb.zip
rm -rf keydb.zip
cd KeyDB-*/

if [[ $keydb_suffix != "" ]]; then
make PROG_SUFFIX=${keydb_suffix}
make install PROG_SUFFIX=${keydb_suffix}
else
make 
make install 
fi

# keydb-server_btc
# keydb-benchmark_btc
# keydb-cli_btc

groupadd keydb
adduser --system -g keydb --no-create-home keydb

mkdir -p /var/lib/keydb${keydb_suffix}
chown keydb: /var/lib/keydb${keydb_suffix}
chmod 770 /var/lib/keydb${keydb_suffix}

mkdir -p /var/log/keydb${keydb_suffix}
chown keydb: /var/log/keydb${keydb_suffix}
chmod 770 /var/log/keydb${keydb_suffix}

mkdir -p /var/run/keydb${keydb_suffix}
chown keydb: /var/run/keydb${keydb_suffix}
chmod 770 /var/run/keydb${keydb_suffix}

mkdir -p /etc/keydb${keydb_suffix}
cd /etc/keydb${keydb_suffix}/
wget -O keydb.conf https://github.com/munishgaurav5/st/raw/master/tools/files/kd.c
sed -i "s%___sfx___%${keydb_suffix}%" /etc/keydb${keydb_suffix}/keydb.conf
sed -i "s%___port___%${keydb_port}%" /etc/keydb${keydb_suffix}/keydb.conf

# port ___port___
# pid  ___sfx___
# dir ___sfx___

# # save ""
#bind 127.0.0.1 -::1

  if [ $save_db != "y" ]; then
     sed -i "s%^.*save \"\"%save \"\"%" /etc/keydb${keydb_suffix}/keydb.conf
  else
     sed -i "s%^.*save 3600 1%save 3600 1%" /etc/keydb${keydb_suffix}/keydb.conf
     sed -i "s%^.*save 300 100%save 300 100%" /etc/keydb${keydb_suffix}/keydb.conf
     sed -i "s%^.*save 60 10000%save 60 10000%" /etc/keydb${keydb_suffix}/keydb.conf
  fi

  if [ $keydb_bind_public != "n" ]; then
     sed -i "s%bind 127.0.0.1%bind 0.0.0.0%" /etc/keydb${keydb_suffix}/keydb.conf
  fi
  

cd /etc/systemd/system/
wget -O keydb${keydb_suffix}.service https://github.com/munishgaurav5/st/raw/master/tools/files/kd.s

sed -i "s%___sfx___%${keydb_suffix}%" /etc/systemd/system/keydb${keydb_suffix}.service
sed -i "s%___sfx___%${keydb_suffix}%" /etc/systemd/system/keydb${keydb_suffix}.service
sed -i "s%___sfx___%${keydb_suffix}%" /etc/systemd/system/keydb${keydb_suffix}.service

systemctl enable keydb${keydb_suffix}
systemctl start keydb${keydb_suffix}
sleep 3
systemctl status keydb${keydb_suffix}

systemctl daemon-reload

keydb-server${keydb_suffix} -v
