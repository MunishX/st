#!/bin/sh

  echo ""
  echo "############## FFMPEG INSTALLATION STARTING #################"
  echo ""


Root_Dir="/usr/local"
FF_Source="$Root_Dir/ffmpeg_sources"
FF_Build="$Root_Dir/ffmpeg_build"

PreFix_Dir="$FF_Build"

BUILD_DIR=$FF_Source
TARGET_DIR=$FF_Build
BIN_DIR="$Root_Dir/ffbin"

start_log(){
  echo ""
  echo ""
  echo "=============== $1 ==============="
  echo ""
}
end_log(){
  echo ""
  echo ">>>>>>>>>>>>>>> SUCCESS <<<<<<<<<<<<<<<"
  echo ""
  echo ""
}
cmd_log(){
  echo "\$ $1"
}

create_dir(){
  #echo "removing and creating dirs $1 $2 $3"
  #rm -rf  $1 $2 $3
  #mkdir -p $1 $2 $3
  start_log "creating initial dir"
  #cmd_log "rm -rf \"$BUILD_DIR\" \"$TARGET_DIR\" \"$BIN_DIR\""
  rm -rf "$BUILD_DIR" "$TARGET_DIR" "$BIN_DIR"
  mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$BIN_DIR"
  end_log
}

download(){
  x_tmp="${1}_url"
  x_name="${1}${2}"
  eval x_url=( \${$x_tmp}) 
  
  cd $BUILD_DIR
  start_log "downloading $1"
  wget -O "${x_name}" "${x_url}"
  tar ${3} "${x_name}" 
  end_log
}

installing(){
  start_log "Installing $1"
  cd $BUILD_DIR
  cd $1*
}
echo "#### FFmpeg static build ####"


#cd $FF_Source
#curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
#tar xzvf yasm-1.3.0.tar.gz
#cd yasm-1.3.0

yasm_url="http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
nasm_url="https://www.nasm.us/pub/nasm/releasebuilds/2.14/nasm-2.14.tar.gz"
openssl_url="https://github.com/openssl/openssl/archive/OpenSSL_1_1_1b.tar.gz"

zlib_url="https://github.com/madler/zlib/archive/v1.2.11.tar.gz"
x264_url="http://download.videolan.org/pub/videolan/x264/snapshots/last_x264.tar.bz2"
x265_url="https://bitbucket.org/multicoreware/x265/downloads/x265_3.0.tar.gz"
fdk_url="https://github.com/mstorsjo/fdk-aac/archive/v2.0.0.tar.gz"
harfbuzz_url="https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.3.1.tar.bz2"
fribidi_url="https://github.com/fribidi/fribidi/releases/download/v1.0.5/fribidi-1.0.5.tar.bz2"
libass_url="https://github.com/libass/libass/releases/download/0.14.0/libass-0.14.0.tar.gz"
lame_url="http://download.videolan.org/pub/contrib/lame/lame-3.100.tar.gz"
# http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz

opus_url="https://github.com/xiph/opus/archive/v1.3.tar.gz"
libvpx_url="https://github.com/webmproject/libvpx/archive/v1.8.0.tar.gz"

rtmpdump_url="https://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz"
soxr_url="https://sourceforge.net/projects/soxr/files/soxr-0.1.3-Source.tar.xz"
# https://excellmedia.dl.sourceforge.net/project/soxr/soxr-0.1.3-Source.tar.xz

vid_url="https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz"
zimg_url="https://github.com/sekrit-twc/zimg/archive/release-2.8.tar.gz"
openjpeg_url="https://github.com/uclouvain/openjpeg/releases/download/v2.3.0/openjpeg-v2.3.0-linux-x86_64.tar.gz"
libwebp_url="https://github.com/webmproject/libwebp/archive/v1.0.2.tar.gz"
vorbis_url="https://github.com/xiph/vorbis/archive/v1.3.6.tar.gz"
libogg_url="https://github.com/xiph/ogg/releases/download/v1.3.3/libogg-1.3.3.tar.gz"
speex_url="https://github.com/xiph/speex/archive/Speex-1.2.0.tar.gz"
ffmpeg_url="http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2"



yum -y install zip unzip nano wget curl git yum-utils openssl-devel
#yum-config-manager --add-repo http://www.nasm.us/nasm.repo
#yum install -y nasm 
yum -y install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ libtool make mercurial pkgconfig zlib-devel

create_dir "$BUILD_DIR" "$TARGET_DIR" "$BIN_DIR"

#this is our working directory
cd $BUILD_DIR

#tar.gz
#tar xzvf yasm${ext}


ext=".tar.gz"
extract="xzvf"
download "yasm" $ext $extract
download "nasm" $ext $extract
download "openssl" $ext $extract
download "zlib" $ext $extract


ext=".tar.bz2"
extract="xjvf"
download "x264" $ext $extract

ext=".tar.gz"
extract="xzvf"
download "x265" $ext $extract
download "fdk" $ext $extract

ext=".tar.bz2"
extract="xjvf"
download "harfbuzz" $ext $extract
download "fribidi" $ext $extract

