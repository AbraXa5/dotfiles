#!/usr/bin/env bash

if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias la="exa --long --all --group"
fi
alias sl="ls"

if [ -x "$(command -v lsd)" ]; then
    alias lls="lsd"
    alias lla="lsd --long -A --group-directories-first --human-readable"
fi

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# View HTTP traffic
alias sniff="sudo ngrep -d 'eth0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i eth0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Mirror stdout to stderr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'

alias fzp="fzf --preview 'batcat --color=always {}' --preview-window '~3'"

alias weather='curl wttr.in/'
#-----------

#Quick Scripts

alias hosts='sudo nano /etc/hosts'
alias grep_ip='grep -E -o "([0-9]{1,3}[.]){3}[0-9]{1,3}"'
alias Tools='cd ~/Tools'
alias fd='fdfind'
alias hg='history | grep'
alias l1='ls -t -1'
alias count='find . -type f | wc -l'
alias untar='tar -zxvf '

alias myalias='nano ~/.aliases'
alias sublmyalias='subl ~/.aliases'
# alias src='source ~/.zshrc'

alias c='clear'

# ps greappable
alias psg="ps aux | grep -v grep | grep -i"

#-----------
# python venv manual
alias ve='python3 -m venv ./venv'
alias va='source ./venv/bin/activate'

#-----------
# git related
alias gc='git clone'

alias gs='git status'
alias gsp='git status --porcelain'

alias gaa='git add -A'
alias gac='git add .'

alias gcm="git commit -am"

alias gp='git push'

alias gl='git log'
alias glp='git log --pretty=oneline'

#-----------

# tun0 IP
alias tun0="ifconfig tun0 | grep 'inet ' | cut -d' ' -f10 | tr -d '\n' | xclip -sel clip"

# Serve http server
#alias serverup="ip -f inet addr show tun0 | echo \"http://\`grep -Po 'inet \K[\d.]+'\`/\"; pwd; python3 -m http.server 80"
alias www="python_server"

# show all open ports
alias openports='netstat -tulanp'

#-----------

# THM vpn access
alias start-thm='sudo openvpn ~/vpn_configs/thm_Abr4Xa5.ovpn'

#HTB vpn access
alias start-htb='sudo openvpn ~/vpn_configs/lab_Abr4Xa5.ovpn'
alias start-htb_endgame='sudo openvpn ~/vpn_configs/endgames_Abr4Xa5.ovpn'
alias start-htb_fortress='sudo openvpn ~/vpn_configs/fortresses_Abr4Xa5.ovpn'
alias start-htb_pro='sudo openvpn ~/vpn_configs/pro_labs_Abr4Xa5.ovpn'
alias start-htb_sp='sudo openvpn ~/vpn_configs/starting_point_Abr4Xa5.ovpn'
alias start-htb_seasons='sudo openvpn ~/vpn_configs/competitive_Abr4Xa5.ovpn'

## Nmap

alias nse-find="cat /usr/share/nmap/scripts/script.db | grep "
alias pc='pwncat-cs'

alias ffufdirbust='ffuf_directory_bruteforcing'
alias wfuzzdir='wfuzz_directory_bruteforcing'
alias grepjs='grep_js_files'


alias bat='batcat'
alias xc='xclip -sel clip'

# cracking zip files with rockyou.txt
alias crackzip='fcrackzip -v -u -D -p /usr/share/wordlists/rockyou.txt'



# gospider to spider the website and proxy through burp
alias spider='gospider -t 50 --sitemap --robots --proxy http://127.0.0.1:8080 -o gospider_output -s '
alias spider_noburp='gospider -t 50 --sitemap --robots -s '

# Fix anbox in the box
# alias anboxlaunch='anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity'

# better WHOIS lookups
alias whois="whois -h whois-servers.net"

# Fixing shells
py3_tty_upgrade() {
    echo "python3 -c 'import pty;pty.spawn(\"/bin/bash\")'" | xclip -sel clip
}
alias script_tty_upgrade="echo '/usr/bin/script -qc /bin/bash /dev/null'| xclip -sel clip"
alias tty_fix="stty raw -echo; fg; reset"
alias tty_conf="stty -a | sed 's/;//g' | head -n 1 | sed 's/.*baud /stty /g;s/line.*//g' | xclip -sel clip"

# docker
alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"


alias nginxhere='docker run --rm -it -p 80:80 -p 443:443 -v "${PWD}:/srv/data" rflathers/nginxserve'
alias servepython='docker run --name python_simplehttpserver -d -v "${PWD}":/var/www:ro -p 80:8080 trinitronx/python-simplehttpserver'
alias pythonhttp='servepython'
alias webdavhere='docker run --rm -it -p 80:80 -v "${PWD}:/srv/data/share" rflathers/webdav'

## docker msf
alias metasploitpf='docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -p 8443-9005:8443-9005 metasploitframework/metasploit-framework ./msfconsole'
alias msfvenomhere='docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -v "${PWD}:/data" metasploitframework/metasploit-framework ./msfvenom'

## docker hetty
## review, doexn't work anymore
alias runhetty='docker run -v $HOME/.hetty:/root/.hetty -p 8080:8080 ghcr.io/dstotijn/hetty:latest'

## print all docker aliases
# docker_alias() {
#     echo "dockershell <containerimage> - Start /bin/bash"
#     echo "dockershellhere <containerimage> - Start /bin/bash and map current directory"
#     echo "smbservehere - Start Smb server on port 445 and host current directory"
#     echo "nginxhere - Host current directory over port 445 and 80"
#     echo "pythonhttp - docker instance of python http server"
#     echo "webdavhere - Host over webdav"
#     echo "metasploitpf - Start metasploit and port forward 8443-9005"
#     echo "msfvenomhere - Map current directory to msfvenom"
# }

# Helper functions

## delete empty newlines
alias delEmptynewline="sed '/^[[:space:]]*$/d'"

## urlEncoding and decoding
alias urlencode='python3 -c "import sys, urllib.parse as ul;print(ul.quote(sys.argv[1]))"'
alias urlencode+='python3 -c "import sys, urllib.parse as ul;print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul;print(ul.unquote(sys.argv[1]))"'
# TODO Add lamda to percent encode everything 

# dotfiles aliases

alias dotfiles='/usr/bin/git --git-dir=$HOME/.Dotfiles.git/ --work-tree=$HOME'

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
