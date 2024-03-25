FROM python:3.11-slim-bookworm

# run some apt-get installs, and clean up the cache to avoid stale apt repos
# Add the repository to Apt sources:
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        zlib1g-dev \
        clang \
        cmake \
        curl \
        gcc \
        git \
        gnupg \
        less \
        sudo \
        unzip \
        wget && \
        \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    chmod a+r /etc/apt/keyrings/nodesource.gpg && \
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    echo \
        "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | \
        sudo tee /etc/apt/sources.list.d/nodesource.list > /dev/null && \
    apt-get update && apt-get install -y --no-install-recommends \
        containerd.io \
        docker-ce \
        docker-ce-cli \
        docker-buildx-plugin \
        docker-compose-plugin \
        gh \
        lsof \
        jq \
        nodejs \
        zsh \
        vim \
        nano \
        python3.11-dev \
        && \
    apt-get clean \
    && rm -rf /usr/share/doc \
    && rm -rf /var/lib/apt/lists/*

# install bazel
ARG bazelversion
COPY scripts/install_bazel.sh .
RUN ./install_bazel.sh && rm ./install_bazel.sh

# create user and default settings for development tasks like git/docker
ARG user
ARG uid
ENV USER=${user}
ENV UID=${uid}
RUN groupadd --gid 121 cloud && \
    useradd --shell /bin/bash --uid ${UID} --create-home -g cloud "$USER" && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    newgrp docker && \
    usermod -aG docker $USER && \
    touch /etc/gitconfig && \
    git config --system --add safe.directory /cloud

USER "${USER}"
RUN git config --global --add safe.directory /cloud

WORKDIR /cloud
