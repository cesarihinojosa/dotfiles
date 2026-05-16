FROM ubuntu:24.04

ARG NVIM_VERSION=v0.12.2

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
    clang-format \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "arm64" ]; then NVIM_ARCH="nvim-linux-arm64"; else NVIM_ARCH="nvim-linux-x86_64"; fi && \
    curl -LO https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_ARCH}.tar.gz \
    && tar xzf ${NVIM_ARCH}.tar.gz -C /opt \
    && ln -s /opt/${NVIM_ARCH}/bin/nvim /usr/local/bin/nvim \
    && rm ${NVIM_ARCH}.tar.gz

RUN useradd -m dev
USER dev

COPY --chown=dev:dev nvim/ /home/dev/.config/nvim/

WORKDIR /workspace

RUN nvim --headless "+Lazy! sync" +qa
RUN nvim --headless -c "MasonInstall pyright lua-language-server typescript-language-server" -c "sleep 60" -c "qa"

ENTRYPOINT ["nvim"]
