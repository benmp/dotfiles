#!/usr/bin/env bash

swaymsg workspace 1
if ! pgrep -f "/usr/lib/firefox/firefox -no-remote -P work"
then
  /usr/bin/firefox -no-remote -P work
fi
