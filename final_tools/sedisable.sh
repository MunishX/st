#!/bin/bash

yum install sudo sed -y
sudo sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config

echo "SE DISABLED Successfully..."

# sudo shutdown -r now
