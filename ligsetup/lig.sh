#!/bin/bash

### install lighttpd

systemctl stop httpd.service
systemctl disable httpd.service
yum -y remove httpd



yum -y install epel-release
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
yum -y update
yum -y install lighttpd
yum -y install lighttpd-fastcgi

mkdir -p /etc/lighttpd/enabled/
