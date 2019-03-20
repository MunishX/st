#!/usr/bin/env bash


## PH-JS
cd /tmp
rm -rf phantomjs-2.1.1-linux-x86_64*
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2
mv phantomjs-2.1.1-linux-x86_64/bin/* /usr/local/bin/
echo "PH-JS Install Complete"
echo ""


## YT-DL install
cd /tmp
rm -rf /usr/local/bin/youtube-dl
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
echo "YT-DL Install Complete"
echo ""


#chmod 777 /usr/local/bin/*

echo ""
echo "Phantomjs Version : "
phantomjs -v
echo ""
echo "Youtube-dl Version : "
youtube-dl -U

echo "--- DONE ---"
