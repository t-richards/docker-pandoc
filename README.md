# docker-pandoc

A working pandoc environment with LaTeX tools for PDF creation.

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
