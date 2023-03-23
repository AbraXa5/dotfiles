#!/usr/bin/env bash

git clone --bare git@dotfiles.github.com:AbraXa5/dotfiles $HOME/.dotfiles.git
# define config alias locally
function dotfiles {  
   git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME $@  
}
# create a directory to backup existing dotfiles to  
mkdir -p .dotfiles-backup/.ssh .dotfiles-backup/cfg 
dotfiles checkout  
if [ $? = 0 ]; then  
   echo "Checked out dotfiles from git@github.com:AbraXa5/.dotfiles";
else  
   echo "Moving existing dotfiles to ~/.dotfiles-backup";  
   dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}  
   # checkout dotfiles from repo  
   dotfiles checkout
fi
  
dotfiles config status.showUntrackedFiles no
