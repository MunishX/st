#!/bin/sh
# TODO: Verify to link statically some dependencies usually not available in a default instllation of RHEL/CentOS (ex.: libxcb)

## MG New

# cd /tmp && rm -rf ffmpeg* && wget https://github.com/munishgaurav5/st/raw/master/tools/ffmpeg.sh && chmod 777 ffmpeg.sh && ./ffmpeg.sh


# cd /tmp && yum install wget -y && rm -rf ffmpeg* && wget https://github.com/munishgaurav5/st/raw/master/tools/ffmpeg.sh && chmod 777 ffmpeg.sh 
# nohup ./ffmpeg.sh > ffmpeg.log.txt 2>&1 &
# watch -n 2 tail -n 30 ffmpeg.log.txt



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
### FFMPEG ###
##############

cd /tmp
rm -rf cmake*
#wget https://cmake.org/files/v3.14/cmake-3.14.0.tar.gz
wget https://cmake.org/files/v3.15/cmake-3.15.0.tar.gz
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
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin"
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

echo
echo -e "\e[93mCompiling freetype...\e[39m"
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
echo -e "\e[93mCompiling fontconfig...\e[39m"
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
echo -e "\e[93mCompiling zlib...\e[39m"
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
#echo -e "\e[93mCompiling libcaca...\e[39m"
#echo
#cd ${FFMPEG_HOME}/src
#rm -rf v0.99.beta19.tar.gz libcaca
#wget https://github.com/cacalabs/libcaca/archive/v0.99.beta19.tar.gz
#tar xzvf v0.99.beta19.tar.gz
#cd libcaca*
#./bootstrap
#./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static --disable-doc  --disable-ruby --disable-csharp --disable-java --disable-python --disable-cxx --enable-ncurses --disable-x11
#make -j ${FFMPEG_CPU_COUNT}
#make install
#make distclean
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libcaca"



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

#cd ${FFMPEG_HOME}/src/x265/build/linux
#cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DENABLE_SHARED:bool=off ../../source
#make -j ${FFMPEG_CPU_COUNT}

cd x265/
mkdir {build-8,build-10,build-12}

  cd build-12
  PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" cmake -G "Unix Makefiles" ../source \
    -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" \
    -DHIGH_BIT_DEPTH='TRUE' \
    -DMAIN12='TRUE' \
    -DEXPORT_C_API='FALSE' \
    -DENABLE_CLI='FALSE' \
    -DENABLE_SHARED:bool=off
  make -j ${FFMPEG_CPU_COUNT}
  
  cd ../build-10
  PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" cmake -G "Unix Makefiles" ../source \
    -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" \
    -DHIGH_BIT_DEPTH='TRUE' \
    -DEXPORT_C_API='FALSE' \
    -DENABLE_CLI='FALSE' \
    -DENABLE_SHARED:bool=off
  make -j ${FFMPEG_CPU_COUNT}

  cd ../build-8
  ln -s ../build-10/libx265.a libx265_main10.a
  ln -s ../build-12/libx265.a libx265_main12.a
  PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" cmake -G "Unix Makefiles" ../source \
    -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" \
    -DENABLE_SHARED:bool=off \
    -DENABLE_HDR10_PLUS='TRUE' \
    -DEXTRA_LIB='x265_main10.a;x265_main12.a' \
    -DEXTRA_LINK_FLAGS='-L .' \
    -DLINKED_10BIT='TRUE' \
    -DLINKED_12BIT='TRUE'
  make -j ${FFMPEG_CPU_COUNT}
  mv libx265.a libx265_main8.a

ar -M <<EOF
CREATE libx265.a
ADDLIB libx265_main8.a
ADDLIB libx265_main10.a
ADDLIB libx265_main12.a
SAVE
END
EOF

# make DESTDIR="${pkgdir}" install
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libx265"

cp ${FFMPEG_HOME}/build/bin/x265 ${FFMPEG_HOME}/bin/
########------------######## --bindir="${FFMPEG_HOME}/bin"   -DCMAKE_LIBRARY_OUTPUT_DIRECTORY="${FFMPEG_HOME}/bin" -DINSTALL_BIN_DIR="${FFMPEG_HOME}/bin"  


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
echo -e "\e[93mCompiling harfbuzz...\e[39m"
echo
cd ${FFMPEG_HOME}/src
#wget -O harfbuzz-2.3.1.tar.bz2 https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.3.1.tar.bz2
#tar xjvf harfbuzz-2.3.1.tar.bz2

wget -O harfbuzz.tar.bz2 https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.6.0.tar.xz
tar -xf harfbuzz-2.3.1.tar.bz2

