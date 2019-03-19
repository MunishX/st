#!/bin/sh
# TODO: Verify to link statically some dependencies usually not available in a default instllation of RHEL/CentOS (ex.: libxcb)

###################
## Configuration ##
###################

FFMPEG_CPU_COUNT=$(nproc)
FFMPEG_ENABLE="--enable-gpl --enable-version3 --enable-nonfree --enable-runtime-cpudetect --enable-gray --enable-openssl --enable-libfreetype"
FFMPEG_HOME=/usr/local/src/ffmpeg

####################
## Initialization ##
####################

yum -y install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig curl-devel openssl-devel ncurses-devel p11-kit-devel zlib-devel

yum -y install zip unzip nano wget curl git yum-utils openssl-devel
yum -y groupinstall "Development Tools"
yum -y install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ libtool make mercurial pkgconfig zlib-devel
yum -y install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig curl-devel openssl-devel ncurses-devel p11-kit-devel zlib-devel

#yum-config-manager --add-repo http://www.nasm.us/nasm.repo
#yum install -y nasm 

# rpm -Uhv http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
# yum -y update
# yum install glibc gcc gcc-c++ autoconf automake libtool git make nasm pkgconfig -y
# yum install SDL-devel a52dec a52dec-devel alsa-lib-devel faac faac-devel faad2 faad2-devel -y
# yum install freetype-devel giflib gsm gsm-devel imlib2 imlib2-devel lame lame-devel libICE-devel libSM-devel libX11-devel -y
# yum install libXau-devel libXdmcp-devel libXext-devel libXrandr-devel libXrender-devel libXt-devel -y
# yum install libogg libvorbis vorbis-tools mesa-libGL-devel mesa-libGLU-devel xorg-x11-proto-devel zlib-devel -y
# yum install libtheora theora-tools -y
# yum install ncurses-devel -y
# yum install libdc1394 libdc1394-devel -y
# yum install amrnb-devel amrwb-devel opencore-amr-devel -y

mkdir -p ${FFMPEG_HOME}/src
mkdir -p ${FFMPEG_HOME}/build
mkdir -p ${FFMPEG_HOME}/bin

export PATH=$PATH:${FFMPEG_HOME}/build:${FFMPEG_HOME}/build/lib:${FFMPEG_HOME}/build/include:${FFMPEG_HOME}/bin

##############
### FFMPEG ###
##############



echo
echo -e "\e[93mCompiling YASM...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg-nonfree/build" --bindir="${FFMPEG_HOME}/bin"
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

echo
echo -e "\e[93mCompiling fontconfig...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.94.tar.gz
tar xzvf fontconfig-2.11.94.tar.gz
rm -f fontconfig-2.11.94.tar.gz
cd fontconfig-2.11.94
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static --enable-libxml2
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-fontconfig"



echo
echo -e "\e[93mCompiling libx264...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://git.videolan.org/git/x264.git
cd x264
git checkout origin/stable
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libx264"

echo
echo -e "\e[93mCompiling libx265...\e[39m"
echo
cd ${FFMPEG_HOME}/src
hg clone https://bitbucket.org/multicoreware/x265
cd ${FFMPEG_HOME}/src/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DENABLE_SHARED:bool=off ../../source
make -j ${FFMPEG_CPU_COUNT}
make install
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libx265"

echo
echo -e "\e[93mCompiling libfdk-aac...\e[39m"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
autoreconf -fiv
./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libfdk-aac"

echo
echo -e "\e[93mCompiling libmp3lame...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
rm -f lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static --enable-nasm
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libmp3lame"


echo
echo -e "\e[93mCompiling libogg...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
rm -f libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

echo
echo -e "\e[93mCompiling libvorbis...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
rm -f libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
LDFLAGS="-L${FFMPEG_HOME}/build/lib" CPPFLAGS="-I${FFMPEG_HOME}/build/include" ./configure --prefix="${FFMPEG_HOME}/build" --with-ogg="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvorbis"



echo
echo -e "\e[93mCompiling libvpx...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="${FFMPEG_HOME}/build" --disable-examples  --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make clean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvpx"


echo
echo -e "\e[93mCompiling libtheora...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
tar xzvf libtheora-1.1.1.tar.gz
rm -f libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix="${FFMPEG_HOME}/build" --disable-oggtest --with-ogg-includes="${FFMPEG_HOME}/build/include" --with-ogg-libraries="${FFMPEG_HOME}/build/lib" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libtheora"






echo
echo -e "\e[93mCompiling ffmpeg...\e[39m"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git
git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig"
./configure --prefix="${FFMPEG_HOME}/build" --extra-cflags="-I${FFMPEG_HOME}/build/include" --extra-ldflags="-L${FFMPEG_HOME}/build/lib" --extra-libs='-lpthread' --bindir="${FFMPEG_HOME}/bin" --pkg-config-flags="--static" ${FFMPEG_ENABLE}
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
hash -r



ffmpeg

