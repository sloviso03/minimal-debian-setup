# Minimal Debian Setup
A minimal Debian setup script focused on a lightweight Wayland desktop and development environment.

## Structure

```text
.
├── main.sh               # Main installation script
├── packages.sh           # System packages
├── network.sh            # NetworkManager configuration
├── c-sharp.sh            # .NET and C# tools
├── nvim.sh               # Neovim and development tools
├── dotfiles.sh           # Installs configuration files
├── hide.sh               # Hides unwanted system entries
├── kernel-cachyos.sh     # Optional CachyOS kernel setup
├── options.sh            # System options
├── sway/                 # Sway configuration
├── foot/                 # Foot terminal configuration
├── bash/                 # Bash configuration
├── nvim/                 # Neovim configuration
├── noctalia/             # Noctalia configuration
└── wallpapers/           # Wallpapers
```

## Installed
* Sway and Wayland tools
* Foot terminal
* Dolphin and Okular
* NetworkManager
* Bluetooth and audio support
* Firefox ESR
* Git, ripgrep, fd, fzf and zoxide
* Neovim with C/C++ and C# development support
* Clang, CMake, GDB and LLDB
* .NET 10 SDK and C# language server
* Noctalia
* Basic screenshot, brightness and display utilities

## Usage
Run the main installer:

```bash
chmod +x main.sh
./main.sh
```

The scripts are separated by component so individual parts can also be installed or modified independently.
