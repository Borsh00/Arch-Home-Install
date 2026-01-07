#!/bin/bash
echo "Загрузка arch-rootfs"
cd "$HOME/arch-rootfs"

cat arch-rootfs.part-* > arch-rootfs.tar

echo "Распаковка arch-rootfs"
mkdir -p "$HOME/arch-root"
tar -xf arch-rootfs.tar -C "$HOME/arch-root"

rm arch-rootfs.tar
echo "Успешно распакован в $HOME/arch-root"
