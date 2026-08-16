#!/usr/bin/env bash
sudo sed -i '/^deb cdrom:/s/^/#/' /etc/apt/sources.list

sudo apt update

sudo apt install -y \
  git \
  unzip \
  sway \
  autotiling \
  fonts-jetbrains-mono \
  fzf \
  micro \
  fastfetch \
  nwg-displays \
  swappy \
  grim \
  slurp \
  wl-clipboard \
  brightnessctl \
  zoxide \
  wget \
  build-essential \
  clang \
  clangd \
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
  qt-style-kvantum \
  qt-style-kvantum-themes \
  breeze-icon-theme \
  xdg-desktop-portal-wlr \
  polkit-kde-agent-1 \
  libwebp7 \
  librsvg2-common \
  gsettings-desktop-schemas \
  curl \
  cups \
  cups-client \
  cups-bsd \
  gtklp \
  lame \
  unrar-free \
  firefox-esr \
  obs-studio \

sudo systemctl enable --now udisks2

# Limpieza de keyring de GNOME no deseado
sudo apt purge -y gnome-keyring seahorse
sudo apt autoremove -y

# Desactivar módulo pam de gnome-keyring si existe
for file in /etc/pam.d/login /etc/pam.d/passwd /etc/pam.d/gdm-password /etc/pam.d/lightdm; do
    if [ -f "$file" ]; then
        sudo sed -i '/pam_gnome_keyring\.so/s/^/#/' "$file"
    fi
done
