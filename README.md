# docker-pandoc

A [pandoc][pandoc] environment with [LaTeX][latex] tools for excellent PDF creation.

## Requirements

 - Docker

## Getting started (whalebrew)

```bash
# Install shim to /usr/local/bin
whalebrew install ghcr.io/trichards/pandoc

# Run pandoc as though it were installed locally
pandoc --version
```

## Getting started (manual)

```bash
# Compile myfile.md to myfile.pdf
$ docker run -v $(pwd):/workdir ghcr.io/trichards/pandoc --from markdown --to latex -o myfile.pdf myfile.md

# Run default make target
$ docker run -v $(pwd):/workdir --entrypoint=/usr/bin/make ghcr.io/trichards/pandoc
```

## Hacking

```bash
# Build image
$ docker build -t ghcr.io/trichards/pandoc .
```

[latex]: https://www.latex-project.org/
[pandoc]: https://pandoc.org/
