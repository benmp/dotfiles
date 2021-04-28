# Start configuration added by Zim install {{{
#
# User configuration sourced by login shells
#

# Initialize Zim
source ${ZIM_HOME}/login_init.zsh -q &!
# }}} End configuration added by Zim install

# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
  exec sway
fi
