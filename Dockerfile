FROM archimg/base:2018.01.01

MAINTAINER Tom Richards <tom@tomrichards.net>

# fix mirrors
COPY mirrorlist /etc/pacman.d/mirrorlist

# install pandoc and latex
RUN pacman --noconfirm -Syy pandoc texlive-most \
 && rm -rf \
    /usr/share/man/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/* \
 && mkdir /source

WORKDIR /source

ENTRYPOINT ["/usr/bin/pandoc"]

CMD ["--help"]
