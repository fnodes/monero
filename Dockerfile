FROM alpine:latest
MAINTAINER Tyler Baker <forcedinductionz@gmail.com>

ARG VERSION=v0.14.1.0
ARG GLIBC_VERSION=2.28-r0

ENV FILENAME monero-linux-x64-${VERSION}.tar.bz2
ENV DOWNLOAD_URL https://dlsrc.getmonero.org/cli/${FILENAME}

RUN apk update \
  && apk --no-cache add wget tar bash ca-certificates \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-bin-${GLIBC_VERSION}.apk \
  && apk --no-cache add eudev-libs \
  && rm -rf /glibc-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
  && wget $DOWNLOAD_URL \
  && tar xvf $FILENAME \
  && mkdir /root/.bitmonero \
  && mv monero-x86_64-linux-gnu/* /usr/local/bin/ \
  && rm -rf /monero-x86_64-linux-gnu/ \
  && rm -rf /$FILENAME \
  && apk del tar wget ca-certificates

EXPOSE 18080 18081

ADD ./bin/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
