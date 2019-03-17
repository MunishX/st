#!/usr/bin/env bash

## MG New

# cd /tmp && rm -rf ff_* && wget https://github.com/munishgaurav5/st/raw/master/ff_old.sh && chmod 777 ff_old.sh && ./ff_old.sh
# cd /tmp && rm -rf ff_* && wget https://github.com/munishgaurav5/st/raw/master/ff_old.sh && chmod 777 ff_old.sh && nohup ./ff_old.sh > ff_log.txt &

# cd /tmp && yum install wget -y && rm -rf ff_* && wget https://github.com/munishgaurav5/st/raw/master/ff_old.sh && chmod 777 ff_old.sh
# ./ff_old.sh > ffout.txt 2>&1 &
# watch -n 2 tail -n 30 ffout.txt



#ref https://github.com/ka che rga/ffm peg-inst all/blob/master/bu ild-ffm peg

start_time=`date +%s`

###### VARS #####
#PreFix_Dir="/usr"
PreFix_Dir="/usr/local"

FF_SOURCE="/usr/local/ffmpeg_sources"
FF_BUILD="/usr/local/ffmpeg_build"
FF_BIN="/usr/local/ffmpeg_build/bin"

#PATH="$PreFix_Dir/bin:$PATH" 
#################

# Remove any existing packages
#yum -y erase ffmpeg x264 x264-devel
yum groupinstall "Development Tools"
yum -y install zip unzip nano wget curl git yum-utils openssl-devel

# Install the dependencies
yum-config-manager --add-repo http://www.nasm.us/nasm.repo
yum -y install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel

# Make a directory for FFmpeg sources
rm -rf $FF_SOURCE
rm -rf $FF_BUILD
mkdir -p $FF_SOURCE
mkdir -p $FF_BUILD

# Install Yasm
cd $FF_SOURCE
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$FF_BUILD" --bindir="$FF_BIN"
make
make install
make distclean
source ~/.bash_profile

# Install x264
cd $FF_SOURCE
git clone --depth 1 git://git.videolan.org/x264
cd x264
PKG_CONFIG_PATH="$FF_BUILD/lib/pkgconfig" ./configure --prefix="$FF_BUILD" --bindir="$FF_BIN" --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install x265
cd $FF_SOURCE
hg clone https://bitbucket.org/multicoreware/x265
cd $FF_BUILD/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$FF_BUILD" -DENABLE_SHARED:bool=off ../../source
make
make install
make distclean
source ~/.bash_profile

# Install libfdk_aac
cd $FF_SOURCE
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
yum install libtool -y
libtoolize
autoreconf -fiv
./configure --prefix="$FF_BUILD" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install libmp3lame
cd $FF_SOURCE
#curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
curl -L -O http://download.videolan.org/pub/contrib/lame/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$FF_BUILD" --bindir="$FF_BIN" --enable-nasm --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install libopus
cd $FF_SOURCE
#curl -O https://archive.mozilla.org/pub/opus/opus-1.1.5.tar.gz
#tar xzvf opus-1.1.5.tar.gz
#cd opus-1.1.5
curl -O https://archive.mozilla.org/pub/opus/opus-1.2.tar.gz
tar xzvf opus-1.*.tar.gz
cd opus-1.*/
./configure --prefix="$FF_BUILD" --disable-shared
make
make install
make distclean
source ~/.bash_profile

# Install libogg
cd $FF_SOURCE
#curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
#curl -O http://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.2.tar.gz
#tar xzvf libogg-1.3.2.tar.gz
#cd libogg-1.3.2
curl -O http://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.3.tar.gz
tar xzvf libogg-1.*.tar.gz
cd libogg-1.*/
./configure --prefix="$FF_BUILD" --disable-shared --enable-static
make
make install
make distclean
source ~/.bash_profile
#yum -y install libogg


# Install libvpx
cd $FF_SOURCE
# git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
wget -O libvpx_v1.7.0.zip https://github.com/webmproject/libvpx/archive/v1.7.0.zip
unzip libvpx_v1.7.0.zip

cd libvpx*/
./configure --prefix="$FF_BUILD"  --as=yasm --enable-pic --disable-examples --disable-unit-tests --disable-shared
#PATH="$PreFix_Dir/bin:$PATH" 
make
make install
make distclean
source ~/.bash_profile
#yum -y install libvpx

# Install libvorbis
cd $FF_SOURCE
#curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
#curl -O http://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.5.tar.gz
#tar xzvf libvorbis-1.3.4.tar.gz
#cd libvorbis-1.3.4
#tar xzvf libvorbis-1.3.5.tar.gz
#cd libvorbis-1.3.5
curl -O http://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.6.tar.gz
tar xzvf libvorbis-1*.tar.gz
cd libvorbis-1*/
PKG_CONFIG_PATH="$FF_BUILD/lib/pkgconfig" ./configure --prefix="$FF_BUILD" --with-ogg-libraries="$FF_BUILD/lib" --with-ogg-includes="$FF_BUILD/include/" --enable-static --disable-shared --disable-oggtest
make
make install
make distclean
source ~/.bash_profile
#yum -y install libvorbis

# Install libtheora
 # https://ftp.osuosl.org/pub/xiph/releases/theora/
 cd $FF_SOURCE
 wget https://ftp.osuosl.org/pub/xiph/releases/theora/libtheora-1.1.1.zip
 unzip libtheora-1.1.1.zip
 cd libtheora-1.1.1
 ./configure --prefix="$FF_BUILD" --with-ogg-libraries="$FF_BUILD/lib" --with-ogg-includes="$FF_BUILD/include/" --with-vorbis-libraries="$FF_BUILD/lib" --with-vorbis-includes="$FF_BUILD/include/" --enable-static --disable-shared --disable-oggtest --disable-vorbistest --disable-examples --disable-asm
 make
 make install
 make distclean
 source ~/.bash_profile
#yum -y install libtheora


#FreeType2
cd $FF_SOURCE
# http://download.savannah.gnu.org/releases/freetype/
wget http://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2

tar -xf freetype-2.9.1.tar.bz2 freetype-2.9.1
cd freetype-2.9.1
./configure --prefix="$FF_BUILD" --libdir="$FF_BUILD/lib"  --enable-freetype-config --enable-static

make
make install
make distclean
source ~/.bash_profile


# Install FFmpeg
cd $FF_SOURCE

#wget https://github.com/FFmpeg/FFmpeg/archive/n3.4.zip
#unzip n3.*.zip
#cd FFmpeg-n3.*
curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg*/

#curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
#tar xjvf ffmpeg-snapshot.tar.bz2
#cd ffmpeg
#PKG_CONFIG_PATH="$PreFix_Dir/ffmpeg_build/lib/pkgconfig" ./configure --extra-libs=-lpthread --prefix="$PreFix_Dir/ffmpeg_build" --extra-cflags="-I$PreFix_Dir/ffmpeg_build/include" --extra-ldflags="-L$PreFix_Dir/ffmpeg_build/lib -ldl" --bindir="$PreFix_Dir/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-filters --enable-libvidstab --enable-libopencore_amrwb --enable-libopencore_amrnb  --enable-libxvid --enable-libtheora --enable-version3
PKG_CONFIG_PATH="$FF_BUILD/lib/pkgconfig" ./configure --extra-libs=-lpthread --prefix="$FF_BUILD" --extra-cflags="-I$FF_BUILD/include" --extra-ldflags="-L$FF_BUILD/lib -ldl" --bindir="$FF_BIN" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-filters --enable-libtheora --enable-version3
make
make install
hash -r

make distclean
source ~/.bash_profile

chmod 777 $FF_BIN


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
