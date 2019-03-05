#!/usr/bin/env bash

## MG New

# cd /tmp && rm -rf ff_* && wget https://github.com/munishgaurav5/st/raw/master/ff_installer.sh && chmod 777 ff_installer.sh && ./ff_installer.sh
# cd /tmp && rm -rf ff_* && wget https://github.com/munishgaurav5/st/raw/master/ff_installer.sh && chmod 777 ff_installer.sh && nohup ./ff_installer.sh > ff_log.txt &

# cd /tmp && yum install wget nano zip unzip -y && rm -rf ff_* && wget https://github.com/munishgaurav5/st/raw/master/ff_installer.sh && chmod 777 ff_installer.sh 
# ./ff_installer.sh > ffout.txt 2>&1 &
# watch -n 2 tail -n 20 ffout.txt

start_time=`date +%s`

###### VARS #####
#PreFix_Dir="/usr"
PreFix_Dir="/usr/local"

#PATH="$PreFix_Dir/bin:$PATH" 
#################

# Remove any existing packages
#yum -y erase ffmpeg x264 x264-devel
yum -y install yum-utils openssl-devel

# Install the dependencies
yum-config-manager --add-repo http://www.nasm.us/nasm.repo
yum -y install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel

# Make a directory for FFmpeg sources
rm -rf $PreFix_Dir/ffmpeg_sources
mkdir -p $PreFix_Dir/ffmpeg_sources

# Install Yasm
cd $PreFix_Dir/ffmpeg_sources
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$PreFix_Dir/ffmpeg_build" --bindir="$PreFix_Dir/bin"
make
make install
make distclean
source ~/.bash_profile

# Install x264
cd $PreFix_Dir/ffmpeg_sources
git clone --depth 1 git://git.videolan.org/x264
cd x264
PKG_CONFIG_PATH="$PreFix_Dir/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$PreFix_Dir/ffmpeg_build" --bindir="$PreFix_Dir/bin" --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install x265
cd $PreFix_Dir/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd $PreFix_Dir/ffmpeg_sources/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PreFix_Dir/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make
make install
make distclean
source ~/.bash_profile

# Install libfdk_aac
cd $PreFix_Dir/ffmpeg_sources
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
yum install libtool -y
libtoolize
autoreconf -fiv
./configure --prefix="$PreFix_Dir/ffmpeg_build" --disable-shared
make
make install
make distclean
source ~/.bash_profile

# Install libmp3lame
cd $PreFix_Dir/ffmpeg_sources
#curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
curl -L -O http://download.videolan.org/pub/contrib/lame/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$PreFix_Dir/ffmpeg_build" --bindir="$PreFix_Dir/bin" --disable-shared --enable-nasm
make
make install
make distclean
source ~/.bash_profile

# Install libopus
cd $PreFix_Dir/ffmpeg_sources
#curl -O https://archive.mozilla.org/pub/opus/opus-1.1.5.tar.gz
#tar xzvf opus-1.1.5.tar.gz
#cd opus-1.1.5
curl -O https://archive.mozilla.org/pub/opus/opus-1.2.tar.gz
tar xzvf opus-1.*.tar.gz
cd opus-1.*/
./configure --prefix="$PreFix_Dir/ffmpeg_build" --disable-shared
make
make install
make distclean
source ~/.bash_profile

# Install libogg
cd $PreFix_Dir/ffmpeg_sources
#curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
#curl -O http://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.2.tar.gz
#tar xzvf libogg-1.3.2.tar.gz
#cd libogg-1.3.2
curl -O http://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.3.tar.gz
tar xzvf libogg-1.*.tar.gz
cd libogg-1.*/
./configure --prefix="$PreFix_Dir/ffmpeg_build" --disable-shared
make
make install
make distclean
source ~/.bash_profile
#yum -y install libogg

# Install libvorbis
cd $PreFix_Dir/ffmpeg_sources
#curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
#curl -O http://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.5.tar.gz
#tar xzvf libvorbis-1.3.4.tar.gz
#cd libvorbis-1.3.4
#tar xzvf libvorbis-1.3.5.tar.gz
#cd libvorbis-1.3.5
curl -O http://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.6.tar.gz
tar xzvf libvorbis-1*.tar.gz
cd libvorbis-1*/
PKG_CONFIG_PATH="$PreFix_Dir/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$PreFix_Dir/ffmpeg_build" --with-ogg="$PreFix_Dir/ffmpeg_build" --disable-shared
make
make install
make distclean
source ~/.bash_profile
#yum -y install libvorbis

