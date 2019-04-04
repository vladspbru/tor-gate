FROM    alpine

LABEL   name="tor-gate"

ENV     HOME /var/lib/tor

RUN     apk add --no-cache git libevent-dev openssl-dev gcc make automake ca-certificates autoconf musl-dev coreutils zlib zlib-dev && \
        mkdir -p /usr/local/src/ && \
        git clone https://git.torproject.org/tor.git /usr/local/src/tor && \
        cd /usr/local/src/tor && \
        git checkout $(git branch -a | grep 'release' | sort -V | tail -1) && \
        ./autogen.sh && \
        ./configure \
            --disable-asciidoc \
            --sysconfdir=/etc \
            --disable-unittests && \
        make && make install && \
        cd .. && \
        rm -rf tor && \
        apk del git libevent-dev openssl-dev make automake gcc autoconf musl-dev coreutils && \
        apk add --no-cache libevent openssl curl && \
        tor --version > /version

COPY    torrc /etc/tor/torrc
RUN     mkdir -p ${HOME}/.tor && \
        addgroup -S -g 107 tor && \
        adduser -S -G tor -u 104 -H -h ${HOME} tor

HEALTHCHECK --timeout=30s --start-period=90s \
    CMD curl --fail --socks5-hostname localhost:9050 -I -L 'https://cdnjs.com/' || exit 1


VOLUME  ["/var/lib/tor/hidden_service/"]

EXPOSE 9050

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["tor", "-f", "/etc/tor/torrc"]
