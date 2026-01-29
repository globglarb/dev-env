FROM debian:trixie-slim

RUN apt-get update

# linux dependencies and tools
# ncurses is a TUI library
RUN apt-get upgrade && apt-get install -y --fix-missing git-all curl gzip gcc wget unzip trash-cli ncurses-term

# some search tools and a terminal git interface
RUN apt-get install -y fzf fd-find ripgrep lazygit

# latest tree-sitter CLI tool for parsing / highlighting code
RUN curl -OL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz" && gunzip "tree-sitter-linux-x64.gz" && mv tree-sitter-linux-x64 /usr/local/bin/tree-sitter && chmod +x /usr/local/bin/tree-sitter
# configure parent docker process inside docker

# install python 3.14

# git config 
RUN git config --global user.name "Christian"
RUN git config --global user.email "ch.baczynski@protonmail.com"
RUN git config --global --add safe.directory '*'

# install latest stable neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && tar -xzf nvim-linux-x86_64.tar.gz && tar -C /opt -xzf nvim-linux-x86_64.tar.gz 
# clean up and symlink in /usr/local/bin to nvim to add to Path
RUN rm nvim-linux-x86_64.tar.gz && cd /usr/local/bin && ln -s /opt/nvim-linux-x86_64/bin/nvim nvim

# set env, as $HOME is only available in RUN commands
ENV HOME=/root
COPY nvim_config ${HOME}/.config/nvim

# install language dependencies
# install nodejs/npm
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
  && apt-get install -y nodejs

# Python
RUN apt-get install -y python3-venv python3-pip

# Docker client
RUN apt-get install -y \
    ca-certificates gnupg \
    lsb-release && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /workspace
CMD ["nvim"]

# TODO
# add CMD to docker to run tmux script to start dependencies like docker compose stack
