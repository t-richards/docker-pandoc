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
    # 1. install custom packages from the builder stage
    pacman --noprogressbar --noconfirm -U /opt/*.pkg.tar.zst; \
    # 2. install build tools, fonts, pandoc
    pacman --noprogressbar --noconfirm -Sy git openssh make ttf-droid ttf-hack ttf-liberation tex-gyre-fonts mpfr biber pandoc; \
    # 3. install all of texlive without texlive-fontsextra
    # pactree -s texlive-meta -l -d 1 | grep -v texlive-fontsextra | grep -v texlive-meta | xargs echo
    pacman --noprogressbar --noconfirm -Sy texlive-bin texlive-basic texlive-bibtexextra texlive-binextra texlive-context texlive-fontsrecommended texlive-fontutils texlive-formatsextra texlive-games texlive-humanities texlive-latex texlive-latexextra texlive-latexrecommended texlive-luatex texlive-mathscience texlive-metapost texlive-music texlive-pictures texlive-plaingeneric texlive-pstricks texlive-publishers texlive-xetex
    # 4. install helper tools
    pacman --noprogressbar --noconfirm -Sy github-cli

# fix path for biber
ENV PATH="${PATH}:/usr/bin/vendor_perl"

WORKDIR /workdir
ENTRYPOINT ["pandoc"]
