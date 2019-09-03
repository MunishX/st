#!/bin/sh
# TODO: Verify to link statically some dependencies usually not available in a default instllation of RHEL/CentOS (ex.: libxcb)

## MG New

# cd /tmp && rm -rf fftest* && wget https://github.com/munishgaurav5/st/raw/master/tools/fftest.sh && chmod 777 fftest.sh && ./fftest.sh


# cd /tmp && yum install wget -y && rm -rf fftest* && wget https://github.com/munishgaurav5/st/raw/master/tools/fftest.sh && chmod 777 fftest.sh 
# nohup ./fftest.sh > fftest.log.txt 2>&1 &
# watch -n 2 tail -n 30 fftest.log.txt



###################
## Configuration ##
###################

FFMPEG_CPU_COUNT=$(nproc)
FFMPEG_ENABLE="--enable-gpl --enable-pic --enable-version3 --enable-nonfree --enable-runtime-cpudetect --enable-gray --enable-openssl --enable-iconv "
#FFMPEG_HOME=/usr/local/src/ffmpeg
FFMPEG_HOME=/usr/local



rm -rf ${FFMPEG_HOME}/{build,doc,share,src}
rm -rf ${FFMPEG_HOME}/bin/{ccmake,cpack,cwebp,exiftool,ffprobe,fribidi,lib,rtmpdump,x264,xmlcatalog,yasm,cmake,ctest,dwebp,ffmpeg,freetype-config,lame,mediainfo,vsyasm,xml2-config,xmllint,ytasm}
mkdir -p ${FFMPEG_HOME}/src
mkdir -p ${FFMPEG_HOME}/build
mkdir -p ${FFMPEG_HOME}/bin

export PATH=$PATH:${FFMPEG_HOME}/build:${FFMPEG_HOME}/build/lib:${FFMPEG_HOME}/build/include:${FFMPEG_HOME}/bin

#source ~/.profile 
source ~/.bashrc


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
yum -y install fontconfig fontconfig-devel zlib-devel

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


##############
### Colour ###
##############
if test -t 1 && which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
    if test -n "$ncolors" && test $ncolors -ge 8; then
        msg_color=$(tput setaf 3)$(tput bold)
        error_color=$(tput setaf 1)$(tput bold)
        reset_color=$(tput sgr0)
    fi
    ncols=$(tput cols)
fi



##############
### FFMPEG ###
##############

echo
echo -e "$msg_colorCompiling YASM...$reset_color"
echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin"
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

echo
echo -e "$msg_colorCompiling freetype...$reset_color"
echo
#freetype_url="http://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2"
freetype_url="http://download.savannah.gnu.org/releases/freetype/freetype-2.10.1.tar.gz"
cd ${FFMPEG_HOME}/src
rm -rf freetype*
wget $freetype_url
#tar -xf freetype-2.9.1.tar.bz2 freetype-2.9.1
tar xzvf freetype-2.10.1.tar.gz
cd freetype-*/
./configure --prefix="${FFMPEG_HOME}/build" --libdir="${FFMPEG_HOME}/build/lib"  --bindir="${FFMPEG_HOME}/bin" --enable-freetype-config --enable-static
make
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libfreetype "
########------------######## --bindir="${FFMPEG_HOME}/bin"

echo
echo -e "$msg_colorCompiling fontconfig...$reset_color"
echo
#font_url="https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.gz"
font_url="https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.92.tar.gz"
cd ${FFMPEG_HOME}/src
rm -rf fontconfig*
wget $font_url
tar xzvf fontconfig-2.13.92.tar.gz
cd fontconfig*
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static --enable-iconv --enable-libxml2
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-fontconfig "


echo
echo -e "$msg_colorCompiling zlib...$reset_color"
echo
cd ${FFMPEG_HOME}/src
wget -O zlib.tar.gz https://github.com/madler/zlib/archive/v1.2.11.tar.gz
tar xzvf zlib.tar.gz
rm -f zlib.tar.gz
cd zlib*/
./configure --prefix="${FFMPEG_HOME}/build" --static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-zlib"



echo
echo -e "$msg_colorCompiling libfribidi...$reset_color"
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
echo -e "$msg_colorCompiling libass...$reset_color"
echo
libass_url="https://github.com/libass/libass/releases/download/0.14.0/libass-0.14.0.tar.gz"
cd ${FFMPEG_HOME}/src
rm -rf libass*
wget $libass_url
tar xzvf libass-0.14.0.tar.gz
cd libass*
./autogen.sh
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libass"



