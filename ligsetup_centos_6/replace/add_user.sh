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

mydom=$3
   while [[ $mydom = "" ]]; do # to be replaced with regex
       read -p "(3/6) $User_Name's Domain: " mydom
    done

Install_Torrent=$4
echo ""
   while [[ $Install_Torrent = "" ]]; do # to be replaced with regex
       read -p "(4/6) INSTALL Torrent (y/n): " Install_Torrent
    done

if [ $Install_Torrent = "y" ]; then
   
   Torrent_Port=$5
   echo ""
   while [[ $Torrent_Port = "" ]]; do # to be replaced with regex
       read -p "(5/6) Torrent Port (9091): " Torrent_Port
    done
  
fi

Restart_Lig=$6
echo ""
   while [[ $Restart_Lig = "" ]]; do # to be replaced with regex
       read -p "(6/6) Restart Lighttpd (y/n): " Restart_Lig
    done

# Admin_User=$6
# echo ""
#   while [[ $Admin_User = "" ]]; do # to be replaced with regex
#       read -p "(5/9) Admin Username: " Admin_User
#   done


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

wget https://github.com/munishgaurav5/st/raw/master/ligsetup_centos_6/10_create_vhost.sh
chmod 777 10_create_vhost.sh
./10_create_vhost.sh $User_Name $User_Pass $mydom $Admin_User $Restart_Lig

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
wget https://github.com/munishgaurav5/st/raw/master/ligsetup_centos_6/12_tmm.sh
chmod 777 12_tmm.sh 
./12_tmm.sh $User_Name $User_Pass $Torrent_Port $mydom $Admin_User $old_user_true

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
