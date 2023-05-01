# Abraxas's dotfiles

## Install

Add a ssh config entry for `dotfiles.github.com`
```bash
Host dotfiles.github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/dotfiles
  IdentitiesOnly yes
 ```

### Using a script

Run `cfg/setupDotfiles.sh`
```bash
curl https://raw.githubusercontent.com/AbraXa5/dotfiles/main/cfg/setupDotfiles.sh | bash
```

### Manual

Clone the bare repository
```bash
git clone --bare git@github.com:AbraXa5/dotfiles $HOME/.dotfiles.git
```

Setup an alias to use the bare repository
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
```

Backup Existing dotfiles as a precaution and checkout this repository
```bash
dotfiles checkout
```

Disable tracking of new files
```bash
dotfiles config status.showUntrackedFiles no
```

## Post Install 

Antigen will handle all zsh requirements 

Install fzf
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --no-update-rc --no-bash --no-zsh
```

Installl required tools and packages
```bash
yay -S \
bat \
exa \
the_silver_searcher \
xclip \
nnn \
peco \
jq \
python-pip \
python-venv \
unzip \
nmap \
ffuf \
wfuzz \
remmina \
fortune-mod \
toilet \
cowsay \
go
```


```bash
yay -S docker
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable docker --now
```
