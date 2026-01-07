#!/usr/bin/env bash
set -e

echo "🔷 Arch-Home-Install: старт"

BASE_RAW="https://raw.githubusercontent.com/Borsh00/Arch-Home-Install/main/packages"
RELEASE_BASE="https://github.com/Borsh00/Arch-Home-Install/releases/download/v1.0.0"

mkdir -p "$HOME/arch-home-install-temp"
cd "$HOME/arch-home-install-temp"

echo "📥 Скачиваем install-скрипты…"
curl -fL "$BASE_RAW/install-aptl.sh"  -o install-aptl.sh
curl -fL "$BASE_RAW/install-proot.sh" -o install-proot.sh
curl -fL "$BASE_RAW/install-arch.sh"  -o install-arch.sh
curl -fL "$BASE_RAW/make-arch-script.sh" -o make-arch-script.sh
chmod +x *.sh

echo "🚀 Сначала устанавливаем aptl, чтобы был PATH"
bash install-aptl.sh

# экспортируем пути сразу
export PATH="$HOME/bin:$HOME/deb-local/usr/bin:$HOME/deb-local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/deb-local/usr/lib:$HOME/deb-local/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"

echo "📦 Загружаем rootfs части…"
PARTS=(
  arch-rootfs.part-aa arch-rootfs.part-ab arch-rootfs.part-ac
  arch-rootfs.part-ad arch-rootfs.part-ae arch-rootfs.part-af
  arch-rootfs.part-ag arch-rootfs.part-ah arch-rootfs.part-ai
  arch-rootfs.part-aj arch-rootfs.part-ak
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

echo "🚀 Устанавливаем proot и arch…"
bash install-proot.sh
bash install-arch.sh
bash make-arch-script.sh

echo "✅ Установка завершена"
