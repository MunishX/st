#!/bin/bash

rm -rf /etc/lighttpd/lighttpd.old
rm -rf /etc/lighttpd/conf.d/fastcgi.old
rm -rf /etc/lighttpd/modules.old

mv  /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.old
mv /etc/lighttpd/conf.d/fastcgi.conf /etc/lighttpd/conf.d/fastcgi.old
mv /etc/lighttpd/modules.conf /etc/lighttpd/modules.old

#### LIGHTTPD CONFIG
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/ligcnf -O /etc/lighttpd/lighttpd.conf

#### FASTCGI CONFIG
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/fgicnf -O /etc/lighttpd/conf.d/fastcgi.conf

#### CGI CONFIG
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/cgi -O /etc/lighttpd/conf.d/cgi.conf

#### MODULES CONFIG
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/modcnf -O /etc/lighttpd/modules.conf

