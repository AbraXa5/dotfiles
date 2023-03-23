#!/usr/bin/env bash

# Make vim the default editor.
export EDITOR='nano';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';
# match web browsers.
export NODE_REPL_MODE='sloppy';

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

export GOPATH=$HOME/go
export PATH=$HOME/bin:/usr/local/bin:$PATH
export NVM_DIR="$HOME/.nvm"

# For pipx
export PATH="$PATH:$HOME/.local/bin"

export FZF_DEFAULT_OPTS="--color=$fzf_colors --reverse"
export BAT_THEME='gruvbox-dark'
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Export path to my custom scripts
export PATH=~/cfg/bin:${PATH}
