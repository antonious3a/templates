FROM paketobuildpacks/run-jammy-base:0.1.143
LABEL authors="antonio3a"

USER root

RUN apt update && \
    apt install -y \
    --no-install-recommends \
    curl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

USER cnb

# docker build -t antonio3a/paketobuildpacks-run-jammy-base:0.1.138 .