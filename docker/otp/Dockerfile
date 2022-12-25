FROM alpine:latest AS builder

ARG PLEROMA_VER=stable

ARG FLAVOUR=amd64-musl

#RUN export FLAVOUR=`arch="$(uname -m)";if [ "$arch" = "x86_64" ];then arch="amd64";elif [ "$arch" = "armv7l" ];then arch="arm";elif [ "$arch" = "aarch64" ];then arch="arm64";else echo "Unsupported arch: $arch">&2;fi;if getconf GNU_LIBC_VERSION>/dev/null;then libc_postfix="";elif [ "$(ldd 2>&1|head -c 9)" = "musl libc" ];then libc_postfix="-musl";elif [ "$(find /lib/libc.musl*|wc -l)" ];then libc_postfix="-musl";else echo "Unsupported libc">&2;fi;echo "$arch$libc_postfix"`

RUN apk add --no-cache \
    curl \
    unzip

RUN echo $FLAVOUR \
    && echo $PLEROMA_VER

ARG NOW_DATETIME
RUN echo $NOW_DATETIME

RUN curl https://git.pleroma.social/api/v4/projects/2/jobs/artifacts/${PLEROMA_VER}/download?job=${FLAVOUR} -o /tmp/pleroma.zip \
    && unzip /tmp/pleroma.zip -d /tmp/pleroma/ \
    && rm /tmp/pleroma.zip

FROM alpine:latest

RUN apk -U upgrade \
    && apk add --no-cache \
    ncurses \
    file-dev \
    imagemagick \
    ffmpeg \
    exiftool \
    unzip

ARG UID=911
ARG GID=911
ENV MIX_ENV=prod

RUN addgroup -g ${GID} pleroma \
    && adduser --system --shell /bin/false --home /opt/pleroma -D -G pleroma -u ${UID} pleroma

COPY --from=builder --chown=pleroma:root /tmp/pleroma/release/ /opt/pleroma

RUN mkdir --parents /var/lib/pleroma /etc/pleroma \
    && chown -R pleroma /var/lib/pleroma /etc/pleroma

USER pleroma

VOLUME ["/var/lib/pleroma/uploads", "/var/lib/pleroma/static", "/etc/pleroma"]

ENTRYPOINT ["/opt/pleroma/bin/pleroma"]

CMD ["start"]

EXPOSE 4000/tcp
