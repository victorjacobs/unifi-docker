FROM debian:bookworm AS builder

ENV PKGURL=https://dl.ui.com/unifi/8.5.6/unifi_sysvinit_all.deb
ENV SHASUM=6690a813c38f6f715c2b37fb36eadff6afa0d81a5b8d9729d4bbd63ac57fb690

WORKDIR /tmp

RUN apt-get update && \
        apt-get install -y --no-install-recommends wget ca-certificates && \
        wget -q -O unifi.deb $PKGURL && \
        if [ "$SHASUM" != "$(sha256sum unifi.deb | awk '{print($1)}')" ];\
            then exit 1; fi; \
        useradd -u 1103 unifi


FROM debian:bookworm

COPY --from=builder /tmp/unifi.deb /tmp/unifi.deb
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

RUN apt-get update && \
        apt-get -y --no-install-recommends install binutils curl default-jre-headless procps && \
        rm -rf /var/lib/apt/lists/* && \
        dpkg --force-all -i /tmp/unifi.deb && \
        rm /tmp/unifi.deb && \
        ln -s /unifi /usr/lib/unifi/data && \
        mkdir -p /usr/lib/unifi/logs && \
        chown unifi:unifi /usr/lib/unifi/logs && \
        mkdir -p /usr/lib/unifi/run && \
        chown unifi:unifi /usr/lib/unifi/run && \
        mkdir -p /usr/lib/unifi/bin

COPY entrypoint.sh /usr/lib/unifi/entrypoint.sh
COPY scripts/mongod /usr/lib/unifi/bin

USER unifi
WORKDIR /usr/lib/unifi
EXPOSE 6789/tcp 8080/tcp 8443/tcp 8880/tcp 8843/tcp 3478/udp 10001/udp 1900/udp

ENTRYPOINT ["./entrypoint.sh"]
