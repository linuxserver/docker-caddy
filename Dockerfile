FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="p3lim"

# package versions and plugins etc
ARG CADDY_ARCH="amd64"
ARG CADDY_PLUGS="http.ipfilter,http.login,http.jwt"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	libcap \
	inotify-tools && \
 echo "**** install caddy and plugins ****" && \
 curl -o \
 /tmp/caddy.tar.gz -L \
	"https://caddyserver.com/download/linux/${CADDY_ARCH}?license=personal&plugins=${CADDY_PLUGS}" && \
 tar -xf \
 /tmp/caddy.tar.gz -C \
	/usr/local/bin/ && \
 echo "**** give caddy permissions to use low ports ****" && \
 setcap cap_net_bind_service=+ep /usr/local/bin/caddy

# copy local files
COPY root/ /

# set home for the user (acme needs this)
ENV HOME /config

# ports and volumes
EXPOSE 80 443
VOLUME /config
