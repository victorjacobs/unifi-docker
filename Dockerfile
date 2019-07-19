FROM debian:stretch AS builder

ENV PKGURL https://dl.ui.com/unifi/5.10.25/unifi_sysvinit_all.deb
ENV SHASUM bd39c9f2953736582f9707e120b7ed9cc9e023ce9a727ec6a74627d0f0c903ec

WORKDIR /tmp

RUN apt-get update && \
        apt-get install -y --no-install-recommends wget ca-certificates
RUN wget -q -O unifi.deb $PKGURL
RUN if [ "$SHASUM" != "$(sha256sum unifi.deb | awk '{print($1)}')" ];\
    then exit 1; fi;


FROM debian:stretch

COPY --from=builder /tmp/unifi.deb /tmp/unifi.deb

RUN apt-get update && \
        apt-get -y --no-install-recommends install binutils curl default-jre-headless jsvc && \
        rm -rf /var/lib/apt/lists/* && \
        dpkg --force-all -i /tmp/unifi.deb && \
        rm /tmp/unifi.deb && \
        ln -s /unifi /usr/lib/unifi/data

COPY entrypoint.sh /usr/lib/unifi/entrypoint.sh

WORKDIR /usr/lib/unifi

EXPOSE 6789/tcp 8080/tcp 8443/tcp 8880/tcp 8843/tcp 3478/udp

ENTRYPOINT ["./entrypoint.sh"]
