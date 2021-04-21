#!/usr/bin/env bash

swaymsg workspace 2
if ! pgrep -f "/usr/lib/firefox/firefox -no-remote -P testing"
then
  /usr/bin/firefox -no-remote -P testing
fi
