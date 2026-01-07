#!/bin/bash

echo "Установка arch в $HOME"

source $HOME/arch-install/packages/install-aptl.sh
source $HOME/arch-install/packages/install-proot.sh
source $HOME/arch-install/packages/install-arch.sh
source $HOME/arch-install/packages/make-arch-script.sh

echo "Вход в Arch - arch"
echo "Если arch не рабоатет - source ~/.bashrc"