cd harfbuzz*/
./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean



echo
echo -e "\e[93mCompiling frei0r...\e[39m"
echo
cd ${FFMPEG_HOME}/src
wget -O frei0r.tar.gz https://github.com/dyne/frei0r/archive/v1.6.1.tar.gz
tar xzvf frei0r.tar.gz
rm -f frei0r.tar.gz
cd frei0r*/
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0 -DCMAKE_BUILD_TYPE=Release -DWITHOUT_OPENCV=ON -DWITHOUT_GAVL=ON
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-frei0r --enable-filter=frei0r"



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
echo -e "\e[93mCompiling libopus...\e[39m"
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
echo -e "\e[93mCompiling libogg...\e[39m"
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
echo -e "\e[93mCompiling libvorbis...\e[39m"
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
#curl -L -O http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz 
#tar xvfz xvidcore-1.3.2.tar.gz
#rm -f xvidcore-1.3.2.tar.gz
#cd xvidcore/build/generic

wget -O xvidcore.tar.gz https://downloads.xvid.com/downloads/xvidcore-1.3.5.tar.gz
tar xvfz xvidcore.tar.gz
rm -f xvidcore.tar.gz
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
########------------######## --bindir="${FFMPEG_HOME}/bin"  -DCMAKE_LIBRARY_OUTPUT_DIRECTORY="${FFMPEG_HOME}/bin" -DINSTALL_BIN_DIR="${FFMPEG_HOME}/bin" 


echo
echo -e "\e[93mCompiling libilbc...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/TimothyGu/libilbc.git
cd libilbc
sed 's/lib64/lib/g' -i CMakeLists.txt
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0  
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libilbc"
########------------######## --bindir="${FFMPEG_HOME}/bin"  -DCMAKE_LIBRARY_OUTPUT_DIRECTORY="${FFMPEG_HOME}/bin" -DINSTALL_BIN_DIR="${FFMPEG_HOME}/bin" 



echo
echo -e "\e[93mCompiling librtmp...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 http://git.ffmpeg.org/rtmpdump.git librtmp
cd librtmp
make -j ${FFMPEG_CPU_COUNT} SYS=posix prefix="${FFMPEG_HOME}/build" CRYPTO=OPENSSL SHARED= XCFLAGS="-I${FFMPEG_HOME}/build/include" XLDFLAGS="-L${FFMPEG_HOME}/build/lib" bindir="${FFMPEG_HOME}/bin" install
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-librtmp"
########------------######## --bindir="${FFMPEG_HOME}/bin" -DCMAKE_LIBRARY_OUTPUT_DIRECTORY="${FFMPEG_HOME}/bin" 



echo
echo -e "\e[93mCompiling libsoxr...\e[39m"
echo
cd ${FFMPEG_HOME}/src
rm -rf soxr*
soxr_url="https://sourceforge.net/projects/soxr/files/soxr-0.1.3-Source.tar.xz"
wget $soxr_url
tar xvf soxr-0.1.3-Source.tar.xz
cd soxr*/

#mkdir build
#cd build
#cmake .. -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DHAVE_WORDS_BIGENDIAN_EXITCODE=0 -DBUILD_SHARED_LIBS:bool=off -DBUILD_TESTS:BOOL=OFF -DWITH_OPENMP:BOOL=OFF -DUNIX:BOOL=on -Wno-dev

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
rm -rf vidstab*
wget https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz
tar xzvf  v1.1.0.tar.gz
cd vid.stab*
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvidstab"



echo
echo -e "\e[93mCompiling zimg...\e[39m"
echo
cd ${FFMPEG_HOME}/src
rm -rf zimg* release-2.8.tar.gz
#wget -O zimg.tar.gz https://github.com/sekrit-twc/zimg/archive/release-2.8.tar.gz
wget -O zimg.tar.gz https://github.com/sekrit-twc/zimg/archive/release-2.9.2.tar.gz
tar xzvf  zimg.tar.gz
cd zimg*
./autogen.sh
./configure --prefix="${FFMPEG_HOME}/build"  --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libzimg"



##################### rubber band



echo
echo -e "\e[93mCompiling librubberband...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/lachs0r/rubberband.git
cd rubberband/
make -j ${FFMPEG_CPU_COUNT} PREFIX="${FFMPEG_HOME}/build" install-static
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-librubberband"


