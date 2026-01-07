#!/bin/bash

echo "Загрузка arch-rootfs"
cd ../arch-rootfs/
cat arch-rootfs.part-* >arch-rootfs.tar.gz
echo "Распаковка arch-rootfs"
mkdir -p ~/arch-root
tar -xzf ~/arch-install/arch-rootfs/arch-rootfs.tar.gz -C ~
rm ~/arch-install/arch-rootfs/arch-rootfs.tar.gz

echo "Успешно распакован в Home!"
