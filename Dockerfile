# Builder image
FROM archlinux:base-devel as builder

COPY mirrorlist /etc/pacman.d/mirrorlist

RUN set -ex; \
    pacman --noprogressbar --noconfirm -Sy git

USER nobody
WORKDIR /tmp
RUN set -ex; \
    git clone https://aur.archlinux.org/ttf-pt-public-pack.git; \
    cd ttf-pt-public-pack; \
    makepkg -s; \
    mv *.pkg.tar.zst ../.; \
    cd /tmp; \
    git clone https://github.com/t-richards/slimify.git; \
    cd slimify; \
    makepkg -s; \
    mv *.pkg.tar.zst ../.

# Runtime image
FROM archlinux:base
LABEL maintainer="Tom Richards <tom@tomrichards.net>" \
      org.label-schema.vcs-url="https://github.com/t-richards/docker-pandoc" \
      io.whalebrew.name="pandoc"

# custom packages
COPY --from=builder /tmp/*.pkg.tar.zst /opt/

# fix mirrors
COPY mirrorlist /etc/pacman.d/mirrorlist

RUN set -ex; \
    # 0. install updates
    pacman --noprogressbar --noconfirm -Syu; \
    # 1. install custom packages
    pacman --noprogressbar --noconfirm -U /opt/*.pkg.tar.zst; \
    # 2. install build tools, fonts, pandoc
    pacman --noprogressbar --noconfirm -Sy git openssh make ttf-droid ttf-hack ttf-liberation tex-gyre-fonts mpfr biber pandoc; \
    # 3. install texlive-most without texlive-fontsextra
    pacman --noprogressbar --noconfirm -Sy texlive-bibtexextra texlive-core texlive-formatsextra texlive-games texlive-humanities texlive-latexextra texlive-music texlive-pictures texlive-pstricks texlive-publishers texlive-science; \
    # 4. install helper tools
    pacman --noprogressbar --noconfirm -Sy github-cli

# fix path for biber
ENV PATH="${PATH}:/usr/bin/vendor_perl"

WORKDIR /workdir
ENTRYPOINT ["pandoc"]
