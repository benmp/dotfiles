#!/usr/bin/env bash

readonly SCREENSHOTDIR="$HOME/.cache/screenshots"

if [[ ! -e "$SCREENSHOTDIR" ]]; then
  mkdir -p "$SCREENSHOTDIR"
fi

readonly TIME="$(date +%Y-%m-%d-%H-%M-%S)"
readonly IMGPATH="$SCREENSHOTDIR/img-$TIME.png"
grim -g "$(slurp)" "$IMGPATH"
