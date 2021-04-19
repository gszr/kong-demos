FROM kong:2.4.0-alpine

USER root

RUN apk add --no-cache nodejs npm python make gcc g++ libc-dev
RUN npm -g config set user root
RUN npm install typescript kong-pdk -g

USER kong

