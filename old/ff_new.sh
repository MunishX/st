#!/usr/bin/env bash

## MG New

# cd /tmp && rm -rf ff_* && wget https://github.com/munishgaurav5/st/raw/master/ff_new.sh && chmod 777 ff_new.sh && ./ff_new.sh
# cd /tmp && rm -rf ff_* && wget https://github.com/munishgaurav5/st/raw/master/ff_new.sh && chmod 777 ff_new.sh && nohup ./ff_new.sh > ff_log.txt &

# cd /tmp && yum install wget -y && rm -rf ff_* && wget https://github.com/munishgaurav5/st/raw/master/ff_new.sh && chmod 777 ff_new.sh 
# ./ff_new.sh > ffnew.txt 2>&1 &
# watch -n 2 tail -n 30 ffnew.txt



#ref https://github.com/ka che rga/ffm peg-inst all/blob/master/bu ild-ffm peg

start_time=`date +%s`

###### VARS #####
#PreFix_Dir="/usr/local"

#PreFix_Dir="/usr/local/ffmpeg_build"

Root_Dir="/usr/local"

FF_Source="$Root_Dir/ffmpeg_sources"
FF_Build="$Root_Dir/ffmpeg_build"
PreFix_Dir="$FF_Build"

Lib_Dir="$FF_Build/lib"
Bin_Dir="$FF_Build/bin"

Include_Dir="$PreFix_Dir/include"
Pkg_Dir="$PreFix_Dir/pkg"
Root_Bin="$Root_Dir/bin"

#PATH="$PreFix_Dir/bin:$PATH" 
#################

# Remove any existing packages
#yum -y erase ffmpeg x264 x264-devel
yum -y install zip unzip nano wget curl git yum-utils openssl-devel

# Install the dependencies
yum-config-manager --add-repo http://www.nasm.us/nasm.repo
yum -y install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel

# Make a directory for FFmpeg sources
rm -rf $FF_Source $FF_Build
mkdir -p $FF_Source
mkdir -p $FF_Build


# Install Yasm
cd $FF_Source
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install x264
cd $FF_Source
git clone --depth 1 git://git.videolan.org/x264
cd x264
PKG_CONFIG_PATH="$Pkg_Dir" 
./configure --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install x265
cd $FF_Source
hg clone https://bitbucket.org/multicoreware/x265
cd x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PreFix_Dir" -DCMAKE_BINARY_DIR="$Bin_Dir" -DLIB_INSTALL_DIR="$Lib_Dir" -DENABLE_SHARED:bool=off ../../source
make
make install
make distclean
source ~/.bash_profile

# Install libfdk_aac
cd $FF_Source
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
yum install libtool -y
libtoolize
autoreconf -fiv
./configure --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install libmp3lame
cd $FF_Source
#curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
curl -L -O http://download.videolan.org/pub/contrib/lame/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --enable-nasm --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static 
make
make install
make distclean
source ~/.bash_profile

# Install libopus
cd $FF_Source
#curl -O https://archive.mozilla.org/pub/opus/opus-1.1.5.tar.gz
#tar xzvf opus-1.1.5.tar.gz
#cd opus-1.1.5
curl -O https://archive.mozilla.org/pub/opus/opus-1.2.tar.gz
tar xzvf opus-1.*.tar.gz
cd opus-1.*/
./configure --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install libogg
cd $FF_Source
#curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
#curl -O http://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.2.tar.gz
#tar xzvf libogg-1.3.2.tar.gz
#cd libogg-1.3.2
curl -O http://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.3.tar.gz
tar xzvf libogg-1.*.tar.gz
cd libogg-1.*/
./configure --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile
#yum -y install libogg


# Install libvpx
cd $FF_Source
# git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
wget -O libvpx_v1.7.0.zip https://github.com/webmproject/libvpx/archive/v1.7.0.zip
unzip libvpx_v1.7.0.zip

cd libvpx*/
./configure  --as=yasm --enable-pic --disable-examples --disable-unit-tests --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
#PATH="$PreFix_Dir/bin:$PATH" 
make
make install
make distclean
source ~/.bash_profile
#yum -y install libvpx

######################## New #########################
## Install librtmp
cd $FF_Source
#wget -O librtmp.zip https://github.com/pexip/librtmp/archive/master.zip
#unzip librtmp.zip
#cd librtmp-master
#./autogen.sh
#./configure --prefix="$PreFix_Dir/ffmpeg_build" --disable-shared --enable-static
#make
#make install
#make distclean
#source ~/.bash_profile

#LD_LIBRARY_PATH=/usr/local/lib:/usr/local/ffmpeg_build/lib && export LD_LIBRARY_PATH

git clone --depth 1 http://git.ffmpeg.org/rtmpdump.git librtmp
cd librtmp
make -j 1 SYS=posix prefix="$PreFix_Dir" CRYPTO=OPENSSL SHARED= XCFLAGS="-I$Include_Dir" XLDFLAGS="-L$Lib_Dir" install


# Install VID.STAB
#https://github.com/georgmartius/vid.stab/
cd $FF_Source
wget -O vid_stab.zip https://github.com/georgmartius/vid.stab/archive/master.zip
unzip vid_stab.zip

