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
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Load P10K
[[ ! -f ~/cfg/.p10k.zsh ]] || source ~/cfg/.p10k.zsh

# Load Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
