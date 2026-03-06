ARG C_LIB="glibc"

FROM docker.io/bellsoft/buildpacks.alpaquita-run:${C_LIB}
LABEL authors="antonio3a"

USER root

ARG PACKAGES=""
RUN if [ -n "$PACKAGES" ]; then \
      apk update && \
      apk add --no-cache $PACKAGES; \
    fi

USER cnb

# C_LIB="glibc" && docker buildx build --pull --platform linux/amd64,linux/arm64 --build-arg C_LIB=$C_LIB --build-arg PACKAGES="wget curl" --push -t docker.io/antonio3a/bellsoft-buildpacks.alpaquita-run:$C_LIB -t quay.io/antonio3a/bellsoft-buildpacks.alpaquita-run:$C_LIB .
