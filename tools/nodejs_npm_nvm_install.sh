#!/bin/sh

# cd /tmp && rm -rf node.sh && wget -O node.sh https://github.com/MunishX/st/raw/master/tools/nodejs_npm_nvm_install.sh && chmod 777 node.sh && ./node.sh 

cd /tmp
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
source ~/.bashrc
nvm --version

nvm install node

node --version

# nvm install 14
# nvm install 16
# nvm install 18
# nvm install 20

# nvm uninstall 20

# nvm use 18
# node --version

# nvm alias default 20 // to keep this version active even after restart/reboot server

