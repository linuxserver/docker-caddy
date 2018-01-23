FROM lsiobase/alpine:3.7

LABEL maintainer="p3lim"
ARG plugins="http.ipfilter,http.login,http.jwt"

# install dependencies
RUN apk add --no-cache curl

# install caddy with plugins
RUN curl -fsSL "https://caddyserver.com/download/linux/amd64?license=personal&plugins=$plugins" -o /tmp/caddy && \
	tar -xzf /tmp/caddy -C /usr/local/bin/ caddy && \
	caddy -version

# copy local files
COPY root/ /

# expose ourselves
EXPOSE 80 443
VOLUME /config

# run caddy
CMD ["/usr/local/bin/caddy", "-conf", "/config/Caddyfile", "-root", "/config/www"]
