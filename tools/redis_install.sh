#!/bin/bash
# redis custom install

# cd /tmp && rm -rf redis_install.sh  && wget https://github.com/munishgaurav5/st/raw/master/tools/redis_install.sh && chmod 777 redis_install.sh  && ./redis_install.sh 

redis_suffix=$1
add_suffix=$1
if [[ $redis_suffix == "" ]]; then
   while [[ $add_suffix = "" ]]; do # to be replaced with regex
       read -p "Add Suffix to Redis (like: redis-suff) (y/n): " add_suffix
    done


  if [ $add_suffix != "n" ]; then
      while [[ $redis_suffix = "" ]]; do # to be replaced with regex       
       read -p "Enter suffix for Redis (-suff) : " redis_suffix
      done
  fi
fi

redis_port=$2
   while [[ $redis_port = "" ]]; do # to be replaced with regex
       read -p "Enter Redis port to be used.. (6379): " redis_port
    done

save_db=$3
   while [[ $save_db = "" ]]; do # to be replaced with regex
       read -p "Make Redis save database automatically.. (y/n): " save_db
    done

redis_bind_public=$4
   while [[ $redis_bind_public = "" ]]; do # to be replaced with regex
       read -p "Make Redis available on Public IP (y/n): " redis_bind_public
    done



redis_link=https://github.com/redis/redis/archive/refs/tags/6.2.6.zip
#redis_suffix=-btc
#redis_port=6379
#save_db=1

cd /tmp
rm -rf redis-* redis.zip
wget -O redis.zip ${redis_link}
unzip redis.zip
rm -rf redis.zip
cd redis-*/

make PROG_SUFFIX=-btc
make install PROG_SUFFIX=-btc

# redis-server_btc
# redis-benchmark_btc
# redis-cli_btc

groupadd redis
adduser --system -g redis --no-create-home redis

mkdir -p /var/lib/redis${redis_suffix}
chown redis: /var/lib/redis${redis_suffix}
chmod 770 /var/lib/redis${redis_suffix}

mkdir -p /etc/redis${redis_suffix}
cd /etc/redis${redis_suffix}/
wget -O redis.conf https://github.com/munishgaurav5/st/raw/master/tools/files/rd.c
sed -i "s%___sfx___%${redis_suffix}%" /etc/redis${redis_suffix}/redis.conf
sed -i "s%___port___%${redis_port}%" /etc/redis${redis_suffix}/redis.conf

# port ___port___
# pid  ___sfx___
# dir ___sfx___

# # save ""
#bind 127.0.0.1 -::1

  if [ $save_db != "y" ]; then
     sed -i "s%^.*save \"\"%save \"\"%" /etc/redis${redis_suffix}/redis.conf
  fi

  if [ $redis_bind_public != "n" ]; then
     sed -i "s%bind 127.0.0.1%bind 0.0.0.0%" /etc/redis${redis_suffix}/redis.conf
  fi
  

cd /etc/systemd/system/
wget -O redis${redis_suffix}.service https://github.com/munishgaurav5/st/raw/master/tools/files/rd.s
#___sfx___
sed -i "s%___sfx___%${redis_suffix}%" /etc/systemd/system/redis${redis_suffix}.service

systemctl enable redis${redis_suffix}
systemctl start redis${redis_suffix}
sleep 3
systemctl status redis${redis_suffix}

redis-server${redis_suffix} -v

