#!/bin/bash

export BEMENU_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1

pathprepend () {
  if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
      PATH="$1:$PATH"
  fi
}
# function to prepend path if not already part of path

export N_PREFIX="$HOME/.n"
pathprepend "$N_PREFIX"/bin

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
