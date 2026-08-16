#!/usr/bin/env bash

set -e

wget -q https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb \
-O /tmp/packages-microsoft-prod.deb

sudo dpkg -i /tmp/packages-microsoft-prod.deb

rm /tmp/packages-microsoft-prod.deb

sudo apt update

sudo apt install -y \
dotnet-sdk-10.0 \
aspnetcore-runtime-10.0 \
dotnet-runtime-10.0

echo "DOTNET:"
/usr/bin/dotnet --version
