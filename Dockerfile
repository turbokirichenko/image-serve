FROM openresty/openresty:1.21.4.1-0-alpine

WORKDIR /app/

COPY conf.d/ /app/conf.d/
COPY www/ /app/www/

RUN apk add --no-cache \
    curl \
    perl \
    imagemagick \
    imagemagick-dev
RUN opm get tom2nonames/lua-resty-imagick
RUN mkdir -p /app/cache/ \
    && mkdir -p /var/log/nginx/ \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 8080

ENTRYPOINT ["/usr/local/openresty/bin/openresty", "-c", "/app/conf.d/nginx.conf", "-g", "daemon off;"]