#libsamplerate_url="http://www.mega-nerd.com/SRC/libsamplerate-0.1.9.tar.gz"
#cd ${FFMPEG_HOME}/src
#rm -rf libsamplerate*
#wget $libsamplerate_url
#tar xzvf libsamplerate-0.1.9.tar.gz
#cd libsamplerate*
#./configure --prefix="${FFMPEG_HOME}/build"  --disable-shared --enable-static
#make -j ${FFMPEG_CPU_COUNT}
#make install
#make distclean


#libsendfile_url="http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.28.tar.gz"
#cd ${FFMPEG_HOME}/src
#rm -rf libsndfile*
#wget $libsendfile_url
#tar xzvf libsndfile-1.0.28.tar.gz
#cd libsndfile*
#./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
#####--disable-sqlite --disable-external-libs --disable-full-suite
#make -j ${FFMPEG_CPU_COUNT}
#make install
#make distclean



#fftw_url="http://www.fftw.org/fftw-3.3.8.tar.gz"
#cd ${FFMPEG_HOME}/src
#rm -rf fftw*
#wget $fftw_url
#tar xzvf fftw-3.3.8.tar.gz
#cd fftw*/
#./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
#make -j ${FFMPEG_CPU_COUNT}
#make install
#make distclean

#vamp_url="https://github.com/c4dm/vamp-plugin-sdk/archive/vamp-plugin-sdk-v2.8.tar.gz"
#cd ${FFMPEG_HOME}/src
#rm -rf vamp*
#wget $vamp_url
#tar xzvf vamp-plugin-sdk-v2.8.tar.gz
#cd vamp-*/
#PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
#make -j ${FFMPEG_CPU_COUNT}
#make install
#make distclean



#echo
#echo -e "\e[93mCompiling librubberband...\e[39m"
#echo
#cd ${FFMPEG_HOME}/src
#rm -rf rubberband*
#wget  https://breakfastquay.com/files/releases/rubberband-1.8.2.tar.bz2
#tar xjvf rubberband-1.8.2.tar.bz2
#cd rubberband*/
#PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build"  --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
#make -j ${FFMPEG_CPU_COUNT}
#make install

#make -j ${FFMPEG_CPU_COUNT} PREFIX="${FFMPEG_HOME}/build" install-static
#sed -i.bak 's/-lrubberband.*$/-lrubberband -lfftw3 -lsamplerate -lstdc++/' $PKG_CONFIG_PATH/rubberband.pc
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-librubberband"


# Full "--enable" list, just in case
# FFMPEG_ENABLE="--enable-gpl --enable-version3 --enable-nonfree --enable-runtime-cpudetect --enable-gray --enable-openssl --enable-libfreetype --enable-fontconfig --enable-libfribidi --enable-libass --enable-libcaca --enable-libvo-amrwbenc --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libx264 --enable-libx265 --enable-libfdk-aac --enable-libmp3lame --enable-libtwolame --enable-libopus --enable-libvorbis --enable-libspeex --enable-libvpx --enable-libxvid --enable-libtheora --enable-libwebp --enable-libopenjpeg --enable-libilbc --enable-librtmp --enable-libsoxr --enable-frei0r --enable-filter=frei0r --enable-libvidstab --enable-librubberband"


#git clone https://code.videolan.org/videolan/libbluray.git
#http://ftp.videolan.org/pub/videolan/libbluray/1.1.0/libbluray-1.1.0.tar.bz2

#yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/libbluray-0.2.3-5.el7.x86_64.rpm
# --enable-libbluray

# --enable-libxml2
# --enable-iconv



echo
echo -e "\e[93mCompiling Snappy...\e[39m"
echo
cd ${FFMPEG_HOME}/src
rm -rf snappy*
wget -O snappy.zip https://github.com/google/snappy/archive/1.1.7.zip
unzip snappy.zip
cd snappy*/
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DCMAKE_INSTALL_LIBDIR="${FFMPEG_HOME}/build/lib" -DBUILD_SHARED_LIBS=OFF -DSNAPPY_BUILD_TESTS=OFF
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libsnappy"



echo
echo -e "\e[93mCompiling libxml2...\e[39m"
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


echo
echo -e "\e[93mCompiling libbluray...\e[39m"
echo
cd ${FFMPEG_HOME}/src
rm -rf libbluray*
wget  http://ftp.videolan.org/pub/videolan/libbluray/1.1.0/libbluray-1.1.0.tar.bz2
tar xjvf libbluray-1.1.0.tar.bz2
cd libbluray*/
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build"  --bindir="${FFMPEG_HOME}/bin" --enable-static --disable-shared --disable-doxygen-doc --disable-doxygen-dot --disable-doxygen-html --disable-doxygen-ps --disable-doxygen-pdf --disable-doxygen-man --disable-doxygen-rtf --disable-doxygen-xml --disable-doxygen-chm --disable-doxygen-chi --disable-examples --disable-bdjava --disable-bdjava-jar 
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libbluray"

