FROM paketobuildpacks/run-jammy-base:latest
LABEL authors="antonio3a"

USER root

RUN apt update \
  && apt install -y --no-install-recommends \
    libfreetype6 \
    fontconfig \
  && rm -rf /var/lib/apt/lists/*

USER cnb