FROM debian:stretch AS builder

ENV PKGURL https://dl.ui.com/unifi/5.11.39/unifi_sysvinit_all.deb
ENV SHASUM d2736dababcf96596a2c9ad82ee2fcbd02ee4d3a864284175b43f5afdab62f6c

WORKDIR /tmp

RUN apt-get update && \
        apt-get install -y --no-install-recommends wget ca-certificates && \
        wget -q -O unifi.deb $PKGURL && \
        if [ "$SHASUM" != "$(sha256sum unifi.deb | awk '{print($1)}')" ];\
            then exit 1; fi; \
        useradd -u 1103 unifi


FROM debian:stretch

COPY --from=builder /tmp/unifi.deb /tmp/unifi.deb
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

RUN apt-get update && \
        apt-get -y --no-install-recommends install binutils curl default-jre-headless jsvc && \
        rm -rf /var/lib/apt/lists/* && \
        dpkg --force-all -i /tmp/unifi.deb && \
        rm /tmp/unifi.deb && \
        ln -s /unifi /usr/lib/unifi/data && \
        mkdir /usr/lib/unifi/logs && \
        chown unifi:unifi /usr/lib/unifi/logs && \
        mkdir /usr/lib/unifi/run && \
        chown unifi:unifi /usr/lib/unifi/run

COPY entrypoint.sh /usr/lib/unifi/entrypoint.sh

USER unifi
WORKDIR /usr/lib/unifi
EXPOSE 6789/tcp 8080/tcp 8443/tcp 8880/tcp 8843/tcp 3478/udp

ENTRYPOINT ["./entrypoint.sh"]
