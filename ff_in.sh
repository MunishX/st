#!/usr/bin/env bash




###### VARS #####
PreFix_Dir=/usr

#################



# A Linux Shell Script for compiling and installing ffmpeg in CentOS (tested on 6).
# This script based on ffmpeg guide <http://ffmpeg.org/trac/ffmpeg/wiki/CentosCompilationGuide>
# This script is licensed under GNU GPL version 3.0 or above.


#Remove any existing packages:
sudo yum -y erase ffmpeg x264 x264-devel

#Get the dependencies
sudo yum -y install autoconf automake gcc gcc-c++ git libtool make nasm pkgconfig zlib-devel




mkdir -p $PreFix_Dir/{src,bin,lib,include,tmp}

export TMPDIR=$PreFix_Dir/tmp
export PATH="$PreFix_Dir/bin:$PATH"
export C_INCLUDE_PATH="$PreFix_Dir/include:$C_INCLUDE_PATH"
export LIBRARY_PATH="$PreFix_Dir/lib:$LIBRARY_PATH"
export LD_LIBRARY_PATH="$PreFix_Dir/lib:$LD_LIBRARY_PATH"

########

cd /tmp
yum -y update
yum -y install nano wget curl net-tools lsof bzip2 zip unzip rar unrar git sed epel-release
yum -y install glibc gcc gcc-c++ autoconf automake libtool git make nasm pkgconfig SDL-devel a52dec a52dec-devel 
yum -y install alsa-lib-devel faac faac-devel faad2 faad2-devel freetype-devel giflib gsm gsm-devel 
yum -y install imlib2 imlib2-devel lame lame-devel libICE-devel libSM-devel libX11-devel libXau-devel 
yum -y install libXdmcp-devel libXext-devel libXrandr-devel libXrender-devel libXt-devel libogg libvorbis
yum -y install vorbis-tools mesa-libGL-devel mesa-libGLU-devel xorg-x11-proto-devel zlib-devel libtheora
yum -y install theora-tools ncurses-devel libdc1394 libdc1394-devel amrnb-devel amrwb-devel opencore-amr-devel
yum -y install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel
yum -y install libass-devel libass


###########################################################
# yasm 1.3.0
# original: http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
###########################################################

# install Yasm
cd $PreFix_Dir/src
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar xzvf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix="$PreFix_Dir" --bindir="$PreFix_Dir/bin"
make
make install
make distclean
. ~/.bash_profile


###########################################################
# lame 3.99.5
# original: http://sourceforge.net/projects/lame/files/lame/3.99/lame-3.99.5.tar.gz/download
###########################################################

# install libmp3lame
cd $PreFix_Dir/src
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$PreFix_Dir" --bindir="$PreFix_Dir/bin"  --enable-nasm
make
make install
make distclean


###########################################################
# libogg 1.3.2
# original: http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
###########################################################
# install libogg
cd $PreFix_Dir/src
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz
tar xzvf libogg-1.3.1.tar.gz
cd libogg-1.3.1
./configure --prefix="$PreFix_Dir" 
make
make install
make distclean


###########################################################
# libvorbis 1.3.5
# original: http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
###########################################################

# install libvorbis
cd $PreFix_Dir/src
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.gz
tar xzvf libvorbis-1.3.3.tar.gz
cd libvorbis-1.3.3
./configure --prefix="$PreFix_Dir" --with-ogg="$PreFix_Dir" 
make
make install
make distclean


###########################################################
# libtheora 1.1.1
# original: http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
###########################################################


# install libtheora
cd $PreFix_Dir/src
wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
tar xzvf libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix="$PreFix_Dir" 
make 
make install

###########################################################
# libvpx @ d6996849f0c65b97c40318647c3e7dc2db332861
# original: https://chromium.googlesource.com/webm/libvpx
###########################################################

# install libvpx
cd $PreFix_Dir/src
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure  --prefix="$PreFix_Dir" --enable-pic --enable-shared
make
make install
make clean

###########################################################
# libx264 @ a01e33913655f983df7a4d64b0a4178abb1eb618
# original: git://git.videolan.org/x264.git
###########################################################

# install x264
cd $PreFix_Dir/src
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --prefix="$PreFix_Dir" --bindir="$PreFix_Dir/bin" --enable-static --enable-shared
make
make install
make distclean


