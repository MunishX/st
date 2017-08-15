#!/bin/bash

My_PORT=$1

   while [[ $My_PORT = "" ]]; do # to be replaced with regex
       read -p "Enter New SSH Port: " My_PORT
    done


############## SSH POrt Change #############

echo "Port $My_PORT" >> /etc/ssh/sshd_config
service sshd restart


firewall-cmd --permanent --zone=public --add-port=$My_PORT/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-all

############################################

