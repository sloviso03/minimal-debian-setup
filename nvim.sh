#!/usr/bin/env bash

set -e

sudo apt update

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
    pkg-config

if command -v dotnet >/dev/null 2>&1; then
    dotnet tool update --global csharp-ls 2>/dev/null || \
        dotnet tool install --global csharp-ls
fi

mkdir -p ~/.local/share/nvim/site/pack/themes/start

if [ ! -d ~/.local/share/nvim/site/pack/themes/start/nightfox.nvim ]; then
    git clone --depth 1 \
        https://github.com/EdenEast/nightfox.nvim \
        ~/.local/share/nvim/site/pack/themes/start/nightfox.nvim
fi
