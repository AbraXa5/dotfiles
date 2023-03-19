#!/usr/bin/env bash

git clone --bare git@github.com:AbraXa5/wslDotfiles $HOME/.wslDotfiles.git
# define config alias locally
function dotfiles {  
   git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME $@  
}
# create a directory to backup existing dotfiles to  
mkdir -p .dotfiles-backup  
dotfiles checkout  
if [ $? = 0 ]; then  
  echo "Checked out dotfiles from git@github.com:AbraXa5/wslDotfiles";  
  else  
    echo "Moving existing dotfiles to ~/.dotfiles-backup";  
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}  
fi
# checkout dotfiles from repo  
dotfiles checkout  
dotfiles config status.showUntrackedFiles no