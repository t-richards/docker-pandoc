# Build image
FROM archlinux:20200908 as builder

COPY mirrorlist /etc/pacman.d/mirrorlist

RUN set -ex; \
    pacman --noprogressbar --noconfirm -Syyu base-devel git

USER nobody
WORKDIR /tmp
RUN set -ex; \
    git clone https://aur.archlinux.org/ttf-paratype; \
    cd ttf-paratype; \
    makepkg -s

# Runtime image
FROM archlinux:20200908
LABEL maintainer="Tom Richards <tom@tomrichards.net>"

# fix mirrors
COPY --from=builder /tmp/ttf-paratype/*.pkg.tar.zst /opt/
COPY mirrorlist /etc/pacman.d/mirrorlist

RUN set -ex; \
    # 0. install custom packages
    pacman --noconfirm -U /opt/*.pkg.tar.zst; \
    # 1. workaround for broken coreutils
    #    https://gitlab.archlinux.org/archlinux/archlinux-docker/-/issues/32#note_1895
    pacman --noconfirm -U https://archive.archlinux.org/packages/c/coreutils/coreutils-8.31-3-x86_64.pkg.tar.xz; \
    sed -i -e '/IgnorePkg *=/s/^.*$/IgnorePkg = coreutils/' /etc/pacman.conf; \
    # 2. install updates
    pacman --noprogressbar --noconfirm -Syyu; \
    # 3. install build tools, fonts, pandoc
    pacman --noprogressbar --noconfirm -S git openssh make ttf-droid ttf-hack ttf-liberation tex-gyre-fonts mpfr biber pandoc; \
    # 4. install texlive-most without texlive-fontsextra
    pacman --noprogressbar --noconfirm -S texlive-bibtexextra texlive-core texlive-formatsextra texlive-games texlive-humanities texlive-latexextra texlive-music texlive-pictures texlive-pstricks texlive-publishers texlive-science; \
    # 5. cleanup
    rm -rf \
        /usr/share/doc/* \
        /usr/share/man/* \
        /usr/share/info/* \
        /var/cache/pacman/pkg/* \
        /var/lib/pacman/sync/* \
        /var/log/*.log; \
    # 5. create working directory
    mkdir /workdir

# fix path for biber
ENV PATH="${PATH}:/usr/bin/vendor_perl"

# https://github.com/whalebrew/whalebrew
WORKDIR /workdir
LABEL io.whalebrew.name "pandoc"
ENTRYPOINT ["pandoc"]