# Install libtheora
# cd ~/ffmpeg_sources
# wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
# tar xzvf libtheora-1.1.1.tar.gz
# cd libtheora-1.1.1
# ./configure --disable-shared
# make
# make install
# make distclean
# source ~/.bash_profile
yum -y install libtheora

# Install libvpx
cd $PreFix_Dir/ffmpeg_sources
# git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
wget -O libvpx_v1.7.0.zip https://github.com/webmproject/libvpx/archive/v1.7.0.zip
unzip libvpx_v1.7.0.zip

cd libvpx*/
./configure --prefix="$PreFix_Dir/ffmpeg_build"  --as=yasm --enable-pic --disable-examples --disable-unit-tests
#PATH="$PreFix_Dir/bin:$PATH" 
make
make install
make distclean
source ~/.bash_profile
#yum -y install libvpx

######################## New #########################
# Install librtmp
cd $PreFix_Dir/ffmpeg_sources
wget -O librtmp.zip https://github.com/pexip/librtmp/archive/master.zip
unzip librtmp.zip
cd librtmp-master
./autogen.sh
./configure --prefix="$PreFix_Dir/ffmpeg_build" --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install VID.STAB
#https://github.com/georgmartius/vid.stab/
cd $PreFix_Dir/ffmpeg_sources
wget -O vid_stab.zip https://github.com/georgmartius/vid.stab/archive/master.zip
unzip vid_stab.zip

cd vid.stab-master
cmake -DCMAKE_INSTALL_PREFIX:PATH="$PreFix_Dir/ffmpeg_build" -DBUILD_SHARED_LIBS:bool=off .
make
make install
make distclean
source ~/.bash_profile

mv $PreFix_Dir/ffmpeg_build/lib64/pkgconfig/* $PreFix_Dir/ffmpeg_build/lib/pkgconfig/
rm -rf $PreFix_Dir/ffmpeg_build/lib64/pkgconfig/
mv $PreFix_Dir/ffmpeg_build/lib64/* $PreFix_Dir/ffmpeg_build/lib/
rm -rf $PreFix_Dir/ffmpeg_build/lib64/

#Install Openjpeg
cd $PreFix_Dir/ffmpeg_sources
wget -O openjpeg-v2.3.0.zip https://github.com/uclouvain/openjpeg/archive/v2.3.0.zip
unzip openjpeg-v2.3.0.zip
cd openjpeg-2.3.0
cmake -DCMAKE_INSTALL_PREFIX:PATH="/usr/local/ffmpeg_build" .
make
make install
make distclean
source ~/.bash_profile

#Install Opencore arm
cd $PreFix_Dir/ffmpeg_sources
# https://sourceforge.net/projects/opencore-amr/files/
wget http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz
tar xzvf opencore-amr-0.1.5.tar.gz
cd opencore-amr-0.1.5
./configure --prefix="/usr/local/ffmpeg_build" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile


# XvidCore
cd $PreFix_Dir/ffmpeg_sources
# https://labs.xvid.com/source/
wget https://downloads.xvid.com/downloads/xvidcore-1.3.5.zip
unzip xvidcore-1.3.5.zip
cd xvidcore/build/generic/
./configure --prefix="/usr/local/ffmpeg_build" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile


#FreeType2
cd $PreFix_Dir/ffmpeg_sources
# http://download.savannah.gnu.org/releases/freetype/
wget http://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2

tar -xf freetype-2.9.1.tar.bz2 freetype-2.9.1

./configure --prefix="/usr/local/ffmpeg_build" --enable-freetype-config --disable-static

make
make install
make distclean
source ~/.bash_profile

#####################################################



# Install FFmpeg
cd $PreFix_Dir/ffmpeg_sources

#wget https://github.com/FFmpeg/FFmpeg/archive/n3.4.zip
#unzip n3.*.zip
#cd FFmpeg-n3.*
curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg*/

#curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
#tar xjvf ffmpeg-snapshot.tar.bz2
#cd ffmpeg
PKG_CONFIG_PATH="$PreFix_Dir/ffmpeg_build/lib/pkgconfig" ./configure --extra-libs=-lpthread --prefix="$PreFix_Dir/ffmpeg_build" --extra-cflags="-I$PreFix_Dir/ffmpeg_build/include" --extra-ldflags="-L$PreFix_Dir/ffmpeg_build/lib -ldl" --bindir="$PreFix_Dir/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-filters --enable-librtmp --enable-libvidstab --enable-libopenjpeg --enable-libvidstab --enable-libopencore_amrwb --enable-libopencore_amrnb  --enable-libxvid --enable-version3
make
make install
hash -r

make distclean
source ~/.bash_profile

chmod 777 $PreFix_Dir/bin


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

