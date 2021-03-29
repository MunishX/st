#!/bin/bash
# This script download the init part of the video

#Inputs
kid=$1
   while [[ $kid = "" ]]; do # to be replaced with regex
       read -p "Enter KID: " kid
    done

key=$2
   while [[ $key = "" ]]; do # to be replaced with regex
       read -p "Enter KEY: " key
    done

filename=$3
   while [[ $filename = "" ]]; do # to be replaced with regex
       read -p "Enter Final FileName: " filename
    done

#######################################################

#Audio inputs
ainiturl=$4
   while [[ $ainiturl = "" ]]; do # to be replaced with regex
       read -p "Enter audio init url: " ainiturl
    done

afronturl=$5
   while [[ $afronturl = "" ]]; do # to be replaced with regex
       read -p "Enter audio fronturl: " afronturl
    done

abackurl=$6
   while [[ $abackurl = "" ]]; do # to be replaced with regex
       read -p "Enter audio backurl: " abackurl
    done

astartno=$7
   while [[ $astartno = "" ]]; do # to be replaced with regex
       read -p "Enter audio startno: " astartno
    done

aendno=$8
   while [[ $aendno = "" ]]; do # to be replaced with regex
       read -p "Enter audio endno: " aendno
    done


######################################################
#Video inputs

viniturl=$9
   while [[ $viniturl = "" ]]; do # to be replaced with regex
       read -p "Enter video init url: " viniturl
    done

vfronturl=$10
   while [[ $vfronturl = "" ]]; do # to be replaced with regex
       read -p "Enter video fronturl: " vfronturl
    done

vbackurl=$11
   while [[ $vbackurl = "" ]]; do # to be replaced with regex
       read -p "Enter video backurl: " vbackurl
    done

vstartno=$12
   while [[ $vstartno = "" ]]; do # to be replaced with regex
       read -p "Enter video startno: " vstartno
    done

vendno=$13
   while [[ $vendno = "" ]]; do # to be replaced with regex
       read -p "Enter video endno: " vendno
    done


#######################################################

mkdir -p $kid/{audio,video}
cd $kid

#######################################################

echo -e "-----------------------------\n"
echo -e "--------- AUDIO -------------\n"
echo -e "-----------------------------\n"

cd audio

# Create seg directory to store seg files
if [ -d "seg" ]
then
        rm -rf seg/*
else
    mkdir seg
    cd seg
fi

# Download the init segment
echo -e "----------------------\n"
echo -e "Download the init segment"
#read -p "Please provide the url to the init file: " url
if [ -z $ainiturl ]
then
    echo "Skip init download."
else
    wget -O init.mp4 $ainiturl
fi

echo -e "----------------------\n"
echo -e "Now we download the segments, please provide the url in the form of front and back"
#read -p "link_front: " front
#read -p "link_back: " back
#read -p "start_num: " start_num
#read -p "end_num: " end_num

# Skip downloading step if all are empty
if [ -z $afronturl ] && [ -z $abackurl ] && [ -z $astartno ] && [ -z $aendno ]
then
    echo "Skipping segs downloading."
else
    for i in $(seq $astartno $aendno); do
        wget -O seg-$i.m4s $afronturl$i$abackurl
    done
fi

echo -e "----------------------\n"
echo -e "Combining into target"
#read -p "target name: " target

combine_command=`ls -vx seg-*.m4s`
cat init.mp4 $combine_command > ../$kid_audio.mp4

cd ./../
############################

echo -e "-----------------------------\n"
echo -e "--------- VIDEO -------------\n"
echo -e "-----------------------------\n"

cd video
#cd $kid/audio

# Create seg directory to store seg files
if [ -d "seg" ]
then
        rm -rf seg/*
else
    mkdir seg
    cd seg
fi

# Download the init segment
echo -e "-----------------------------\n"
echo -e "Download the init segment"
#read -p "Please provide the url to the init file: " url
if [ -z $viniturl ]
then
    echo "Skip init download."
else
    wget -O init.mp4 $viniturl
fi

echo -e "----------------------\n"
echo -e "Now we download the segments, please provide the url in the form of front and back"
#read -p "link_front: " front
#read -p "link_back: " back
#read -p "start_num: " start_num
#read -p "end_num: " end_num

# Skip downloading step if all are empty
if [ -z $vfronturl ] && [ -z $vbackurl ] && [ -z $vstartno ] && [ -z $vendno ]
then
    echo "Skipping segs downloading."
else
    for i in $(seq $vstartno $vendno); do
        wget -O seg-$i.m4s $vfronturl$i$vbackurl
    done
fi

echo -e "----------------------\n"
echo -e "Combining into target"
#read -p "target name: " target

combine_command=`ls -vx seg-*.m4s`
cat init.mp4 $combine_command > ../$kid_video.mp4

cd ./../

# https://stackoverflow.com/questions/23485759/combine-mpeg-dash-segments-ex-init-mp4-segments-m4s-back-to-a-full-source-m
# https://www.youtube.com/watch?v=8hiuDlrWBz0

##############################################
##############################################

echo -e "-----------------------------\n"
echo -e "------ Bento4 Decrypt -------\n"
echo -e "-----------------------------\n"

mp4decrypt --key $kid:$key $kid_audio.mp4 $kid_audio_decoded.mp4 
mp4decrypt --key $kid:$key $kid_video.mp4 $kid_video_decoded.mp4 

##########################################


echo -e "-----------------------------\n"
echo -e "--------- FFMPEG ------------\n"
echo -e "-----------------------------\n"

ffmpeg -i $kid_video_decoded.mp4  -i $kid_audio_decoded.mp4 -c copy -map 0:v:0 -map 1:a:0 ./../$filename.mp4
############################################

echo -e "-----------------------------\n"
echo -e "---------- DONE -------------\n"
echo -e "-----------------------------\n"