###########################################################
# libxvid 1.3.4
# original: http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz
###########################################################
cd $PreFix_Dir/src
wget 'http://mirror.ryansanden.com/ffmpeg-9079e99d/xvidcore-1.3.4.tar.gz'
tar -xf xvidcore-1.3.4.tar.gz
cd xvidcore/build/generic
./configure --prefix="$PreFix_Dir"
make
make install



###########################################################
# EXTRA @ xyz 1 // -> opus
# original: git://source.ffmpeg.org/ffmpeg.git
###########################################################

# install libopus
cd $PreFix_Dir/src
curl -O http://downloads.xiph.org/releases/opus/opus-1.0.3.tar.gz
tar xzvf opus-1.0.3.tar.gz
cd opus-1.0.3
./configure --prefix="$PreFix_Dir" --enable-shared
make
make install
make distclean

####

###########################################################
# EXTRA @ xyz 2 // -> x265
# original: git://source.ffmpeg.org/ffmpeg.git
###########################################################
cd $PreFix_Dir/src
hg clone https://bitbucket.org/multicoreware/x265
cd x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PreFix_Dir" -DENABLE_SHARED:bool=off ../../source
make
make install
####


###########################################################
# EXTRA @ xyz 3 // -> fdk-aac
# original: git://source.ffmpeg.org/ffmpeg.git
###########################################################

# install libfdk_aac
cd $PreFix_Dir/src
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$PreFix_Dir" --enable-shared
make
make install
make distclean


###########################################################


###########################################################
# FFMPEG @ 9079e99d2c462ec7ef2e89d9e77ee6c3553dacce
# original: git://source.ffmpeg.org/ffmpeg.git
###########################################################
# install FFmpeg
cd $PreFix_Dir/src
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg

PKG_CONFIG_PATH="/usr/lib/pkgconfig" 
export PKG_CONFIG_PATH

./configure --prefix="$PreFix_Dir" --libdir="$PreFix_Dir/lib" \
--bindir="$PreFix_Dir/bin" --pkg-config-flags="--static" \
--incdir=$PreFix_Dir/include --enable-libx264 --enable-libxvid --enable-avfilter \
--enable-nonfree --enable-gpl --enable-libmp3lame --enable-pthreads --enable-libvpx \
--enable-libvorbis --disable-mmx --enable-shared --enable-libtheora \
--enable-libfdk-aac --enable-libx265 --enable-libfreetype --enable-libopus \
--pkg-config=pkg-config --enable-libass --enable-version3 --enable-pic \
--extra-cflags="-I$PreFix_Dir/include" --extra-ldflags="-L$PreFix_Dir/lib"


#PKG_CONFIG_PATH="$PreFix_Dir/lib/pkgconfig"
#export PKG_CONFIG_PATH
#./configure --prefix="$PreFix_Dir" --extra-cflags="-I$PreFix_Dir/include" --extra-ldflags="-L$PreFix_Dir/lib" --bindir="$PreFix_Dir/bin" \
# --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libmp3lame --enable-libopus --enable-libvorbis \
# --enable-libvpx --enable-libx264 \
 #--enable-libxvid --enable-libtheora --incdir=$PreFix_Dir/include  --enable-libfreetype  --enable-libx265 --libdir=$PreFix_Dir/lib \
 #--enable-libass --pkg-config=pkg-config 
 #--enable-version3 --enable-pic --pkg-config-flags="--static" --enable-pthreads  --enable-avfilter
 
 
make
make install
make distclean
hash -r
. ~/.bash_profile
export PATH="$PreFix_Dir/bin:$PATH"
export LD_LIBRARY_PATH="$PreFix_Dir/lib:$LD_LIBRARY_PATH"





#   --enable-avfilter \
#--enable-pthreads  \
 #--disable-mmx --enable-shared  \

# --enable-version3 --enable-pic \
# --pkg-config-flags="--static" 



cd $PreFix_Dir/src

echo "$PreFix_Dir/lib" >> /etc/ld.so.conf
echo "$PreFix_Dir/local/lib" >> /etc/ld.so.conf
echo "/root/lib" >> /etc/ld.so.conf
echo "/root/local/lib" >> /etc/ld.so.conf

ldconfig


echo ""
echo ""

cd /tmp
ffmpeg

echo ""
echo ""
echo ""
echo "################### FFMPEG INSTALL END ####################"
echo ""
echo ""






