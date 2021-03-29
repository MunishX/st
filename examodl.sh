#!/bin/bash
# This script download the init part of the video

#inputs
uname=$1
   while [[ $uname = "" ]]; do # to be replaced with regex
       read -p "VHost username: " uname
    done

passw=$2
   while [[ $passw = "" ]]; do # to be replaced with regex
       read -p "$uname's Password: " passw
    done

mydom=$3
   while [[ $mydom = "" ]]; do # to be replaced with regex
       read -p "$uname's Domain: " mydom
    done




# Create seg directory to store seg files
if [ -d "seg" ]
then
    read -p "Do you wish to remove the files in seg folder?[Y/n]" folder
    if [[ $folder = "y" ]] || [[ $folder = "Y" ]] || [ -z $folder ]
    then
        rm -rf seg/*
    fi
    cd seg
else
    mkdir seg
    cd seg
fi

# Download the init segment
echo -e "----------------------\n"
echo -e "Download the init segment"
read -p "Please provide the url to the init file: " url
if [ -z $url ]
then
    echo "Skip init download."
else
    wget -O init.mp4 $url
fi

echo -e "----------------------\n"
echo -e "Now we download the segments, please provide the url in the form of front and back"
read -p "link_front: " front
read -p "link_back: " back
read -p "start_num: " start_num
read -p "end_num: " end_num

# Skip downloading step if all are empty
if [ -z $front ] && [ -z $back ] && [ -z $start_num ] && [ -z $end_num ]
then
    echo "Skipping segs downloading."
else
    for i in $(seq $start_num $end_num); do
        wget -O seg-$i.m4s $front$i$back
    done
fi

echo -e "----------------------\n"
echo -e "Combining into target"
read -p "target name: " target

combine_command=`ls -vx seg-*.m4s`
cat init.mp4 $combine_command > ../$target.mp4

# https://stackoverflow.com/questions/23485759/combine-mpeg-dash-segments-ex-init-mp4-segments-m4s-back-to-a-full-source-m
# https://www.youtube.com/watch?v=8hiuDlrWBz0
