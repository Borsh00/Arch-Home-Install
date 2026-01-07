#!/usr/bin/env bash
set -e

echo "⏳ Начинаю установку Arch Home Install…"

BASE_RAW="https://raw.githubusercontent.com/Borsh00/Arch-Home-Install/main/packages"
RELEASE_BASE="https://github.com/Borsh00/Arch-Home-Install/releases/latest/download"

WORKDIR="$(mktemp -d)"
echo "💾 Рабочая директория: $WORKDIR"
cd "$WORKDIR"

echo "📥 Скачиваю пакетные скрипты…"
curl -fsSL "$BASE_RAW/install-proot.sh" -o install-proot.sh
curl -fsSL "$BASE_RAW/install-aptl.sh"  -o install-aptl.sh
curl -fsSL "$BASE_RAW/install-arch.sh"  -o install-arch.sh

chmod +x *.sh

echo "📦 Скачиваю rootfs части из релиза…"
mkdir -p "$HOME/arch-rootfs"
cd "$HOME/arch-rootfs"

# Скачиваем все части из релиза
for p in arch-rootfs.part-*; do
  curl -L -O "$RELEASE_BASE/$p"
done

echo "📦 Сборка rootfs:"
cat arch-rootfs.part-* > arch-rootfs.tar.gz
mkdir -p "$HOME/arch-root"
tar -xzf arch-rootfs.tar.gz -C "$HOME/arch-root"

echo "📁 Удаляем временные файлы…"
rm -rf "$WORKDIR"
echo "✅ Rootfs готов"

echo "📍 Запускаю установщики…"
bash "$WORKDIR/install-proot.sh"
bash "$WORKDIR/install-aptl.sh"
bash "$WORKDIR/install-arch.sh"

echo "🎉 Установка завершена!"
echo "📌 Если всё прошло OK, используйте команду 'arch' (алиас) для входа"
