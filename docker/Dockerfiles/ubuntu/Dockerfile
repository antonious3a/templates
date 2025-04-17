FROM ubuntu:24.04

LABEL authors="antonio3a"

SHELL ["/bin/bash", "-c"]
ENV HOME=/root

RUN apt update && \
    apt install -y \
    ca-certificates \
    curl \
    git \
    openssh-client \
    tar \
    unzip \
    xz-utils \
    zip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*


############### Node #########################
ENV NODE_VERSION=22.14.0
ENV NODE_DIST=node-v$NODE_VERSION-linux-x64
ENV NODE_TAR=$NODE_DIST.tar.xz
ENV NODE_URL=https://nodejs.org/dist/v$NODE_VERSION/$NODE_TAR
ENV NODE_DIR=/opt/nodejs

ADD $NODE_URL /tmp/$NODE_TAR
RUN mkdir -p "$NODE_DIR" \
    && tar -xf /tmp/"$NODE_TAR" -C "$NODE_DIR" --strip-components=1 \
    && rm /tmp/"$NODE_TAR"

ENV PATH="$NODE_DIR/bin:$PATH"
RUN node -v && npm -v
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
    sdk install java 21.0.6-tem

ENV PATH="$JAVA_HOME/bin:$PATH"
RUN java --version
###############################################


############## Maven #########################
ENV MAVEN_HOME=$HOME/.sdkman/candidates/maven/current
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk install maven

ENV PATH="$MAVEN_HOME/bin:$PATH"
RUN mvn --version
###############################################


############## Gradle #########################
ENV GRADLE_HOME=$HOME/.sdkman/candidates/gradle/current
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk install gradle

ENV PATH="$GRADLE_HOME/bin:$PATH"
RUN gradle --version
###############################################

###### Final Check ##############
RUN docker -v && \
    node -v && \
    npm -v  && \
    java --version && \
    mvn --version && \
    gradle --version

CMD ["/bin/bash"]