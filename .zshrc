# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Antigen
source "$HOME/antigen."zsh

# Load Antigen configurations
antigen init ~/cfg/antigenrc

# Load Aliases
if [ -f ~/cfg/aliases.sh ]; then
    . ~/cfg/aliases.sh
fi
# Load Functions
if [ -f ~/cfg/functions.sh ]; then
    . ~/cfg/functions.sh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Load P10K
[[ ! -f ~/cfg/.p10k.zsh ]] || source ~/cfg/.p10k.zsh

# Load Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load Exports
if [ -f ~/cfg/exports.sh ]; then
    . ~/cfg/exports.sh
fi

# Source NVM zsh integration
if [[ -d "$NVM_DIR" && -f ~/cfg/nvmrc ]]; then
    . ~/cfg/nvmrc
fi

# Source cargo
if [[ -f ~"~/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

# Source any local configs/ Tokens
if [[ -f ~"~/cfg/extrass.local" ]]; then
    . ~/cfg/extras.local
fi
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
        dotfiles "$@"
    fi
}
