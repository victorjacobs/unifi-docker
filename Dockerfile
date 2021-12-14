FROM debian:stretch AS builder

ENV PKGURL https://dl.ui.com/unifi/6.5.54/unifi_sysvinit_all.deb
ENV SHASUM 336818a8a662d1ccc581f5b1d2d4d6e376fe69456a4ba320fa68ac441f7f15eb

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
        apt-get -y --no-install-recommends install binutils curl default-jre-headless && \
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
EXPOSE 6789/tcp 8080/tcp 8443/tcp 8880/tcp 8843/tcp 3478/udp 10001/udp 1900/udp

ENTRYPOINT ["./entrypoint.sh"]
