#!/bin/bash

#rm -rf /etc/lighttpd/lighttpd.old
#rm -rf /etc/lighttpd/modules.old
#rm -rf /etc/lighttpd/conf.d/fastcgi.old
#rm -rf /etc/lighttpd/conf.d/cgi.old
#rm -rf /etc/lighttpd/conf.d/access_log.old
#rm -rf /etc/lighttpd/conf.d/geoip.old

rm -rf /etc/lighttpd/*.old
rm -rf /etc/lighttpd/conf.d/*.old

mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.old
mv /etc/lighttpd/modules.conf /etc/lighttpd/modules.old
mv /etc/lighttpd/conf.d/fastcgi.conf /etc/lighttpd/conf.d/fastcgi.old
mv /etc/lighttpd/conf.d/cgi.conf /etc/lighttpd/conf.d/cgi.old
mv /etc/lighttpd/conf.d/access_log.conf /etc/lighttpd/conf.d/access_log.old
#mv /etc/lighttpd/conf.d/geoip.conf /etc/lighttpd/conf.d/geoip.old

#### LIGHTTPD CONFIG
wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/ligcnf -O /etc/lighttpd/lighttpd.conf

#### MODULES CONFIG
wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/modcnf -O /etc/lighttpd/modules.conf

#### FASTCGI CONFIG
wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/fgicnf -O /etc/lighttpd/conf.d/fastcgi.conf

#### CGI CONFIG
wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/cgi -O /etc/lighttpd/conf.d/cgi.conf

#### ACCESS_LOG CONFIG
wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/alog -O /etc/lighttpd/conf.d/access_log.conf

#### GEO_IP CONFIG
#wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/gip -O /etc/lighttpd/conf.d/geoip.conf
