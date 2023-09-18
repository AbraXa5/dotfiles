# Abraxas's dotfiles

## Install

Generate and add a ssh key for the repo (here named dotfiles ) 

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
git clone --bare git@dotfiles.github.com:AbraXa5/dotfiles $HOME/.dotfiles.git
```

Setup an alias to use the bare repository
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
```

Backup conflicting dotfiles as a precaution and checkout this repository
```bash
dotfiles checkout
```

Disable tracking of new files
```bash
dotfiles config status.showUntrackedFiles no
```

## Post Install 

Antigen will handle all zsh requirements and plugins

Update antigen
```bash
curl -L git.io/antigen > antigen.zsh
```

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
python3-pip \
python3-venv \
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

Build Catppuccin theme for bat
```bash
bat cache --build
```

Install docker and docker compose
```bash
yay -S docker.io docker-compose docker-clean
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable docker --now
```

**VSCode** 
- Sync settings from github
- settings.json and keybinding in the ansible repo if required 

**SublimeText**
- Install package control
- Install package sync using package control
- Wait for extension to install and restart subl

Post setup, set [wakatime](https://wakatime.com/dashboard) API key via the extension to track time spent on editors

## Managing dotfiles

Open a new terminal or source the rc file and run `dot` to get an overview of all added dotfiles. (`M` means the file is modified but not staged)
```bash
> dot
 M   /.bashrc                                                 Fix bashrc fzf import
     /.config/bat/config                                      Change bat theme
     /.config/nano/nanorc                                     Add nano rc file
...
...
```

`dot` supports all git operations, for example, 
- `dot add` to stage a file
- `dot commit -m ''` to commit the files
- `dot push` to push to remote
- `dot lg` to view log and so on
