#!/bin/bash



####### INPUT VARIABLES

User_Name=$1
echo ""
   while [[ $User_Name = "" ]]; do # to be replaced with regex
       read -p "(1/4) Enter Username (user): " User_Name
    done
    
User_Pass=$2
echo ""
   while [[ $User_Pass = "" ]]; do # to be replaced with regex
       read -p "(2/4) $User_Name's Password (pass): " User_Pass
    done

DOMAIN_SUB_PART=$3
echo ""
   while [[ $DOMAIN_SUB_PART = "" ]]; do # to be replaced with regex
       read -p "(3/4) Sub-Domain Part (ignore for www, ex:host) : " DOMAIN_SUB_PART
    done

DOMAIN_MAIN_PART=$4
echo ""
   while [[ $DOMAIN_MAIN_PART = "" ]]; do # to be replaced with regex
       read -p "(4/4) Domain Name (domain.com): " DOMAIN_MAIN_PART
    done

#Restart_Lig=$5
#echo ""
#   while [[ $Restart_Lig = "" ]]; do # to be replaced with regex
#       read -p "(5/5) Reload Lighttpd (y/n): " Restart_Lig
#    done



Admin_User=admin 
#ADMIN_HTML=html

#------------------------------------------------------------------------------------
# Install LIG CONFIG 
#------------------------------------------------------------------------------------
Restart_Lig="y"
/usr/bin/addnewuser_create_vhost $User_Name $User_Pass $DOMAIN_SUB_PART $DOMAIN_MAIN_PART $Admin_User $Restart_Lig n n n

echo ""
echo ""
echo "10) LIG CONFIG  COMPLETED!"
echo ""
sleep 3


echo "END!!"
exit 1

#------------------------------------------------------------------------------------
# END
#------------------------------------------------------------------------------------
