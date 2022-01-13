#!/bin/bash
# plesk mssql extension installer

# command
# chmod 777 plesk_php_mssql_extension_installer.sh && ./plesk_php_mssql_extension_installer.sh

echo ""
echo ""
echo "==============================="
echo "Plesk MSSQL Extension Installer"
echo "==============================="
echo ""

php_v=$1
   while [[ $php_v = "" ]]; do # to be replaced with regex
       read -p "Enter PHP version (8.0 or 8.1): " php_v
    done


path_mod_start=/opt/plesk/php/
path_mod_end=/lib/php/modules/

if [ -d ${path_mod_start}${php_v}${path_mod_end} ] 
then
    echo "Plesk PHP ${php_v} Installtion found.." 
else
    echo "Error: PHP ${php_v} installation not found...."
    exit
fi

file_pdo_start=php_pdo_sqlsrv_
file_sql_start=php_sqlsrv_
file_end=_nts.so

arrV=(${php_v//./ })
#echo ${arrV[1]}   


if [ -f ${path_mod_start}${php_v}${path_mod_end}${file_sql_start}${arrV[0]}${arrV[1]}${file_end} ] 
then
    echo ""
    echo "MSSQL Extention for PHP ${php_v} already installed... Skipping installation.."

else
    #echo "Error: PHP ${php_v} installation not found...."
    #exit
    echo ""




echo "Installing PHP ${php_v} MSSQL Extension.. Please Wait.." 
url_link_start=https://github.com/microsoft/msphpsql/releases/download/v5.10.0-beta2/Ubuntu2004-
url_link_end=.tar

cd /tmp
rm -rf php_ext_tar.tar Ubuntu2004*
wget -O php_ext_tar.tar ${url_link_start}${php_v}${url_link_end}
tar xvf php_ext_tar.tar

cd Ubuntu2004*/

cp ${file_pdo_start}${arrV[0]}${arrV[1]}${file_end}   ${path_mod_start}${php_v}${path_mod_end}
cp ${file_sql_start}${arrV[0]}${arrV[1]}${file_end}   ${path_mod_start}${php_v}${path_mod_end}

rm -rf Ubuntu2004* php_ext_tar.tar

sleep 3



echo ""
echo "Done!!"
echo ""
echo "PHP Extention Installed Successfully.."
fi

echo ""
echo "Please add the below 'extension=' lines to 'Additional configuration directives' available at bottom of PLESK PHP settings page..
echo "Plesk PHP Setting page url: ( https://92.205.24.229:8443/smb/web/php-settings/id/1 ) (add below 2 lines).."
echo ""
echo "extension=${file_pdo_start}${arrV[0]}${arrV[1]}${file_end}"
echo "extension=${file_pdo_start}${arrV[0]}${arrV[1]}${file_end}"
echo ""
echo ""

