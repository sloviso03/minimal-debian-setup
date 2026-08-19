#!/usr/bin/env bash
set -e

# Environment
NVIM_DATA="$HOME/.local/share/nvim"
NVIM_SITE="$NVIM_DATA/site"

# System Update
sudo apt update

# Dependencies
sudo apt install -y \
    neovim \
    clang \
    clangd \
    clang-format \
    clang-tidy \
    cmake \
    ninja-build \
    gdb \
    lldb \
    pkg-config \
    git \
    curl \
    tree-sitter-cli

# C# Language Server
if command -v dotnet >/dev/null 2>&1; then
    dotnet tool update --global csharp-ls 2>/dev/null || \
        dotnet tool install --global csharp-ls
else
    echo "WARNING: dotnet is not installed."
fi

# Directories
mkdir -p \
    "$NVIM_SITE/pack/paq/start" \
    "$NVIM_SITE/pack/themes/start"

# Paq
if [ ! -d "$NVIM_SITE/pack/paq/start/paq-nvim" ]; then
    git clone --depth 1 \
        https://github.com/savq/paq-nvim.git \
        "$NVIM_SITE/pack/paq/start/paq-nvim"
fi

# Nightfox
if [ ! -d "$NVIM_SITE/pack/themes/start/nightfox.nvim" ]; then
    git clone --depth 1 \
        https://github.com/EdenEast/nightfox.nvim \
        "$NVIM_SITE/pack/themes/start/nightfox.nvim"
fi

# nvim-cmp
if [ ! -d "$NVIM_SITE/pack/paq/start/nvim-cmp" ]; then
    git clone --depth 1 \
        https://github.com/hrsh7th/nvim-cmp.git \
        "$NVIM_SITE/pack/paq/start/nvim-cmp"
fi

# cmp-nvim-lsp
if [ ! -d "$NVIM_SITE/pack/paq/start/cmp-nvim-lsp" ]; then
    git clone --depth 1 \
        https://github.com/hrsh7th/cmp-nvim-lsp.git \
        "$NVIM_SITE/pack/paq/start/cmp-nvim-lsp"
fi

# nvim-treesitter
if [ ! -d "$NVIM_SITE/pack/paq/start/nvim-treesitter" ]; then
    git clone \
        --depth 1 \
        --branch master \
        https://github.com/nvim-treesitter/nvim-treesitter.git \
        "$NVIM_SITE/pack/paq/start/nvim-treesitter"
fi

# plenary.nvim
if [ ! -d "$NVIM_SITE/pack/paq/start/plenary.nvim" ]; then
    git clone --depth 1 \
        https://github.com/nvim-lua/plenary.nvim.git \
        "$NVIM_SITE/pack/paq/start/plenary.nvim"
fi

# Verification
nvim --version | head -n 1

if command -v csharp-ls >/dev/null 2>&1; then
    echo "csharp-ls: OK"
else
    echo "WARNING: csharp-ls is not in PATH."
fi

