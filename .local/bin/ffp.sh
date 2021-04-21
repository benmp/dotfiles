#!/usr/bin/env bash

swaymsg workspace 10
if ! pgrep -f "/usr/lib/firefox/firefox -no-remote -P personal"
then
  /usr/bin/firefox -no-remote -P personal
fi
