#!/bin/bash
# redis custom install

redis_link=https://github.com/redis/redis/archive/refs/tags/6.2.6.zip
redis_suffix=-btc

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

mkdir /etc/redis${redis_suffix}