ext=".tar.gz"
extract="xzvf"
download "libass" $ext $extract
download "lame" $ext $extract
download "opus" $ext $extract
download "libvpx" $ext $extract
download "rtmpdump" $ext $extract

ext=".tar.xz"
extract="xvf"
download "soxr" $ext $extract

ext=".tar.gz"
extract="xzvf"
download "vid" $ext $extract
download "zimg" $ext $extract
download "openjpeg" $ext $extract
download "libwebp" $ext $extract
download "vorbis" $ext $extract
download "libogg" $ext $extract
download "speex" $ext $extract

ext=".tar.bz2"
extract="xjvf"
download "ffmpeg" $ext $extract



##################################################################################3

installing yasm
./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR
make -j $jval
make install
make distclean
source ~/.bash_profile


installing nasm
./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR
make -j $jval
make install
make distclean
source ~/.bash_profile

installing openssl
PATH="$BIN_DIR:$PATH" 
./config --prefix=$TARGET_DIR
#PATH="$BIN_DIR:$PATH" 
make -j $jval
make install
make distclean
source ~/.bash_profile


installing zlib
PATH="$BIN_DIR:$PATH" 
./configure --prefix=$TARGET_DIR
make -j $jval
make install
make distclean
source ~/.bash_profile


installing x264
PATH="$BIN_DIR:$PATH" 
./configure --prefix=$TARGET_DIR --enable-static --disable-shared --disable-opencl --enable-pic
make -j $jval
make install
make distclean
source ~/.bash_profile


installing x265
cd build/linux
find . -mindepth 1 ! -name 'make-Makefiles.bash' -and ! -name 'multilib.sh' -exec rm -r {} +
PATH="$BIN_DIR:$PATH" 
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:BOOL=OFF -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
sed -i 's/-lgcc_s/-lgcc_eh/g' x265.pc
make -j $jval
make install
make distclean
source ~/.bash_profile


installing fdk
autoreconf -fiv
./configure --prefix=$TARGET_DIR --disable-shared 
make -j $jval
make install
make distclean
source ~/.bash_profile

########

installing harfbuzz
./configure --prefix=$TARGET_DIR --disable-shared --enable-static
make -j $jval
make install
make distclean
source ~/.bash_profile

installing fribidi
./configure --prefix=$TARGET_DIR --disable-shared --enable-static --disable-docs
make -j $jval
make install
make distclean
source ~/.bash_profile

installing libass
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install
make distclean
source ~/.bash_profile

installing mp3lame
./configure --prefix=$TARGET_DIR --enable-nasm --disable-shared
make -j $jval
make install
make distclean
source ~/.bash_profile


installing opus
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install
make distclean
source ~/.bash_profile

installing libvpx
PATH="$BIN_DIR:$PATH"
./configure --prefix=$TARGET_DIR --disable-examples --disable-unit-tests --enable-pic
make -j $jval
make install
make distclean
source ~/.bash_profile

installing librtmp
cd librtmp
sed -i "/INC=.*/d" ./Makefile # Remove INC if present from previous run.
sed -i "s/prefix=.*/prefix=${TARGET_DIR_SED}\nINC=-I\$(prefix)\/include/" ./Makefile
sed -i "s/SHARED=.*/SHARED=no/" ./Makefile
make install_base


#######



echo "*** Building libsoxr ***"
cd $BUILD_DIR/soxr-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off
make -j $jval
make install

echo "*** Building libvidstab ***"
cd $BUILD_DIR/vid.stab-release-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
sed -i "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR"
make -j $jval
make install

echo "*** Building openjpeg ***"
cd $BUILD_DIR/openjpeg-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off
make -j $jval
make install

echo "*** Building zimg ***"
cd $BUILD_DIR/zimg-release-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --enable-static  --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libwebp ***"
cd $BUILD_DIR/libwebp*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libvorbis ***"
cd $BUILD_DIR/vorbis*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libogg ***"
cd $BUILD_DIR/ogg*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libspeex ***"
cd $BUILD_DIR/speex*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

# FFMpeg
echo "*** Building FFmpeg ***"
cd $BUILD_DIR/ffmpeg*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true

[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" \
PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig" ./configure \
  --prefix="$TARGET_DIR" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$TARGET_DIR/include" \
  --extra-ldflags="-L$TARGET_DIR/lib" \
  --extra-libs="-lpthread -lm -lz" \
  --extra-ldexeflags="-static" \
  --bindir="$BIN_DIR" \
  --enable-pic \
  --enable-ffplay \
  --enable-fontconfig \
  --enable-frei0r \
  --enable-gpl \
  --enable-version3 \
  --enable-libass \
  --enable-libfribidi \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopencore-amrnb \
  --enable-libopencore-amrwb \
  --enable-libopenjpeg \
  --enable-libopus \
  --enable-librtmp \
  --enable-libsoxr \
  --enable-libspeex \
  --enable-libtheora \
  --enable-libvidstab \
  --enable-libvo-amrwbenc \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libwebp \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libxvid \
  --enable-libzimg \
  --enable-nonfree \
  --enable-openssl

PATH="$BIN_DIR:$PATH" make -j $jval
make install
make distclean
hash -r
