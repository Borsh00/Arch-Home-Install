#!/usr/bin/env bash
set -e

echo "🔷 Arch-Home-Install: старт"

BASE_RAW="https://raw.githubusercontent.com/Borsh00/Arch-Home-Install/main/packages"
RELEASE_BASE="https://github.com/Borsh00/Arch-Home-Install/releases/latest/download"

mkdir -p "$HOME/arch-home-install-temp"
cd "$HOME/arch-home-install-temp"

echo "📥 Скачиваем install-скрипты…"
curl -fL "$BASE_RAW/install-proot.sh" -o install-proot.sh
curl -fL "$BASE_RAW/install-aptl.sh"  -o install-aptl.sh
curl -fL "$BASE_RAW/install-arch.sh"  -o install-arch.sh

chmod +x *.sh

echo "📦 Загружаем rootfs части…"
PARTS=(
  arch-rootfs.part-aa
  arch-rootfs.part-ab
  arch-rootfs.part-ac
  arch-rootfs.part-ad
  arch-rootfs.part-ae
  arch-rootfs.part-af
  arch-rootfs.part-ag
  arch-rootfs.part-ah
  arch-rootfs.part-ai
  arch-rootfs.part-aj
  arch-rootfs.part-ak
)

mkdir -p "$HOME/arch-rootfs"
cd "$HOME/arch-rootfs"

for part in "${PARTS[@]}"; do
  echo "⬇️  $part…"
  curl -fL "$RELEASE_BASE/$part" -o "$part"
done

echo "📦 Собираем tar…"
cat arch-rootfs.part-* > arch-rootfs.tar
mkdir -p "$HOME/arch-root"
tar -xf arch-rootfs.tar -C "$HOME/arch-root"

cd "$HOME/arch-home-install-temp"

echo "🚀 Запуск install-скриптов…"
bash install-proot.sh
bash install-aptl.sh
bash install-arch.sh

echo "✅ Установка завершена"
