ARG BASE_IMAGE="docker.io/ubuntu"
ARG TAG="noble"

FROM ${BASE_IMAGE}:${TAG}
LABEL authors="antonio3a"

USER root

ARG TAG
ARG PACKAGES=""

RUN if [ -n "$PACKAGES" ]; then \
      if command -v apt >/dev/null 2>&1; then \
        apt update && \
        apt install -y --no-install-recommends $PACKAGES && \
        apt clean; \
      elif command -v apk >/dev/null 2>&1; then \
        apk update && \
        apk add --no-cache $PACKAGES; \
      else \
        echo "Unsupported base image: no apt or apk found" && exit 1; \
      fi; \
    fi

USER cnb

# BASE_IMAGE="docker.io/ubuntu" && \
# TAG="noble" && \
# docker buildx build \
# --platform linux/amd64,linux/arm64 \
# --pull \
# --build-arg BASE_IMAGE=$BASE_IMAGE \
# --build-arg TAG=$TAG \
# --build-arg PACKAGES="wget curl" \
# --push \
# -t docker.io/antonio3a/buildpacks-run:$TAG \
# -t localhost/antonio3a/buildpacks-run:$TAG .
