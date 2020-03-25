#!/usr/bin/env bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
[[ $- != *i* ]] && return
case $- in
  *i*) ;;
    *) return;;
esac

################################
# GENERAL BASH OPTIONS         #
################################

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar 2> /dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=4

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# user colored prompt
force_color_prompt=yes

################################
# COMPLETION BASH OPTIONS      #
################################

# filename insensitivity
bind "set completion-map-case on"

# hypen and underscore are the same
bind "set completion-ignore-case on"

# display matches on first tab press
bind "set show-all-if-ambiguous on"

# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
  fi
fi

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'


################################
# HISTORY BASH OPTIONS         #
################################

# append to the history file, don't overwrite it
shopt -s histappend

# save multiline commands as single command
shopt -s cmdhist

# write history immediately
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:l:ll:la:bg:fg:history:clear"

# keep more bash history around
HISTSIZE=500000
HISTFILESIZE=100000

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T'

################################
# NAVIGATION BASH OPTIONS      #
################################

# auto cd when typing only directory name
shopt -s autocd 2> /dev/null

# correct spelling errors for cd
shopt -s cdspell 2> /dev/null

# correct spelling errors for tab-completion
shopt -s dirspell 2> /dev/null

# some more ls aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ll='ls -aGlF'
  alias la='ls -AGF'
  alias ls='ls -CGF'
else
  alias ll='ls -alF'
  alias la='ls -AF'
  alias ls='ls -CF'
fi

# ls -a after a manual cd command
cd() { builtin cd "$@" && la; }

################################
# EXPORTS                      #
################################

#fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if [ -x "$(command -v rg)" ]; then
 export FZF_DEFAULT_COMMAND='rg --hidden --no-messages --files --smart-case --follow --glob "!{.git,node_modules,.svn,*.sass-cache}" '
 export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
# default command grows down, takes 40% of terminal, and previews 100 lines from inside file
export FZF_DEFAULT_OPTS='--reverse --height 40% --preview "head -100 {}"'

#exports
#export WEECHAT_HOME="$HOME/.config/weechat"
export VISUAL=vim
export EDITOR="$VISUAL"

# mono fix for brew macos
export MONO_GAC_PREFIX="/usr/local"

################################
# PATHS                        #
################################

# function to prepend path if not already part of path
pathprepend() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

pythonpathmac() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    MYFILES=`ls -F $HOME/Library/Python | grep "\/" `
    for FOLDER in $MYFILES; do
      pathprepend $HOME/Library/Python/$FOLDER\bin
    done
  fi
}

#pathprepend $HOME/.local/bin
pathprepend $HOME/.cargo/bin
pathprepend /usr/local/bin
pathprepend /usr/local/opt/node@8/bin
#pathprepend /usr/local/lib/ruby/gems/2.5.0/bin

#pythonpathmac

PS1="┌─[\`if [ \$? = 0 ]; then echo \[\e[32m\]✔\[\e[0m\]; else echo \[\e[31m\]✘\[\e[0m\]; fi\`]───[\[\e[01;49;39m\]\u\[\e[00m\]\[\e[01;49;39m\]@\H\[\e[00m\]]───[\[\e[1;49;34m\]\W\[\e[0m\]]───[\[\e[1;49;39m\]\$(ls | wc -l) files, \$(ls -lah | grep -m 1 total | sed 's/total //')\[\e[0m\]]\n└───▶ "

