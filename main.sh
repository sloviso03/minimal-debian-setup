#!/usr/bin/env bash
RESET='\033[0m'
G='\033[0;32m'
B='\033[0;34m'


cat << 'EOF'

                                     .d88b. 88888b. 888  888
                                    d88P"88b888 "88b888  888
                                    888  888888  888888  888
                                    Y88b 888888  888Y88b 888
                                     "Y88888888  888 "Y88888
       (    )                            888 and debian? lol
        ~oo~                        Y8b d88P   sloviso03
         .. Gnu!                     "Y88P"
         / =\   \=
        -   -    -      =-=-The choice of the Linux generation-=-=

       This software is open-source: you can redistribute it and/or
       modify it under the terms of the GNU General Public License
       as published by the Free Software Foundation.

EOF

echo -e "${G}Installing packages...${RESET}"
bash packages.sh

echo -e "${G}Installing .NET and C#...${RESET}"
bash c-sharp.sh

echo -e "${G}Installing Neovim...${RESET}"
bash nvim.sh

echo -e "${G}Installing Noctalia...${RESET}"
bash noctalia/noctalia.sh

echo -e "${G}Installing dotfiles...${RESET}"
bash dotfiles.sh
bash hide.sh

echo -e "${G}Configuring NetworkManager...${RESET}"
sudo usermod -aG netdev "$USER"
sudo systemctl enable --now NetworkManager
bash ./network.sh

read -r -p "Reboot system now? (Y/N) " doit

case "${doit}" in
    [Yy]) sudo reboot now
    ;; *)
esac
