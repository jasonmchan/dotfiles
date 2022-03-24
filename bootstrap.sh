#!/usr/bin/env bash

XDG_HOME="${HOME}/.config"
DOTFILES=(
  "alacritty"
  "fish"
  "git"
  "nvim"
  "tmux"
)

for dotfile in "${DOTFILES[@]}"; do
  rm -rf "$XDG_HOME/${dotfile}"
  ln -sf "$(pwd)/${dotfile}" "$XDG_HOME/${dotfile}"
done
