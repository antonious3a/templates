FROM ubuntu:24.04

LABEL authors="antonio3a"

SHELL ["/bin/bash", "-c"]
ENV HOME=/root

############### Packages #########################
RUN apt update && \
    apt install -y \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    openssh-client \
    tar \
    unzip \
    wget \
    xz-utils \
    zip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
###############################################


############### Node & Angular #########################
ENV NODE_VERSION=22.18.0
ENV NODE_DIST=node-v$NODE_VERSION-linux-x64
ENV NODE_TAR=$NODE_DIST.tar.xz
ENV NODE_URL=https://nodejs.org/dist/v$NODE_VERSION/$NODE_TAR
ENV NODE_DIR=/opt/nodejs

ADD $NODE_URL /tmp/$NODE_TAR
RUN mkdir -p "$NODE_DIR" \
    && tar -xf /tmp/"$NODE_TAR" -C "$NODE_DIR" --strip-components=1 \
    && rm /tmp/"$NODE_TAR"

ENV PATH="$NODE_DIR/bin:$PATH"
RUN npm install -g @angular/cli
###############################################


################# Docker ######################
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
###############################################


############## SDK Man ########################
ADD https://get.sdkman.io /tmp/sdk-install.sh
RUN bash /tmp/sdk-install.sh && \
    rm /tmp/sdk-install.sh
###############################################


############## Java #########################
ENV JAVA_HOME=$HOME/.sdkman/candidates/java/current
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk install java 25-oracle

ENV PATH="$JAVA_HOME/bin:$PATH"
###############################################


############## Maven #########################
ENV MAVEN_HOME=$HOME/.sdkman/candidates/maven/current
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk install maven 3.9.11

ENV PATH="$MAVEN_HOME/bin:$PATH"
###############################################


############## Gradle #########################
ENV GRADLE_HOME=$HOME/.sdkman/candidates/gradle/current
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk install gradle 9.1.0

ENV PATH="$GRADLE_HOME/bin:$PATH"
###############################################

###### Final Check ##############
RUN docker -v && \
    node -v && \
    npm -v  && \
    ng --version && \
    java --version && \
    mvn --version && \
    gradle --version

CMD ["/bin/bash"]

### docker build -t antonio3a/ubuntu:24.04-dev-tools .