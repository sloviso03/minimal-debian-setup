#!/bin/bash
set -e

[ "$EUID" -eq 0 ] || exec sudo bash "$0" "$@"

apt-get update
apt-get install -y curl zstd tar initramfs-tools grub2-common

ARCH="$(uname -m)"

[ "$ARCH" = "x86_64" ] || exit 1

BASE="https://mirror.cachyos.org/repo/x86_64_v3/cachyos-v3"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"

PKG="$(curl -fsSL "$BASE/" | grep -oE 'linux-cachyos-[0-9][^"]*-x86_64_v3\.pkg\.tar\.zst' | sort -V | tail -n1)"

[ -n "$PKG" ] || exit 1

curl -fL -o "$PKG" "$BASE/$PKG"

mkdir -p root
tar --use-compress-program=unzstd -xf "$PKG" -C root

MODDIR="$(find root/usr/lib/modules -mindepth 1 -maxdepth 1 -type d | head -n1)"

[ -n "$MODDIR" ] || exit 1

KVER="$(basename "$MODDIR")"

mkdir -p "/usr/lib/modules/$KVER"
cp -a "$MODDIR/." "/usr/lib/modules/$KVER/"

if [ -f "$MODDIR/vmlinuz" ]; then
    cp -f "$MODDIR/vmlinuz" "/boot/vmlinuz-$KVER"
elif [ -f "root/boot/vmlinuz-$KVER" ]; then
    cp -f "root/boot/vmlinuz-$KVER" "/boot/vmlinuz-$KVER"
else
    VMLINUZ="$(find root -type f \( -name 'vmlinuz' -o -name "vmlinuz-$KVER" \) | head -n1)"
    [ -n "$VMLINUZ" ] || exit 1
    cp -f "$VMLINUZ" "/boot/vmlinuz-$KVER"
fi

depmod -a "$KVER"

rm -f "/boot/initrd.img-$KVER"
update-initramfs -c -k "$KVER"

update-grub

echo
echo "CachyOS kernel instalado:"
echo "$KVER"
echo
echo "Kernel disponible:"
ls -1 /lib/modules
echo
echo "Reinicia con:"
echo "sudo reboot"
