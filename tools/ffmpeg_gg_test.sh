#!/bin/sh
# TODO: Verify to link statically some dependencies usually not available in a default instllation of RHEL/CentOS (ex.: libxcb)

## MG New

# cd /tmp && rm -rf ffmpeg* && wget https://github.com/munishgaurav5/st/raw/master/tools/ffmpeg_gg_test.sh && chmod 777 ffmpeg_gg_test.sh && ./ffmpeg_gg_test.sh


# cd /tmp && yum install wget -y && rm -rf ffmpeg* && wget https://github.com/munishgaurav5/st/raw/master/tools/ffmpeg_gg_test.sh && chmod 777 ffmpeg_gg_test.sh 
# nohup ./ffmpeg_gg_test.sh > ffmpeg_test.log.txt 2>&1 &
# watch -n 2 tail -n 30 ffmpeg_test.log.txt



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
yum -y install texi2html texinfo zeromq 

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


cd /tmp
rm -rf automake*
wget -O automake.tar.gz http://git.savannah.gnu.org/cgit/automake.git/snapshot/automake-1.16.1.tar.gz
tar zxvf automake.tar.gz
cd automake*/
./bootstrap --prefix=/usr/local
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

echo
echo -e "${msg_color}Compiling NASM...${reset_color}"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 https://github.com/yasm/yasm.git
#cd yasm
#autoreconf -fiv
#./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin"
wget http://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.xz
tar -xf nasm-2.14.02.tar.xz
cd nasm-2.14.02
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin"
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean


echo
echo -e "${msg_color}Compiling YASM...${reset_color}"
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
echo -e "${msg_color}Compiling freetype...${reset_color}"
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
echo -e "${msg_color}Compiling fontconfig...${reset_color}"
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
echo -e "${msg_color}Compiling zlib...${reset_color}"
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
echo -e "${msg_color}Compiling libx264...${reset_color}"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 https://git.videolan.org/git/x264.git
#git clone --depth 1 git://git.videolan.org/x264
git clone https://code.videolan.org/videolan/x264.git
cd x264
#git checkout origin/stable
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --enable-static
make -j ${FFMPEG_CPU_COUNT} 
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libx264"


#################################################################




echo
echo -e "${msg_color}Compiling libfdk-aac...${reset_color}"
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
echo -e "${msg_color}Compiling libmp3lame...${reset_color}"
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



######################################## libopus to be added

echo
echo -e "${msg_color}Compiling libopus...${reset_color}"
echo
cd ${FFMPEG_HOME}/src
wget -O opus.tar.gz https://github.com/xiph/opus/archive/v1.3.1.tar.gz
tar xzvf opus.tar.gz
rm -f opus.tar.gz
cd opus*/
autoreconf -fiv
./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libopus"



echo
echo -e "${msg_color}Compiling libogg...${reset_color}"
echo
cd ${FFMPEG_HOME}/src
#curl -L -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
#tar xzvf libogg-1.3.2.tar.gz
#rm -f libogg-1.3.2.tar.gz
#cd libogg-1.3.2

wget -O libogg.tar.gz https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.3.tar.gz
tar xzvf libogg.tar.gz
rm -f libogg.tar.gz
cd libogg*/

./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

echo
echo -e "${msg_color}Compiling libvorbis...${reset_color}"
echo
cd ${FFMPEG_HOME}/src
#curl -L -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
#tar xzvf libvorbis-1.3.4.tar.gz
#rm -f libvorbis-1.3.4.tar.gz
#cd libvorbis-1.3.4

wget -O libvorbis.tar.gz  https://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.6.tar.gz
tar xzvf libvorbis.tar.gz
rm -f libvorbis.tar.gz
cd libvorbis*

LDFLAGS="-L${FFMPEG_HOME}/build/lib" CPPFLAGS="-I${FFMPEG_HOME}/build/include" ./configure --prefix="${FFMPEG_HOME}/build" --with-ogg="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvorbis"



echo
echo -e "${msg_color}Compiling libvpx...${reset_color}"
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
echo -e "${msg_color}Compiling libxvid...${reset_color}"
echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz 
tar xvfz xvidcore-1.3.2.tar.gz
rm -f xvidcore-1.3.2.tar.gz
cd xvidcore/build/generic



echo
echo -e "${msg_color}Compiling libtheora...${reset_color}"
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
echo -e "${msg_color}Compiling libwebp...${reset_color}"
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
echo -e "${msg_color}Compiling libxml2...${reset_color}"
echo
cd ${FFMPEG_HOME}/src
rm -rf v2.9.9.zip* libxml2*
wget -O libxml2.zip https://github.com/GNOME/libxml2/archive/v2.9.9.zip
unzip libxml2.zip
cd libxml2*/
./autogen.sh
./configure --prefix="${FFMPEG_HOME}/build"  --bindir="${FFMPEG_HOME}/bin"  --enable-static --disable-shared --without-readline --without-python
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libxml2 "

####################################### GPU

yum install -y "http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-10.2.89-1.x86_64.rpm"
yum install -y cuda

cd ${FFMPEG_HOME}/src
wget -O nv-codec-headers.zip https://github.com/FFmpeg/nv-codec-headers/archive/master.zip
unzip nv-codec-headers.zip
cd nv-codec-headers*/
make -j ${FFMPEG_CPU_COUNT} PREFIX="${FFMPEG_HOME}/build" install-static
make install
#    patch --force -d "$DEST_DIR" -p1 < "$MYDIR/dynlink_cuda.h.patch" || :
FFMPEG_ENABLE=" --enable-cuda --enable-cuda-sdk --enable-cuvid  --enable-libnpp  ${FFMPEG_ENABLE} --enable-nvenc "
CUDA_DIR="/usr/local/cuda"

#####################################


echo
echo -e "${msg_color}Compiling ffmpeg...${reset_color}"
echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git FFmpeg
#rm -rf FFmpeg*
#wget -O FFmpeg.zip https://github.com/FFmpeg/FFmpeg/archive/n4.1.2.zip
#wget -O FFmpeg.zip https://github.com/FFmpeg/FFmpeg/archive/n4.1.3.zip

#wget -O FFmpeg.zip https://github.com/FFmpeg/FFmpeg/archive/n4.2.zip
#unzip FFmpeg.zip
#cd FFmpeg*/

rm -rf ffmpeg*
wget -O ffmpeg.tar.bz2 https://www.ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjf ffmpeg.tar.bz2
cd ffmpeg*/

##############
export PATH="$CUDA_DIR/bin:$PATH" 
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --extra-cflags="-I${FFMPEG_HOME}/build/include -I $CUDA_DIR/include/" --extra-ldflags="-L${FFMPEG_HOME}/build/lib -L $CUDA_DIR/lib64/" --extra-libs='-lpthread -lm -lz' --bindir="${FFMPEG_HOME}/bin" --pkg-config-flags="--static" ${FFMPEG_ENABLE}
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
hash -r

source ~/.bashrc
#. ~/.bash_profile


####################

ffmpeg
#ffmpeg -h encoder=libx265 2>/dev/null | grep pixel
which ffmpeg

source ~/.bashrc

chmod 777 ${FFMPEG_HOME}/bin/*

# mediainfo -f --Output=JSON input.mkv
# ffprobe -v quiet -print_format json -show_format -show_streams input.mkv
# ffprobe -v quiet -print_format json -show_format -show_streams -show_chapters input.mkv
