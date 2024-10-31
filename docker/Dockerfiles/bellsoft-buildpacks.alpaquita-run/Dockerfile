FROM bellsoft/buildpacks.alpaquita-run:musl
LABEL authors="antonio3a"

USER root

RUN apk update \
    && apk add --no-cache \
    curl \
    fontconfig \
    freetype \
    ttf-dejavu

USER cnb

# docker build -t antonio3a/bellsoft-buildpacks.alpaquita-run:musl .