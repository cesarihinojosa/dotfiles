FROM ubuntu:24.04

ARG NVIM_VERSION=v0.12.2
ARG NODE_MAJOR=22

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
ENV XDG_CONFIG_HOME=$HOME/.config
ENV XDG_DATA_HOME=$HOME/.local/share
ENV XDG_STATE_HOME=$HOME/.local/state
ENV TERM=xterm-256color

RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    tar \
    gzip \
    build-essential \
    cmake \
    ripgrep \
    fd-find \
    python3 \
    python3-pip \
    python3-venv \
    ca-certificates \
    gnupg \
    neovim \
    clangd \
    && rm -rf /var/lib/apt/lists/*

# fd is installed as fdfind on Ubuntu — symlink to fd
RUN ln -sf "$(which fdfind)" /usr/local/bin/fd

# Install Node.js (needed by many Mason LSP servers)
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
       | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
       > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Copy nvim config
COPY nvim/ $XDG_CONFIG_HOME/nvim/

# Bootstrap lazy.nvim and install all plugins
RUN nvim --headless \
    -c "lua require('lazy').install({ wait = true })" \
    -c "qa"

# Install Treesitter parsers (languages matching your config)
RUN nvim --headless \
    -c "TSInstall c cpp lua python bash javascript typescript json yaml markdown markdown_inline vim vimdoc query regex" \
    -c "sleep 60" \
    -c "qa"

# Install Mason LSP servers and tools
RUN nvim --headless \
    -c "MasonInstall lua-language-server pyright bash-language-server stylua clang-format" \
    -c "sleep 60" \
    -c "qa"

# Verify installations
RUN nvim --version && \
    node --version && \
    git --version && \
    rg --version && \
    fd --version

WORKDIR /workspace

ENTRYPOINT ["nvim"]
