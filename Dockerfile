FROM debian:stable-slim
MAINTAINER Tyler Baker <forcedinductionz@gmail.com>

ARG VERSION=v0.15.0.1

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    coreutils \
    file \
    gpg \
    bzip2 \
  && rm -rf /var/lib/apt/lists/*

RUN file /bin/bash | grep -q x86-64 && echo x64 > /tmp/arch || true
RUN file /bin/bash | grep -q aarch64 && echo armv8 > /tmp/arch || true
RUN file /bin/bash | grep -q EABI5 && echo armv7 > /tmp/arch || true

WORKDIR /src

RUN wget https://dlsrc.getmonero.org/cli/monero-linux-$(cat /tmp/arch)-${VERSION}.tar.bz2

RUN wget https://getmonero.org/downloads/hashes.txt

RUN wget https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/fluffypony.asc \ 
  && cat fluffypony.asc | gpg --import \
  && gpg --list-keys --fingerprint |grep pub -A 1|egrep -Ev "pub|--"|tr -d ' ' | awk 'BEGIN { FS = "\n" } ; { print $1":6:" } ' | gpg --import-ownertrust \
  && cat hashes.txt | gpg --verify

RUN cat hashes.txt | grep monero-linux-$(cat /tmp/arch)-${VERSION}.tar.bz2 | cut -d , -f 2 | sed 's/^ *//g' > hash \
  && echo $(cat hash) monero-linux-$(cat /tmp/arch)-${VERSION}.tar.bz2  | sha256sum -c \
  && tar xvf monero-linux-$(cat /tmp/arch)-${VERSION}.tar.bz2 \
  && mkdir /root/.bitmonero \
  && mv monero-*/* /usr/local/bin/ \
  && rm -rf monero-*/ \
  && rm -rf monero-linux-$(cat /tmp/arch)-${VERSION}.tar.bz2

EXPOSE 18080 18081

ADD bin/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
