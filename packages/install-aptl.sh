#!/bin/bash
echo "Устанавливаем aptl..."

LOCAL="$HOME/deb-local"
mkdir -p "$HOME/bin" "$LOCAL/bin" "$LOCAL/usr/bin" "$LOCAL/usr/lib" "$LOCAL/usr/lib/x86_64-linux-gnu"

cat >"$HOME/bin/aptl" <<'EOF'
#!/bin/bash
LOCAL="$HOME/deb-local"
mkdir -p "$LOCAL"

TMP=$(mktemp -d)
cd "$TMP" || exit 1

echo "Скачиваю пакеты $@ и зависимости..."
for pkg in "$@"; do
    echo "📦 $pkg"
    apt download "$pkg" 2>/dev/null
    deps=$(apt-cache depends "$pkg" 2>/dev/null | grep -E 'Depends:|Recommends:' | awk '{print $2}' | grep -v '<' | tr '\n' ' ')
    if [ -n "$deps" ]; then
        echo "  📚 Зависимости: $deps"
        apt download $deps 2>/dev/null
    fi
done

echo "Распаковываю в $LOCAL ..."
for deb in *.deb; do
    [ -f "$deb" ] && dpkg-deb -x "$deb" "$LOCAL" 2>/dev/null
done

cd ~ || exit 1

export PATH="$LOCAL/usr/bin:$LOCAL/bin:$PATH"
export LD_LIBRARY_PATH="$LOCAL/usr/lib:$LOCAL/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
echo -e "\n✅ ГОТОВО! Установлены: $@"
echo "📁 Файлы в: $LOCAL"
EOF

chmod +x "$HOME/bin/aptl"

# Добавляем в shell
SHELL_RC="$HOME/.bashrc"
if [ -n "$ZSH_VERSION" ]; then SHELL_RC="$HOME/.zshrc"; fi
if [ -n "$FISH_VERSION" ]; then SHELL_RC="$HOME/.config/fish/config.fish"; fi

if [[ "$SHELL_RC" == *fish* ]]; then
    grep -qxF "set -gx PATH \$HOME/bin \$HOME/deb-local/usr/bin \$HOME/deb-local/bin \$PATH" "$SHELL_RC" || \
        echo "set -gx PATH \$HOME/bin \$HOME/deb-local/usr/bin \$HOME/deb-local/bin \$PATH" >>"$SHELL_RC"
    grep -qxF "set -gx LD_LIBRARY_PATH \$HOME/deb-local/usr/lib \$HOME/deb-local/usr/lib/x86_64-linux-gnu \$LD_LIBRARY_PATH" "$SHELL_RC" || \
        echo "set -gx LD_LIBRARY_PATH \$HOME/deb-local/usr/lib \$HOME/deb-local/usr/lib/x86_64-linux-gnu \$LD_LIBRARY_PATH" >>"$SHELL_RC"
    grep -qxF "alias aptl \$HOME/bin/aptl" "$SHELL_RC" || echo "alias aptl \$HOME/bin/aptl" >>"$SHELL_RC"
else
    grep -qxF 'export PATH="$HOME/bin:$HOME/deb-local/usr/bin:$HOME/deb-local/bin:$PATH"' "$SHELL_RC" || \
        echo 'export PATH="$HOME/bin:$HOME/deb-local/usr/bin:$HOME/deb-local/bin:$PATH"' >>"$SHELL_RC"
    grep -qxF 'export LD_LIBRARY_PATH="$HOME/deb-local/usr/lib:$HOME/deb-local/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"' "$SHELL_RC" || \
        echo 'export LD_LIBRARY_PATH="$HOME/deb-local/usr/lib:$HOME/deb-local/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"' >>"$SHELL_RC"
    grep -qxF "alias aptl='$HOME/bin/aptl'" "$SHELL_RC" || echo "alias aptl='$HOME/bin/aptl'" >>"$SHELL_RC"
fi

export PATH="$HOME/bin:$HOME/deb-local/usr/bin:$HOME/deb-local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/deb-local/usr/lib:$HOME/deb-local/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
alias aptl="$HOME/bin/aptl"
echo "Aptl установлен ✅."
