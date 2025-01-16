FROM paketobuildpacks/run-jammy-tiny:latest
LABEL authors="antonio3a"

USER root

RUN apt update \
    && apt install -y --no-install-recommends \
    curl \
    fontconfig \
    libfreetype6 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

USER cnb

# docker build -t antonio3a/paketobuildpacks-run-jammy-tiny:latest .