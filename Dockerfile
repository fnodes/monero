FROM debian:stable-slim
MAINTAINER Tyler Baker <forcedinductionz@gmail.com>

ARG VERSION=v0.15.0.0
ARG x64_checksum=53d9da55137f83b1e7571aef090b0784d9f04a980115b5c391455374729393f3
ARG armv8_checksum=f92f0acbc49076ad57337b5928981cd72c01aabe6a8eb69a1782f7fa1388fb77
ARG armv7_checksum=326f783ffde78694b2820c95aa310ead00bb5876937ed4edf9c1abd6b6aadc02

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    coreutils \
    file \
    bzip2 \
  && rm -rf /var/lib/apt/lists/*

RUN file /bin/bash | grep -q x86-64 && echo x64 > /tmp/arch || true
RUN file /bin/bash | grep -q aarch64 && echo armv8 > /tmp/arch || true
RUN file /bin/bash | grep -q EABI5 && echo armv7 > /tmp/arch || true

WORKDIR /src

RUN wget https://dlsrc.getmonero.org/cli/monero-linux-$(cat /tmp/arch)-${VERSION}.tar.bz2 \
  && eval echo \$$(cat /tmp/arch)_checksum monero-linux-$(cat /tmp/arch)-${VERSION}.tar.bz2 | sha256sum -c \
  && tar xvf monero-linux-$(cat /tmp/arch)-${VERSION}.tar.bz2 \
  && mkdir /root/.bitmonero \
  && mv monero-*/* /usr/local/bin/ \
  && rm -rf monero-*/ \
  && rm -rf monero-linux-$(cat /tmp/arch)-${VERSION}.tar.bz2

EXPOSE 18080 18081

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
