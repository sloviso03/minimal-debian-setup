#!/usr/bin/env bash

set -e

sudo sed -i '/^deb cdrom:/s/^/#/' /etc/apt/sources.list

sudo apt update

sudo apt install -y \
    git \
    curl \
    wget \
    unzip \
    zip \
    ripgrep \
    fd-find \
    fzf \
    wl-clipboard \
    kew \
    sway \
    autotiling \
    fonts-jetbrains-mono \
    nwg-displays \
    swappy \
    grim \
    slurp \
    brightnessctl \
    zoxide \
    build-essential \
    network-manager \
    network-manager-gnome \
    gir1.2-nm-1.0 \
    gir1.2-nma-1.0 \
    udisks2 \
    wpasupplicant \
    bluez \
    bluez-tools \
    blueman \
    power-profiles-daemon \
    upower \
    pipewire-audio \
    wireplumber \
    pipewire-pulse \
    pavucontrol \
    dolphin \
    okular \
    xdg-desktop-portal-wlr \
    polkit-kde-agent-1 \
    libwebp7 \
    librsvg2-common \
    gsettings-desktop-schemas \
    cups \
    cups-client \
    cups-bsd \
    gtklp \
    lame \
    unrar-free \
    firefox-esr


sudo systemctl enable --now udisks2

sudo apt purge -y gnome-keyring seahorse
sudo apt autoremove -y
sudo apt autoclean

for file in /etc/pam.d/login /etc/pam.d/passwd /etc/pam.d/gdm-password /etc/pam.d/lightdm; do
    if [ -f "$file" ]; then
        sudo sed -i '/pam_gnome_keyring\.so/s/^/#/' "$file"
    fi
done
