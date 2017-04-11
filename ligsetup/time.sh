## TIME UTC 

 timedatectl  status
 timedatectl set-timezone UTC
 timedatectl  status
 
# date -s '2017-04-02 20:43:30'

## sudo apt install -y ntp
#yum -y install ntp   
#systemctl start ntpd
#systemctl enable ntpd

## for centos 7 time updator
yum install -y chrony
systemctl start chronyd
systemctl enable chronyd

##
#timedatectl set-local-rtc 0

firewall-cmd --add-service=ntp --permanent 
firewall-cmd --reload 

chronyc sources 
timedatectl  status
