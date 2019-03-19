#!/bin/sh
# TODO: Verify to link statically some dependencies usually not available in a default instllation of RHEL/CentOS (ex.: libxcb)

###################
## Configuration ##
###################

FFMPEG_CPU_COUNT=$(nproc)
FFMPEG_ENABLE="--enable-gpl --enable-version3 --enable-nonfree --enable-runtime-cpudetect --enable-gray --enable-openssl "
FFMPEG_HOME=/usr/local/src/ffmpeg

####################
## Initialization ##
####################

yum-config-manager --add-repo http://www.nasm.us/nasm.repo
yum -y install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel

yum -y install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig curl-devel openssl-devel ncurses-devel p11-kit-devel zlib-devel

yum -y install zip unzip nano wget curl git yum-utils openssl-devel
yum -y groupinstall "Development Tools"
yum -y install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ libtool make mercurial pkgconfig zlib-devel
yum -y install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig curl-devel openssl-devel ncurses-devel p11-kit-devel zlib-devel
yum -y install fontconfig fontconfig-devel

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

cd /tmp
rm -rf cmake*
wget https://cmake.org/files/v3.14/cmake-3.14.0.tar.gz
tar zxvf cmake-3.*
cd cmake-3.*/
./bootstrap --prefix=/usr/local
make -j$(nproc)
make install
cmake --version


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
echo -e "\e[93mCompiling freetype2...\e[39m"
echo
freetype_url="http://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2"
cd ${FFMPEG_HOME}/src
rm -rf freetype*
wget $freetype_url
tar -xf freetype-2.9.1.tar.bz2 freetype-2.9.1
cd freetype-2.9.1
./configure --prefix="${FFMPEG_HOME}/build" --libdir="${FFMPEG_HOME}/build/lib"  --enable-freetype-config --enable-static
make
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libfreetype "


############## fontconfig

echo
echo -e "\e[93mCompiling libfribidi...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O https://github.com/fribidi/fribidi/releases/download/v1.0.5/fribidi-1.0.5.tar.bz2
tar xjvf fribidi-1.0.5.tar.bz2
rm -f fribidi-1.0.5.tar.bz2
cd fribidi-1.0.5
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libfribidi"


echo
echo -e "\e[93mCompiling libass...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/libass/libass.git
cd libass
./autogen.sh
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libass"


echo
echo -e "\e[93mCompiling libcaca...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/cacalabs/libcaca.git
cd libcaca
git checkout v0.99.beta19
./bootstrap
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static --disable-doc  --disable-ruby --disable-csharp --disable-java --disable-python --disable-cxx --enable-ncurses --disable-x11
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libcaca"



echo
echo -e "\e[93mCompiling libvo-amrwbenc...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.sourceforge.net/opencore-amr/vo-amrwbenc/vo-amrwbenc-0.1.3.tar.gz
tar xzvf vo-amrwbenc-0.1.3.tar.gz
rm -f vo-amrwbenc-0.1.3.tar.gz
cd vo-amrwbenc-0.1.3
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvo-amrwbenc"



echo
echo -e "\e[93mCompiling libopencore...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.sourceforge.net/opencore-amr/opencore-amr-0.1.3.tar.gz
tar xzvf opencore-amr-0.1.3.tar.gz
rm -f opencore-amr-0.1.3.tar.gz
cd opencore-amr-0.1.3
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libopencore-amrnb --enable-libopencore-amrwb"




echo
echo -e "\e[93mCompiling libx264...\e[39m"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 https://git.videolan.org/git/x264.git
git clone --depth 1 git://git.videolan.org/x264
cd x264
#git checkout origin/stable
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --enable-static
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
echo -e "\e[93mCompiling libtwolame...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.sourceforge.net/twolame/twolame-0.3.13.tar.gz
tar xzvf twolame-0.3.13.tar.gz
rm -f twolame-0.3.13.tar.gz
cd twolame-0.3.13
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libtwolame"

