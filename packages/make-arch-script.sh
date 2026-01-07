#!/bin/bash

echo "Создаю скрипт для загрузки в arch"
cat >"$HOME/bin/arch" <<'EOF'
#!/bin/bash

# Запуск Arch через proot
"$HOME/deb-local/usr/bin/proot" -r "$HOME/arch-root" /bin/bash
EOF

chmod +x "$HOME/bin/arch"

# Определяем shell и соответствующий конфиг
if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_RC="$HOME/.bashrc"
elif [ -n "$FISH_VERSION" ]; then
  SHELL_RC="$HOME/.config/fish/config.fish"
else
  SHELL_RC="$HOME/.profile"
fi

# Добавляем алиас
if [[ "$SHELL_RC" == *fish* ]]; then
  grep -qxF "alias arch \$HOME/bin/arch" "$SHELL_RC" || echo "alias arch \$HOME/bin/arch" >>"$SHELL_RC"
else
  grep -qxF "alias arch='$HOME/bin/arch'" "$SHELL_RC" || echo "alias arch='$HOME/bin/arch'" >>"$SHELL_RC"
fi

alias arch="$HOME/bin/arch"

echo "Успешно создал скрипт запуска arch"
