FROM paketobuildpacks/ubuntu-noble-run:0.0.31
LABEL authors="antonio3a"

USER root

RUN apt update && \
    apt install -y \
    --no-install-recommends \
    curl \
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-por && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

USER cnb

# docker build -t antonio3a/paketobuildpacks-ubuntu-noble-run:0.0.31 .