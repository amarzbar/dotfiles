#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for d in ghostty i3 kitty nvim picom polybar rofi tmux; do
    ln -sfn "$DOTFILES/$d" "$HOME/.config/$d"
done
