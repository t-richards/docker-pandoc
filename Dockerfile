FROM archlinux:20200306
LABEL maintainer="Tom Richards <tom@tomrichards.net>"

# fix mirrors
COPY mirrorlist /etc/pacman.d/mirrorlist

# 0. workaround for broken coreutils
#    https://github.com/archlinux/archlinux-docker/issues/32
# 1. install updates
# 2. install build tools, fonts, pandoc
# 3. install texlive-most without texlive-fontsextra
# 4. cleanup
RUN sed -i -e '/IgnorePkg *=/s/^.*$/IgnorePkg = coreutils/' /etc/pacman.conf \
 && pacman --noprogressbar --noconfirm -Syyu \
 && pacman --noprogressbar --noconfirm -S git openssh make ttf-droid ttf-liberation tex-gyre-fonts mpfr biber pandoc \
 && pacman --noprogressbar --noconfirm -S texlive-bibtexextra texlive-core texlive-formatsextra texlive-games texlive-humanities texlive-latexextra texlive-music texlive-pictures texlive-pstricks texlive-publishers texlive-science \
 && rm -rf \
    /usr/share/doc/* \
    /usr/share/man/* \
    /usr/share/info/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/* \
 && mkdir /source

# fix path for biber
ENV PATH="${PATH}:/usr/bin/vendor_perl"

# Set working directory
WORKDIR /source
