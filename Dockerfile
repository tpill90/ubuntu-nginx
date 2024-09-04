FROM lancachenet/ubuntu:local
LABEL maintainer="LanCache.Net Team <team@lancache.net>"
ARG DEBIAN_FRONTEND=noninteractive

#TODO need to confirm if generic uses any of this
# Installing these here even though they are already in monolithic.  Speeds up testing a bit
# RUN apt-get update && \
#     apt-get install -y  jq git nano apt-transport-https ca-certificates --no-install-recommends && \
#     apt-get -y clean && \
#     rm -rf /var/lib/apt/lists/*

# # Installing packages required to build nginx
# RUN apt-get update && \
#     apt-get install -y inotify-tools build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev && \
#     apt-get -y clean && \
#     rm -rf /var/lib/apt/lists/*

# # Cloning the official mercurial repo and applying the patch
# RUN git clone -b MultirangePatch https://github.com/tpill90/nginx.git

# # Configuring the build options
# WORKDIR /nginx
# RUN chmod +x configure.sh
# RUN ./configure.sh \
#     --prefix=/usr/share/nginx  \
#     --sbin-path=/usr/sbin/nginx \
#     --conf-path=/etc/nginx/nginx.conf \
#     --http-log-path=/var/log/nginx/access.log \
#     --error-log-path=stderr \
#     --with-pcre  \
#     --lock-path=/var/lock/nginx.lock \
#     --pid-path=/run/nginx.pid \
#     --with-compat \
#     --with-debug \
#     --with-pcre-jit \
#     --with-threads \
#     --with-cc-opt='-g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/build/nginx-uqDps2/nginx-1.24.0=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection -fdebug-prefix-map=/build/nginx-uqDps2/nginx-1.24.0=/usr/src/nginx-1.24.0-2ubuntu7 -fPIC -Wdate-time -D_FORTIFY_SOURCE=3' \
#     --with-ld-opt='-Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -Wl,-z,relro -Wl,-z,now -fPIC' \
#     --modules-path=/usr/lib/nginx/modules \
#     --with-http_image_filter_module=dynamic \
#     --with-http_ssl_module \
#     --with-http_v2_module \
#     --with-stream \
#     --with-http_addition_module \
#     --with-http_slice_module \
#     --with-http_stub_status_module \
#     --with-http_realip_module \
#     --with-http_auth_request_module \
#     --with-http_dav_module \
#     --with-http_flv_module \
#     --with-http_gunzip_module \
#     --with-http_gzip_static_module \
#     --with-http_mp4_module \
#     --with-http_random_index_module \
#     --with-http_secure_link_module \
#     --with-http_sub_module \
#     --with-mail_ssl_module \
#     --with-stream_ssl_module \
#     --with-stream_ssl_preread_module \
#     --with-stream_realip_module

# RUN make build && make install

COPY overlay/ /
WORKDIR /
RUN \
    chmod 777 /opt/nginx/startnginx.sh && \
    rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default && \
    mkdir -p /etc/nginx/stream-enabled/ && \
    for SITE in /etc/nginx/sites-available/*; do [ -e "$SITE" ] || continue; ln -s $SITE /etc/nginx/sites-enabled/`basename $SITE`; done && \
    for SITE in /etc/nginx/stream-available/*; do [ -e "$SITE" ] || continue; ln -s $SITE /etc/nginx/stream-enabled/`basename $SITE`; done && \
    mkdir -p /var/www/html && chmod 777 /var/www/html && \
    mkdir -p /var/log/nginx && chmod -R 777 /var/log/nginx && \
    chmod -R 755 /hooks /init && \
    chmod 755 /var/www

EXPOSE 80