#echo
#echo -e "$msg_colorCompiling libcaca...$reset_color"
#echo
#cd ${FFMPEG_HOME}/src
#rm -rf libcaca*
#git clone --depth=1 git://github.com/cacalabs/libcaca
#cd libcaca
#./bootstrap
#./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static --disable-doc  --disable-ruby --disable-csharp --disable-java --disable-python --disable-cxx --enable-ncurses --disable-x11
#make -j ${FFMPEG_CPU_COUNT}
#make install
#make distclean
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libcaca"



echo
echo -e "$msg_colorCompiling libvo-amrwbenc...$reset_color"
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
echo -e "$msg_colorCompiling libx264...$reset_color"
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


##########################  New Chinese encoder #################


echo
echo -e "$msg_colorCompiling xavs ...$reset_color"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
#git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git
wget -O xavs.zip https://github.com/munishgaurav5/st/raw/master/tools/ff/xavs.zip
unzip xavs.zip
rm -rf xavs.zip
cd xavs/
./configure --prefix="${FFMPEG_HOME}/build" --libdir="${FFMPEG_HOME}/build/lib"  --bindir="${FFMPEG_HOME}/bin" --enable-pic  --disable-shared --enable-static 
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-asm --enable-libxavs"



wget -O zeromq.tar.gz https://github.com/zeromq/libzmq/releases/download/v4.2.2/zeromq-4.2.2.tar.gz 
tar xvzf zeromq.tar.gz 
cd zeromq*/
./configure 
make install 
ldconfig
--enable-network --enable-protocol=tcp --enable-demuxer=rtsp --enable-libzmq

cd ~/ffmpeg_sources
sudo git clone --depth 1 https://github.com/Haivision/srt.git && sudo mkdir srt/build && cd srt/build
sudo cmake -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_C_DEPS=ON -DENABLE_SHARED=OFF -DENABLE_STATIC=ON ..
sudo make
sudo make install
--enable-libsrt

echo
echo -e "$msg_colorCompiling davs2 decoder ...$reset_color"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
#git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git
wget -O davs2.zip https://github.com/pkuvcl/davs2/archive/1.6.zip 
unzip davs2.zip
cd davs2*/build/linux/
./configure --prefix="${FFMPEG_HOME}/build" --libdir="${FFMPEG_HOME}/build/lib"  --bindir="${FFMPEG_HOME}/bin" --enable-pic  --disable-shared --enable-static 
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libdavs2"



#################################################################


echo
echo -e "$msg_colorCompiling libfdk-aac...$reset_color"
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


#####################################


echo
echo -e "$msg_colorCompiling ffmpeg...$reset_color"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git FFmpeg
rm -rf FFmpeg*
#wget -O FFmpeg.zip https://github.com/FFmpeg/FFmpeg/archive/n4.1.2.zip
#wget -O FFmpeg.zip https://github.com/FFmpeg/FFmpeg/archive/n4.1.3.zip
wget -O FFmpeg.zip https://github.com/FFmpeg/FFmpeg/archive/n4.2.zip
unzip FFmpeg.zip
cd FFmpeg*/

#### EDIT ####

nmmw=Fas
nmmx=tVid
nmmy=eoEnc
nmmz=oder

mvvx=6
mvvy=1
mvvz=3

cmmx=".c"
cmmy="om"

app_name=${nmmw}${nmmx}${nmmy}${nmmz}
app_version=${mvvx}.${mvvy}.${mvvz}
app_full_name="${app_name} v${app_version} (By ${app_name}${cmmx}${cmmy})"

sed -i 's%^.*define LIBAVFORMAT_IDENT.*%#define LIBAVFORMAT_IDENT             "XXX_EN_CODER"%' libavformat/version.h
sed -i "s/XXX_EN_CODER/$app_full_name/" libavformat/version.h

##############

PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --extra-cflags="-I${FFMPEG_HOME}/build/include" --extra-ldflags="-L${FFMPEG_HOME}/build/lib" --extra-libs='-lpthread -lm -lz' --bindir="${FFMPEG_HOME}/bin" --pkg-config-flags="--static" ${FFMPEG_ENABLE}
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
hash -r

source ~/.bashrc
#. ~/.bash_profile

########  Install qt-faststart
echo
echo -e "$msg_colorCompiling qt-faststart...$reset_color"
echo
cd ${FFMPEG_HOME}/src
cd FFmpeg*/tools/
make qt-faststart
cp qt-faststart /usr/local/bin/
ldconfig

#################