#####################################


echo
echo -e "\e[93mCompiling ffmpeg...\e[39m"
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
sed -i 's%^.*define LIBAVFORMAT_IDENT.*%#define LIBAVFORMAT_IDENT             "FastVideoEncoder.com"%' libavformat/version.h
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
echo -e "\e[93mCompiling qt-faststart...\e[39m"
echo
cd ${FFMPEG_HOME}/src
cd FFmpeg*/tools/
make qt-faststart
cp qt-faststart /usr/local/bin/
ldconfig

#################

yum -y install epel-release
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

cd /tmp
rm -rf exiftool*
wget -O exiftool.zip https://github.com/exiftool/exiftool/archive/11.63.zip
unzip exiftool.zip
rm -rf exiftool.zip
cd exiftool*
mv exiftool lib /usr/local/bin/
rm -rf /tmp/exiftool*

yum -y install easytag*
# easytag -v

cd /tmp
yum -y install http://li.nux.ro/download/nux/dextop/el7/x86_64//id3v2-0.1.12-7.el7.nux.x86_64.rpm
#id3v2 -v


yum -y install mkvtoolnix

# mkvpropedit -v
# mkvpropedit "foo.mkv" -e info -s title="This Is The Title"

# Will remove all global and non-global tags.
# mkvpropedit "input.mkv" --tags all:
# https://mkvtoolnix.download/doc/mkvpropedit.html



#FFMPEG_ENABLE="--enable-gpl --enable-version3 --enable-nonfree --enable-runtime-cpudetect --enable-gray --enable-openssl "
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libfreetype "
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-fontconfig "
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-zlib"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libfribidi"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libass"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvo-amrwbenc"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libopencore-amrnb --enable-libopencore-amrwb"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libx264"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libx265"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libfdk-aac"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-frei0r --enable-filter=frei0r"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libmp3lame"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libtwolame"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libopus"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvorbis"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libspeex"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvpx"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libxvid"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libtheora"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libwebp"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libopenjpeg"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libilbc"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-librtmp"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libsoxr"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvidstab"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libzimg"
#FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-librubberband"


#cd /tmp
#rm -rf libav*
#wget https://libav.org/releases/libav-12.3.tar.gz
#tar -xvzf libav-12.3.tar.gz
#rm -rf libav-12.3.tar.gz
#cd libav*/
#PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --extra-cflags="-I${FFMPEG_HOME}/build/include" --extra-ldflags="-L${FFMPEG_HOME}/build/lib" --extra-libs='-lpthread -lm -lz -ldl' --bindir="${FFMPEG_HOME}/bin" --pkg-config-flags="--static" --arch=x86_64 ${FFMPEG_ENABLE}
#make
#make install

# ./configure --help
# https://gi st.git hub.com/ Brai ni arc7 / 95c9338a 737aa36d9b b2931bed 379219
#################

echo
echo -e "\e[93mCompiling zenlib...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/MediaArea/ZenLib zenlib
cd zenlib/Project/CMake
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DLIB_INSTALL_DIR="${FFMPEG_HOME}/build/lib" -DBUILD_SHARED_LIBS=0
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

echo
echo -e "\e[93mCompiling mediainfolib...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/MediaArea/MediaInfoLib mediainfolib
cd mediainfolib/Project/CMake
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DLIB_INSTALL_DIR="${FFMPEG_HOME}/build/lib" -DBUILD_SHARED_LIBS=0
make -j ${FFMPEG_CPU_COUNT}
make install
sed -i 's|libzen|libcurl librtmp libzen|' "${FFMPEG_HOME}/build/lib/pkgconfig/libmediainfo.pc"
make distclean

echo
echo -e "\e[93mCompiling mediainfo...\e[39m"
echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/MediaArea/MediaInfo mediainfo
cd mediainfo/Project/GNU/CLI
./autogen.sh
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin"
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

source ~/.bashrc

ffmpeg
ffmpeg -h encoder=libx265 2>/dev/null | grep pixel
which ffmpeg

source ~/.bashrc

chmod 777 ${FFMPEG_HOME}/bin/*

# mediainfo -f --Output=JSON input.mkv
# ffprobe -v quiet -print_format json -show_format -show_streams input.mkv
# ffprobe -v quiet -print_format json -show_format -show_streams -show_chapters input.mkv
