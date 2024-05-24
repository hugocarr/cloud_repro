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
        wget \
        python3.11-dev \
        libgdal-dev \
        libproj-dev \
        htop \
        && \
    apt-get clean \
    && rm -rf /usr/share/doc \
    && rm -rf /var/lib/apt/lists/*

# install bazel
ARG bazelversion
COPY scripts/install_bazel.sh .
RUN ./install_bazel.sh && rm ./install_bazel.sh

# create user and default settings for development tasks like git/docker
RUN groupadd --gid 121 cloud
RUN useradd --shell /bin/bash --create-home -g cloud "nonroot" 
RUN echo "$nonroot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER "nonroot"
WORKDIR /cloud
