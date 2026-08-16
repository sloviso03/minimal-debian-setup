#!/usr/bin/env bash

wget -P /tmp https://pkg.noctalia.dev/deb/nickh-archive-keyring.deb

sudo dpkg -i /tmp/nickh-archive-keyring.deb
rm /tmp/nickh-archive-keyring.deb

sudo wget -O /etc/apt/sources.list.d/noctalia-trixie.sources https://pkg.noctalia.dev/deb/noctalia-trixie.sources
sudo apt update
sudo apt install -y noctalia
