#!/bin/bash

POSTFIX_HASH=''
#DKIM_SELECTOR=$2


   while [[ $POSTFIX_HASH = "" ]]; do # to be replaced with regex
        read -p "ENTER POSTFIX ADMIN HASH: " POSTFIX_HASH
    done

	
    echo "Working..."
sleep 3

echo "\$CONF['setup_password'] = '$POSTFIX_HASH';" >> /var/www/html/postfixadmin/config.inc.php
echo 'Location : /var/www/html/postfixadmin/config.inc.php'
echo '...'

echo 'PostFixAdmin Configured!'

echo '#################  DONE  ######################'

