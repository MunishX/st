#!/bin/bash

### MEMCACHED CONFIG
yum -y install memcached 

echo '
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="1024"
OPTIONS="-l 127.0.0.1,::1"
' > /etc/sysconfig/memcached


### REDIS / Valkey 
# (Redis available till Rocky 9)
# yum -y install redis 

yum -y install valkey
valkey-server --version

#systemctl enable valkey # --now
systemctl start valkey
systemctl status valkey

systemctl is-active valkey
systemctl is-enabled valkey
valkey-cli ping

systemctl stop valkey
#####


