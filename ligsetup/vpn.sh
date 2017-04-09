#!/bin/bash
## https://github.com/munishgaurav5/install-golang-all
## Install Golang 1.7.4 64Bits on all Linux (Debian|Ubuntu|OpenSUSE|CentOS)
## Run as root | (sudo su)
## curl https://raw.githubusercontent.com/munishgaurav5/install-golang-all/master/install.sh 2>/dev/null | bash


GO_URL="https://storage.googleapis.com/golang"
GO_VERSION=${1:-"1.7.4"}
GO_FILE="go$GO_VERSION.linux-amd64.tar.gz"


# Check if user has root privileges
if [[ $EUID -ne 0 ]]; then
echo "You must run the script as root or using sudo"
   exit 1
fi


GET_OS=$(cat /etc/os-release | head -n1 | cut -d'=' -f2 | awk '{ print tolower($1) }'| tr -d '"')

if [[ $GET_OS == 'debian' || $GET_OS == 'ubuntu' ]]; then
   apt-get update
   apt-get install wget git-core
fi

if [[ $GET_OS == 'opensuse' ]]; then
   zypper in -y wget git-core
fi

if [[ $GET_OS == 'centos' ]]; then
   yum install wget git-core
fi


cd /tmp
wget --no-check-certificate ${GO_URL}/${GO_FILE}
tar -xzf ${GO_FILE}
mv go /usr/local/go


echo 'export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/GO
export PATH=$PATH:$GOPATH/bin' >> /etc/profile

sleep 3
 
source /etc/profile
mkdir -p $HOME/GO

## Test if Golang is working
go version

echo 'Golang Installation Complete' 
### The output is this:
## go version go1.7 linux/amd64
