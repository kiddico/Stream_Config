#!/usr/bin/env bash
tippytop="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# if its already running then stop it before we make any changes.
sudo systemctl stop nginx >/dev/null 2>&1 

sudo apt update
sudo apt install wget tar openssl libssl-dev zlib1g-dev libpcre3 build-essential ffmpeg git -y

sudo groupadd nginx -f
sudo useradd -g nginx nginx --system

# Grab the latest nginx source from their download page.
#   http://nginx.org/en/download.html
version=1.19.8
wget http://nginx.org/download/nginx-$version.tar.gz
tar -xf nginx-$version.tar.gz
mv nginx-$version nginx


# Do the same for nginx-rtmp-module
#   Also defaults to current dev, grab a stable release.
#   https://github.com/arut/nginx-rtmp-module/releases

git clone https://github.com/arut/nginx-rtmp-module
sed -i -e 's/NGINX RTMP (github.com\/arut\/nginx-rtmp-module)/Hi Mom!/g' nginx-rtmp-module/ngx_rtmp_codec_module.c

#cd nginx/conf
cd nginx
./configure \
	--user=nginx \
	--group=nginx \
	--prefix=/etc/nginx \
	--sbin-path=/usr/sbin/nginx \
	--conf-path=/etc/nginx/nginx.conf \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/nginx.lock \
	--with-http_ssl_module \
	--without-http_rewrite_module \
	--add-module=$tippytop/nginx-rtmp-module \
	--with-cc-opt="-march=native -flto"



make -j8
sudo make install

sudo cp $tippytop/nginx.conf /etc/nginx/
sudo cp $tippytop/nginx.service /etc/systemd/system/
sudo systemctl enable nginx
sudo systemctl start nginx

cd $tippytop
rm -rf nginx
rm -rf nginx-*
rm -rf *.gz
