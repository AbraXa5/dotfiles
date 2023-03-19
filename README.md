# Abraxas's dotfiles

## Install

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
