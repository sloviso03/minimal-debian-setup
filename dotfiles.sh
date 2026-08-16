#!/usr/bin/env bash
export SYSTEM_TIMEZONE=$(timedatectl show | grep Timezone | cut -d'=' -f2)

# General use
mkdir -p ~/Documents
mkdir -p ~/Downloads
mkdir -p ~/Music
mkdir -p ~/Pictures
mkdir -p ~/Videos

# Sway
mkdir -p ~/.config/sway
cp sway/* ~/.config/sway

# Foot
mkdir -p ~/.config/foot
cp foot/* ~/.config/foot

# Bash
cp -f bash/.bashrc "$HOME/.bashrc"
cp -f bash/.bash_profile "$HOME/.bash_profile"
hash -r

# Micro
sudo update-alternatives --set editor /usr/bin/micro
mkdir -p ~/.config/micro
bash micro.sh
cp -r micro/* ~/.config/micro/

# Wallpapers
mkdir -p "$HOME/Pictures/wallpapers"
sudo cp -r wallpapers/* "$HOME/Pictures/wallpapers"

# Noctalia
killall noctalia 2>/dev/null
mkdir -p ~/.local/state/noctalia
cp noctalia/settings.toml ~/.local/state/noctalia/settings.toml

if pgrep -x "sway" > /dev/null; then
    noctalia &>/dev/null &
fi


# Dolphin
sudo mkdir -p /usr/share/kio/servicemenus
sudo tee /usr/share/kio/servicemenus/open-foot-here.desktop >/dev/null <<'EOF'
[Desktop Entry]
Type=Service
MimeType=inode/directory;
X-KDE-ServiceTypes=KonqPopupMenu/Plugin
Actions=openFootHere;

[Desktop Action openFootHere]
Name=Open Foot Here
Icon=utilities-terminal
Exec=foot -D %f
EOF

kwriteconfig6 --file ~/.config/dolphinrc \
  --group ContextMenu \
  --key ShowOpenTerminal false
