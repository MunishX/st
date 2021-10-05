#!/bin/bash

yum install sed -y
sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config

echo "SE DISABLED Successfully..."
