#!/bin/bash



####### INPUT VARIABLES

User_Name=$1
echo ""
   while [[ $User_Name = "" ]]; do # to be replaced with regex
       read -p "(1/6) Enter Username (user): " User_Name
    done
    
User_Pass=$2
echo ""
   while [[ $User_Pass = "" ]]; do # to be replaced with regex
       read -p "(2/6) $User_Name's Password (pass): " User_Pass
    done

DOMAIN_SUB_PART=$3
echo ""
   while [[ $DOMAIN_SUB_PART = "" ]]; do # to be replaced with regex
       read -p "Sub-Domain Part (ignore for www, ex:host) : " DOMAIN_SUB_PART
    done

DOMAIN_MAIN_PART=$4
echo ""
   while [[ $DOMAIN_MAIN_PART = "" ]]; do # to be replaced with regex
       read -p "Domain Name (domain.com): " DOMAIN_MAIN_PART
    done

Install_Torrent=$5
echo ""
   while [[ $Install_Torrent = "" ]]; do # to be replaced with regex
       read -p "(4/6) INSTALL Torrent (y/n): " Install_Torrent
    done

if [ $Install_Torrent = "y" ]; then
   
   Torrent_Port=$6
   echo ""
   while [[ $Torrent_Port = "" ]]; do # to be replaced with regex
       read -p "(5/6) Torrent Port (9091): " Torrent_Port
    done
  
fi

Restart_Lig=$7
echo ""
   while [[ $Restart_Lig = "" ]]; do # to be replaced with regex
       read -p "(6/6) Reload Lighttpd (y/n): " Restart_Lig
    done



Admin_User=admin 
ADMIN_HTML=html

### UMASK FIX FOR ROOT ###
echo ""
echo "UMASK FIX ..."
umask
umask 0002
umask
echo ""
sleep 6
#########################

rm -rf /tmp/add_user_script
mkdir -p /tmp/add_user_script
cd /tmp/add_user_script

#------------------------------------------------------------------------------------
# Install LIG CONFIG 
#------------------------------------------------------------------------------------
#restart_no=y

#wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/10_create_vhost.sh
#chmod 777 10_create_vhost.sh
#./10_create_vhost.sh $User_Name $User_Pass $DOMAIN_SUB_PART $DOMAIN_MAIN_PART $Admin_User $Restart_Lig n n n
/usr/bin/addnewuser_create_vhost $User_Name $User_Pass $DOMAIN_SUB_PART $DOMAIN_MAIN_PART $Admin_User $Restart_Lig n n n

echo ""
echo ""
echo "10) LIG CONFIG  COMPLETED!"
echo ""
sleep 10

#while [[ $Continue_do != "y" ]]; do # to be replaced with regex       
#       read -p "Press y to continue (y/n) : " Continue_do
#       #$MAIN_IP
#    done



#------------------------------------------------------------------------------------
# Install Torrent
#------------------------------------------------------------------------------------

if [[ $Install_Torrent = "y" ]]; then

old_user_true=y
#wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/12_tmm.sh
#chmod 777 12_tmm.sh 
#./12_tmm.sh $User_Name $User_Pass $Torrent_Port $DOMAIN_SUB_PART.$DOMAIN_MAIN_PART $Admin_User $old_user_true
/usr/bin/addnewuser_tmm $User_Name $User_Pass $Torrent_Port $DOMAIN_SUB_PART.$DOMAIN_MAIN_PART $Admin_User $old_user_true

echo ""
echo ""
echo "12) Torrent COMPLETED!"
echo ""

else
echo ""
echo ""
echo "12) SKIPPING Torrent!"
echo ""
fi


sleep 10



echo "END!!"
exit 1

#------------------------------------------------------------------------------------
# END
#------------------------------------------------------------------------------------
