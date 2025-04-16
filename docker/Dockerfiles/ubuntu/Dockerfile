FROM ubuntu:24.04

LABEL authors="antonio3a"

RUN apt update && \
    apt install -y \
    bash \
    ca-certificates \
    curl \
    git \
    openssh-client \
    tar \
    unzip \
    zip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ADD https://fnm.vercel.app/install /tmp/fnm-install.sh

ENV FNM_DIR="/root/.local/share/fnm"

RUN bash /tmp/fnm-install.sh && \
    rm /tmp/fnm-install.sh && \
    ${FNM_DIR}/fnm install 22 && \
    install -m 0755 -d /etc/apt/keyrings

ADD https://download.docker.com/linux/ubuntu/gpg /etc/apt/keyrings/docker.asc

RUN chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt update && \
    apt install -y \
    containerd.io \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ADD https://get.sdkman.io /tmp/sdk-install.sh

RUN bash /tmp/sdk-install.sh && \
    rm /tmp/sdk-install.sh

SHELL ["/bin/bash", "-c"]

RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk install maven && \
    sdk install gradle && \
    sdk install java 21.0.6-tem

LABEL authors="3A"