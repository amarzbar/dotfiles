#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for d in i3 kitty nvim picom polybar rofi; do
    ln -sfn "$DOTFILES/$d" "$HOME/.config/$d"
done