cd vid.stab-master
cmake -DCMAKE_INSTALL_PREFIX="$PreFix_Dir" -DCMAKE_BINARY_DIR="$Bin_Dir" -DLIB_INSTALL_DIR="$Lib_Dir" -DENABLE_SHARED:bool=off -PKG_CONFIG_PATH="$Pkg_Dir" .
make
make install
make distclean
source ~/.bash_profile

#mv $PreFix_Dir/ffmpeg_build/lib64/pkgconfig/* $PreFix_Dir/ffmpeg_build/lib/pkgconfig/
#rm -rf $PreFix_Dir/ffmpeg_build/lib64/pkgconfig/
#mv $PreFix_Dir/ffmpeg_build/lib64/* $PreFix_Dir/ffmpeg_build/lib/
#rm -rf $PreFix_Dir/ffmpeg_build/lib64/

##Install Openjpeg
#cd $FF_Source
#wget -O openjpeg-v2.3.0.zip https://github.com/uclouvain/openjpeg/archive/v2.3.0.zip
#unzip openjpeg-v2.3.0.zip
#cd openjpeg-2.3.0
#mkdir build
#cd build
#cmake .. -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PreFix_Dir" -DCMAKE_BINARY_DIR="$Bin_Dir" -DLIB_INSTALL_DIR="$Lib_Dir" -DENABLE_SHARED:bool=off -PKG_CONFIG_PATH="$Pkg_Dir"
#cmake -DCMAKE_INSTALL_PREFIX:PATH="$PreFix_Dir/ffmpeg_build" -DBUILD_SHARED_LIBS:bool=off .
#make
#make install
#make distclean
#source ~/.bash_profile

#Install Opencore arm
cd $FF_Source
# https://sourceforge.net/projects/opencore-amr/files/
wget http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz
tar xzvf opencore-amr-0.1.5.tar.gz
cd opencore-amr-0.1.5
./configure --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile


# XvidCore
cd $FF_Source
# https://labs.xvid.com/source/
wget https://downloads.xvid.com/downloads/xvidcore-1.3.5.zip
unzip xvidcore-1.3.5.zip
cd xvidcore/build/generic/
./configure --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile



#####################################################

# Install libvorbis
cd $FF_Source
#curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
#curl -O http://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.5.tar.gz
#tar xzvf libvorbis-1.3.4.tar.gz
#cd libvorbis-1.3.4
#tar xzvf libvorbis-1.3.5.tar.gz
#cd libvorbis-1.3.5
curl -O http://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.6.tar.gz
tar xzvf libvorbis-1*.tar.gz
cd libvorbis-1*/
PKG_CONFIG_PATH="$Pkg_Dir" 
./configure --with-ogg-libraries="$Lib_Dir" --with-ogg-includes="$Include_Dir" --disable-oggtest --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile
#yum -y install libvorbis

# Install libtheora
 # https://ftp.osuosl.org/pub/xiph/releases/theora/
cd $FF_Source
 wget https://ftp.osuosl.org/pub/xiph/releases/theora/libtheora-1.1.1.zip
 unzip libtheora-1.1.1.zip
 cd libtheora-1.1.1
 ./configure  --with-ogg-libraries="$Lib_Dir" --with-ogg-includes="$Include_Dir" --with-vorbis-libraries="$Lib_Dir" --with-vorbis-includes="$Include_Dir" --disable-oggtest --disable-vorbistest --disable-examples --disable-asm --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static
 make
 make install
 make distclean
 source ~/.bash_profile
#yum -y install libtheora


#FreeType2
cd $FF_Source
# http://download.savannah.gnu.org/releases/freetype/
wget http://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2

tar -xf freetype-2.9.1.tar.bz2 freetype-2.9.1
cd freetype-2.9.1
./configure --enable-freetype-config --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static

make
make install
make distclean
source ~/.bash_profile


# Install FFmpeg
cd $FF_Source

#wget https://github.com/FFmpeg/FFmpeg/archive/n3.4.zip
#unzip n3.*.zip
#cd FFmpeg-n3.*
curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg*/

#curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
#tar xjvf ffmpeg-snapshot.tar.bz2
#cd ffmpeg
#--enable-libopenjpeg 
PKG_CONFIG_PATH="$Pkg_Dir" 
./configure --prefix="$PreFix_Dir" --bindir="$Bin_Dir" --libdir="$Lib_Dir" --disable-shared --enable-static --extra-libs=-lpthread  --extra-cflags="-I$Include_Dir" --extra-ldflags="-L$Lib_Dir -ldl" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-filters --enable-libvidstab --enable-libvidstab --enable-libopencore_amrwb --enable-libopencore_amrnb  --enable-libxvid --enable-libtheora --enable-version3 --enable-librtmp 
make
make install
hash -r

make distclean
source ~/.bash_profile

#chmod 777 $PreFix_Dir/bin


end_time=`date +%s`
run_time=$((end_time-start_time))

echo ""
echo "END"
echo "-------------  Completed in $run_time seconds.  ($start_time to $end_time)  ---------------"
echo ""
echo ""
echo "Testing..."
echo ""
ffmpeg
echo ""
