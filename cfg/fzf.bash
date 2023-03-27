# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kali/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kali/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kali/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/kali/.fzf/shell/key-bindings.bash"
