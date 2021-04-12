#!/bin/bash

# firefox wayland
export BEMENU_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1

#xdg-desktop-portal-wlr
export XDG_CURRENT_DESKTOP=sway

# function to prepend path if not already part of path
pathprepend () {
  if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
      PATH="$1:$PATH"
  fi
}

export N_PREFIX="$HOME/.n"
pathprepend "$N_PREFIX"/bin
pathprepend "$HOME"/.local/bin

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
