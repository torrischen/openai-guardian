FROM openresty/openresty:alpine

RUN apk add --no-cache perl make gcc libc-dev curl

RUN opm install ledgetech/lua-resty-http

RUN mkdir -p /usr/local/openresty/lualib

COPY auth.lua /usr/local/openresty/lualib/

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]