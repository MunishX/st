#!/bin/bash

rm -rf /etc/lighttpd/*.old
rm -rf /etc/lighttpd/conf.d/*.old

mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.old
mv /etc/lighttpd/modules.conf /etc/lighttpd/modules.old
mv /etc/lighttpd/conf.d/fastcgi.conf /etc/lighttpd/conf.d/fastcgi.old
mv /etc/lighttpd/conf.d/cgi.conf /etc/lighttpd/conf.d/cgi.old
mv /etc/lighttpd/conf.d/access_log.conf /etc/lighttpd/conf.d/access_log.old
#mv /etc/lighttpd/conf.d/geoip.conf /etc/lighttpd/conf.d/geoip.old

#### LIGHTTPD CONFIG
wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/replace/09_replace_ligcnf -O /etc/lighttpd/lighttpd.conf

#### MODULES CONFIG
wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/replace/09_replace_modcnf -O /etc/lighttpd/modules.conf

#### FASTCGI CONFIG
wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/replace/09_replace_fgicnf -O /etc/lighttpd/conf.d/fastcgi.conf

#### CGI CONFIG
wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/replace/09_replace_cgi -O /etc/lighttpd/conf.d/cgi.conf

#### ACCESS_LOG CONFIG
wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/replace/09_replace_alog -O /etc/lighttpd/conf.d/access_log.conf

#### GEO_IP CONFIG
#wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/replace/09_replace_gip -O /etc/lighttpd/conf.d/geoip.conf
