FROM paketobuildpacks/run-jammy-base:0.1.119

USER root

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libfreetype6 \
    fontconfig \
  && rm -rf /var/lib/apt/lists/*

USER cnb