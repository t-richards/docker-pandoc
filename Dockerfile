FROM archimg/base:2018.09.01
LABEL maintainer="Tom Richards <tom@tomrichards.net>"

# fix mirrors
COPY mirrorlist /etc/pacman.d/mirrorlist

# install packages
# pandoc, latex, fonts, and select build tools
RUN pacman --noprogressbar --noconfirm -Syy git openssh make ttf-droid tex-gyre-fonts mpfr texlive-most biber pandoc \
 && rm -rf \
    /usr/share/doc/* \
    /usr/share/man/* \
    /usr/share/info/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/* \
 && mkdir /source

# fix path for biber
ENV PATH="${PATH}:/usr/bin/vendor_perl"
