FROM docker.io/bellsoft/buildpacks.alpaquita-run:musl
LABEL authors="antonio3a"

USER root

RUN apk update && \
    apk add --no-cache \
    curl \
    fontconfig \
    freetype \
    ttf-dejavu

USER cnb

# docker buildx build --platform linux/amd64,linux/arm64 --push -t docker.io/antonio3a/bellsoft-buildpacks.alpaquita-run:musl -t quay.io/antonio3a/bellsoft-buildpacks.alpaquita-run:musl .