#!/usr/bin/env bash
#composer install

yum -y install wget unzip

cd /tmp
rm -rf composer*
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
HASH="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

mkdir -p /home/admin/bin/
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php composer-setup.php --install-dir=/home/admin/bin --filename=composer
cd /tmp
rm -rf composer*
chown -R admin:admin /home/admin/bin/*
chmod 777 /home/admin/bin/*
composer -v

echo ""
echo "#### Composer DONE ####"
echo ""
