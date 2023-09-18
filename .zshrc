# Export TTY for signing git commits
# Needs to be at the top since for P11k instant promptstdin is redirected from /dev/null
# GPG_TTY=$(tty)
# export GPG_TTY

# Better option since this works even if stdin is redirected
export GPG_TTY=$TTY

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Load Antigen
source "$HOME/antigen.zsh"

# Load Antigen configurations
antigen init ~/cfg/antigenrc

# function to source if the file exists and is readable
source_if_exists() {
    [[ -r "$1" ]] && source "$1"
}

# Load Aliases
source_if_exists "$HOME/cfg/aliases.sh"

# Load Functions
source_if_exists "$HOME/cfg/functions.sh"

# To customize prompt, run `p10k configure` or edit ~/cfg/.p10k.zsh.
# Load P10K
source_if_exists "$HOME/cfg/.p10k.zsh"

# Load Fzf
source_if_exists "$HOME/cfg/fzf.zsh"

# Load Exports
source_if_exists "$HOME/cfg/exports.sh"

# # Load ZSH Dracula theme variables
# source_if_exists "$HOME/cfg/dracula.sh"

# ZSH Spaceship prompt config file
export SPACESHIP_CONFIG="$HOME/cfg/spaceshiprc.zsh"

# Load nvm
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Why was the dot escaped
source_if_exists "$NVM_DIR/nvm.sh"

# TODO: Update source_if_exists for multiple entires
# Source NVM zsh integration
if [[ -d "$NVM_DIR" && -f ~/cfg/nvmrc ]]; then
    . ~/cfg/nvmrc
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Source cargo
source_if_exists "$HOME/.cargo/env"

# Activate pyenv
# if command -v pyenv >/dev/null; then
#   eval "$(pyenv init -)"
# fi

# Load rbenv shell integration
if [[ -d "$HOME/.rbenv" && -f ~/cfg/rbenvrc ]]; then
	. ~/cfg/rbenvrc
fi

# Source any local configs/ Tokens
source_if_exists "$HOME/cfg/extras.local"

# dotfiles aliases
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

dot() {
    if [[ "$#" -eq 0 ]]; then
        (
            cd /
            for i in $(dotfiles ls-files); do
                echo -n "$(dotfiles -c color.status=always status "$i" -s | sed "s#$i##")"
                echo -e "¬/$i¬\e[0;33m$(dotfiles -c color.ui=always log -1 --format="%s" -- "$i")\e[0m"
            done
        ) | column -t --separator=¬ -T2
    else
        /usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME "$@"
    fi
}