######################################## libopus to be added

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
echo -e "\e[93mCompiling libspeex...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xiph.org/releases/speex/speex-1.2rc2.tar.gz
tar xzvf speex-1.2rc2.tar.gz
rm -f speex-1.2rc2.tar.gz
cd speex-1.2rc2
LDFLAGS="-L${FFMPEG_HOME}/build/lib" CPPFLAGS="-I${FFMPEG_HOME}/build/include" ./configure --prefix="${FFMPEG_HOME}/build" --with-ogg="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libspeex"



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
echo -e "\e[93mCompiling libxvid...\e[39m"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz 
tar xvfz xvidcore-1.3.2.tar.gz
rm -f xvidcore-1.3.2.tar.gz
cd xvidcore/build/generic
./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libxvid"


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
echo -e "\e[93mCompiling libwebp...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://chromium.googlesource.com/webm/libwebp.git
cd libwebp
./autogen.sh
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libwebp"



echo
echo -e "\e[93mCompiling libopenjpeg...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/uclouvain/openjpeg.git
cd openjpeg
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0 
make -j ${FFMPEG_CPU_COUNT}
make install
rm -f -R "${FFMPEG_HOME}/build/lib/openjpeg-2.1"
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libopenjpeg"



echo
echo -e "\e[93mCompiling libilbc...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/TimothyGu/libilbc.git
cd libilbc
sed 's/lib64/lib/g' -i CMakeLists.txt
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0 -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=/lib
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libilbc"



echo
echo -e "\e[93mCompiling librtmp...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 http://git.ffmpeg.org/rtmpdump.git librtmp
cd librtmp
make -j ${FFMPEG_CPU_COUNT} SYS=posix prefix="${FFMPEG_HOME}/build" CRYPTO=OPENSSL SHARED= XCFLAGS="-I${FFMPEG_HOME}/build/include" XLDFLAGS="-L${FFMPEG_HOME}/build/lib" install
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-librtmp"



echo
echo -e "\e[93mCompiling libsoxr...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone http://git.code.sf.net/p/soxr/code soxr
cd soxr
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DWITH_OPENMP=off -DWITH_LSR_BINDINGS=off -DBUILD_SHARED_LIBS=0 -DBUILD_EXAMPLES=0 -DBUILD_TESTS=0
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libsoxr"


####################### frei0r



echo
echo -e "\e[93mCompiling libvidstab...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/georgmartius/vid.stab.git vidstab
cd vidstab
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvidstab"



echo
echo -e "\e[93mCompiling librubberband...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/breakfastquay/rubberband.git
#git clone https://github.com/lachs0r/rubberband.git
cd rubberband
make -j ${FFMPEG_CPU_COUNT} PREFIX="${FFMPEG_HOME}/build" install-static
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-librubberband"

# Full "--enable" list, just in case
# FFMPEG_ENABLE="--enable-gpl --enable-version3 --enable-nonfree --enable-runtime-cpudetect --enable-gray --enable-openssl --enable-libfreetype --enable-fontconfig --enable-libfribidi --enable-libass --enable-libcaca --enable-libvo-amrwbenc --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libx264 --enable-libx265 --enable-libfdk-aac --enable-libmp3lame --enable-libtwolame --enable-libopus --enable-libvorbis --enable-libspeex --enable-libvpx --enable-libxvid --enable-libtheora --enable-libwebp --enable-libopenjpeg --enable-libilbc --enable-librtmp --enable-libsoxr --enable-frei0r --enable-filter=frei0r --enable-libvidstab --enable-librubberband"




echo
echo -e "\e[93mCompiling ffmpeg...\e[39m"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git
git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --extra-cflags="-I${FFMPEG_HOME}/build/include" --extra-ldflags="-L${FFMPEG_HOME}/build/lib" --extra-libs='-lpthread' --bindir="${FFMPEG_HOME}/bin" --pkg-config-flags="--static" ${FFMPEG_ENABLE}
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
hash -r



ffmpeg

