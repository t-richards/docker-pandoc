# docker-pandoc

[![](https://images.microbadger.com/badges/image/trichards/pandoc.svg)](https://microbadger.com/images/trichards/pandoc)

A [pandoc][pandoc] environment with [LaTeX][latex] tools for excellent PDF creation.

# Requirements

 - Docker

# Getting started

```bash
# Compile myfile.md to myfile.pdf
$ docker run -v $(pwd):/source trichards/pandoc --from markdown --to latex -o myfile.pdf myfile.md
```

# Hacking

```bash
# Build image
$ docker build -t trichards/pandoc .
```

[latex]: https://www.latex-project.org/
[pandoc]: https://pandoc.org/
