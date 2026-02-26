FROM docker.io/paketobuildpacks/ubuntu-noble-run:latest
LABEL authors="antonio3a"

USER root

RUN apt update && \
    apt install -y \
    --no-install-recommends \
    curl \
    wget \
#    fontconfig \
#    libfreetype6 \
#    fonts-dejavu-core \
#    fonts-dejavu-extra \
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-por \
  && rm -rf /var/lib/apt/lists/* && \
    apt clean

USER cnb

# docker build -t antonio3a/paketobuildpacks-ubuntu-noble-run:0.0.51 .