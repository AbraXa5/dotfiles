#!/usr/bin/env bash

# Make vim the default editor.
export EDITOR='nano'

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="${HISTSIZE}"
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth'

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768'
# match web browsers.
export NODE_REPL_MODE='sloppy'

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8'

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}"

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X'

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/bin:$PATH
export NVM_DIR="$HOME/.nvm"

# For pipx
export PATH="$PATH:$HOME/.local/bin"

# Pyenv shell config
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

# TODO: Add conditonals here
# Dark solorized
# fzf_colors="pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934"

# Dracula themed
# fzf_colors="bg+:#363a4f,\
# bg:#24273a,\
# spinner:#f4dbd6,\
# hl:#ed8796,\
# fg:#cad3f5,\
# header:#ed8796,\
# info:#c6a0f6,\
# pointer:#f4dbd6,\
# marker:#f4dbd6,\
# fg+:#cad3f5,\
# prompt:#c6a0f6,\
# hl+:#ed8796"

# Simple
fzf_colors="
  --color=fg:-1
  --color=fg+:#61afef
  --color=bg:-1
  --color=bg+:#444957
  --color=hl:#E06C75
  --color=hl+:#E06C75
  --color=gutter:-1
  --color=pointer:#61afef
  --color=marker:#98C379
  --color=header:#61afef
  --color=info:#98C379
  --color=spinner:#61afef
  --color=prompt:#c678dd
  --color=border:#798294
"

export FZF_DEFAULT_OPTS="$fzf_colors \
--reverse \
--prompt '∷ ' \
--pointer ▶ \
--marker ⇒ \
--height '70%' \
--preview-window=,65% \
"

export BAT_THEME='gruvbox-dark'
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Export path to my custom scripts
export PATH=~/cfg/bin:${PATH}
