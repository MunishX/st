#!/bin/bash
echo "MAINTAINER XYZ"
sleep 2

#######################################




#
#
############# time required approx . 25 mins
#
#
############# FFMPEG INSTALLER  (FOR CENTOS 6,7) [Fresh OS Required] ###########
#
#
#
#

cd /tmp
yum -y update
yum -y install nano wget curl net-tools lsof bzip2 zip unzip rar unrar
yum -y install glibc gcc gcc-c++ autoconf automake libtool git make nasm pkgconfig SDL-devel a52dec a52dec-devel 
yum -y install alsa-lib-devel faac faac-devel faad2 faad2-devel freetype-devel giflib gsm gsm-devel 
yum -y install imlib2 imlib2-devel lame lame-devel libICE-devel libSM-devel libX11-devel libXau-devel 
yum -y install libXdmcp-devel libXext-devel libXrandr-devel libXrender-devel libXt-devel libogg libvorbis
yum -y install vorbis-tools mesa-libGL-devel mesa-libGLU-devel xorg-x11-proto-devel zlib-devel libtheora
yum -y install theora-tools ncurses-devel libdc1394 libdc1394-devel amrnb-devel amrwb-devel opencore-amr-devel
yum -y install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel
yum -y install libass-devel libass

mkdir -p /usr/src /usr/tmp

export TMPDIR=/usr/tmp
export PATH="/usr/bin:$PATH"
export C_INCLUDE_PATH="/usr/include:$C_INCLUDE_PATH"
export LIBRARY_PATH="/usr/lib:$LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

###########################################################
# yasm 1.3.0
# original: http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
###########################################################
cd /usr/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/yasm-1.3.0.tar.gz'
tar -xf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix=/usr
make
make install

###########################################################
# lame 3.99.5
# original: http://sourceforge.net/projects/lame/files/lame/3.99/lame-3.99.5.tar.gz/download
###########################################################
cd /usr/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/lame-3.99.5.tar.gz'
tar -xf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix=/usr
make
make install

###########################################################
# libogg 1.3.2
# original: http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
###########################################################
cd /usr/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/libogg-1.3.2.tar.gz'
tar -xf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix=/usr
make
make install

###########################################################
# libvorbis 1.3.5
# original: http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
###########################################################
cd /usr/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/libvorbis-1.3.5.tar.gz'
tar -xf libvorbis-1.3.5.tar.gz
cd libvorbis-1.3.5
./configure --prefix=/usr
make
make install

###########################################################
# libtheora 1.1.1
# original: http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
###########################################################
cd /usr/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/libtheora-1.1.1.tar.gz'
tar -xf libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix=/usr
make
make install

###########################################################
# libvpx @ d6996849f0c65b97c40318647c3e7dc2db332861
# original: https://chromium.googlesource.com/webm/libvpx
###########################################################
cd /usr/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/libvpx-d6996849.tar.gz'
tar -xf libvpx-d6996849.tar.gz
cd libvpx-d6996849
./configure --prefix=/usr --enable-pic --enable-shared
make
make install

###########################################################
# faac 1.28
# original: http://downloads.sourceforge.net/faac/faac-1.28.tar.gz
###########################################################
cd /usr/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/faac-1.28.tar.gz'
tar -xf faac-1.28.tar.gz
cd faac-1.28

# fix programming error
sed -i '126d' ./common/mp4v2/mpeg4ip.h

./configure --prefix=/usr
make
make install

###########################################################
# libx264 @ a01e33913655f983df7a4d64b0a4178abb1eb618
# original: git://git.videolan.org/x264.git
###########################################################
cd /usr/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/x264-a01e3391.tar.gz'
tar -xf x264-a01e3391.tar.gz
cd x264-a01e3391
./configure --prefix=/usr --enable-static --enable-shared
make
make install

###########################################################
# libxvid 1.3.4
# original: http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz
###########################################################
cd /usr/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/xvidcore-1.3.4.tar.gz'
tar -xf xvidcore-1.3.4.tar.gz
cd xvidcore/build/generic
./configure --prefix=/usr
make
make install


###########################################################
# EXTRA @ xyz 1 // -> opus
# original: git://source.ffmpeg.org/ffmpeg.git
###########################################################
cd /usr/src
git clone https://git.opus-codec.org/opus.git 
cd opus
autoreconf -fiv
./configure --prefix="/usr" --enable-shared
make
make install
####

###########################################################
# EXTRA @ xyz 2 // -> x265
# original: git://source.ffmpeg.org/ffmpeg.git
###########################################################
cd /usr/src
hg clone https://bitbucket.org/multicoreware/x265
cd x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/usr" -DENABLE_SHARED:bool=off ../../source
make
make install
####

###########################################################
# EXTRA @ xyz 3 // -> fdk-aac
# original: git://source.ffmpeg.org/ffmpeg.git
###########################################################
cd /usr/src
git clone --depth 1 https://github.com/Distrotech/fdk-aac.git  
cd fdk-aac
autoreconf -fiv
./configure --prefix="/usr" --enable-shared
make
make install
####

###########################################################
#                      new openjpeg
###########################################################
#cd /usr/src
#wget http://openjpeg.googlecode.com/files/openjpeg-1.5.0.tar.gz
#tar -xf openjpeg-1.5.0.tar.gz
#cd openjpeg 
#./configure
#make
#sudo make install
###########################################################

###########################################################
#                     new ffplay
###########################################################
#cd /usr/src
#wget http://www.libsdl.org/release/SDL-1.2.15.tar.gz
#tar -xf SDL-1.2.15.tar.gz
#cd sdl
#./configure
#make
#sudo make install
###########################################################
## for ass and subtitle filter
## yum -y install libass-devel libass
## --enable-libass

###########################################################
# FFMPEG @ 9079e99d2c462ec7ef2e89d9e77ee6c3553dacce
# original: git://source.ffmpeg.org/ffmpeg.git
###########################################################
cd /usr/src
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg

PKG_CONFIG_PATH="/usr/lib/pkgconfig" ./configure --prefix=/usr --libdir=/usr/lib \
--bindir="/usr/bin" --pkg-config-flags="--static" \
--incdir=/usr/include --enable-libfaac --enable-libx264 --enable-libxvid --enable-avfilter \
--enable-nonfree --enable-gpl --enable-libmp3lame --enable-pthreads --enable-libvpx \
--enable-libvorbis --disable-mmx --enable-shared --enable-libtheora \
--enable-libfdk-aac --enable-libx265 --enable-libfreetype --enable-libopus \
--pkg-config=pkg-config --enable-libass --enable-version3 --enable-pic \
--extra-cflags="-I/usr/include" --extra-ldflags="-L/usr/lib"

make
make install

export PATH="/usr/bin:$PATH"
export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"


###########################################################
# EXTRA @ FIX Permission of FFMPEG
# original: git://source.ffmpeg.org/ffmpeg.git
###########################################################
cd /usr/src

echo "/usr/lib" >> /etc/ld.so.conf
echo "/usr/local/lib" >> /etc/ld.so.conf
echo "/root/lib" >> /etc/ld.so.conf
echo "/root/local/lib" >> /etc/ld.so.conf

ldconfig

cd /tmp
ffmpeg

echo ""
echo ""
echo ""
echo "################### FFMPEG INSTALL END ####################"
echo ""
echo ""


