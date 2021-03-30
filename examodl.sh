#!/bin/bash
# This script download the init part of the video
# wget -O mpddl https://github.com/munishgaurav5/st/raw/master/examodl.sh
# chmod 777 mpddl
# mv mpddl /usr/local/bin/

#Inputs
kid=$1
   while [[ $kid = "" ]]; do # to be replaced with regex
       read -p "Enter KID: " kid
    done

mediatype=$2
   while [[ $mediatype = "" ]]; do # to be replaced with regex
       read -p "Enter Media type (audio,video): " mediatype
    done

#######################################################

#Audio inputs
initurl=$3
   while [[ $initurl = "" ]]; do # to be replaced with regex
       read -p "Enter init url: " initurl
    done

fronturl=$4
   while [[ $fronturl = "" ]]; do # to be replaced with regex
       read -p "Enter fronturl: " fronturl
    done

backurl=$5
   while [[ $backurl = "" ]]; do # to be replaced with regex
       read -p "Enter backurl: " backurl
    done

startno=$6
   while [[ $startno = "" ]]; do # to be replaced with regex
       read -p "Enter startno: " startno
    done

endno=$7
   while [[ $endno = "" ]]; do # to be replaced with regex
       read -p "Enter endno: " endno
    done


#######################################################

mkdir -p ./files/$kid/
cd ./files/$kid/

#######################################################

echo -e "-----------------------------\n"
echo -e "----- Downloading Parts -----\n"
echo -e "-----------------------------\n"

#cd audio

# Create seg directory to store seg files
if [ -d "$mediatype" ]
then
        rm -rf $mediatype/*
else
    mkdir $mediatype
    cd $mediatype
fi

# Download the init segment
echo -e "----------------------\n"
echo -e "Download the init segment"
#read -p "Please provide the url to the init file: " url
if [ -z $initurl ]
then
    echo "Skip init download."
else
    wget -O init.mp4 $initurl
fi

echo -e "----------------------\n"
echo -e "Now we download the segments, please provide the url in the form of front and back"
#read -p "link_front: " front
#read -p "link_back: " back
#read -p "start_num: " start_num
#read -p "end_num: " end_num

# Skip downloading step if all are empty
if [ -z $fronturl ] && [ -z $backurl ] && [ -z $startno ] && [ -z $endno ]
then
    echo "Skipping segs downloading."
else
    for i in $(seq $startno $endno); do
        wget -O seg-$i.m4s $fronturl$i$backurl
    done
fi

echo -e "----------------------\n"
echo -e "Combining into target"
#read -p "target name: " target

combine_command=`ls -vx seg-*.m4s`
cat init.mp4 $combine_command > ./../$mediatype_e.mp4

echo -e "-----------------------------\n"
echo -e "------------ DONE -----------\n"
echo -e "-----------------------------\n"


