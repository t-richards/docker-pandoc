# Runtime image
FROM alpine:edge

# TODO(tom): Restore paratype fonts

RUN set -ex; \
    # 0. enable testing repo
    echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories; \
    # 1. install core packages
    apk add --no-cache --update git openssh make ttf-droid ttf-hack ttf-liberation mpfr4 biber pandoc; \
    # 2. install TeX Live
    apk add --no-cache --update texlive-full

WORKDIR /workdir
ENTRYPOINT ["pandoc"]
