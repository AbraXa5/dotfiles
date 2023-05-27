#! /usr/bin/env bash

gpip() {
    PIP_REQUIRE_VIRTUALENV=false pip "$@"
}
function killp_named() {
    processName="$1"
    ps aux | grep "$processName" | grep -v grep | grep -v kill_named | awk '{print $2}' | xargs kill -9
}

function src() {
    source $HOME/.zshrc
    cowsay "$(fortune)" | toilet -f term --metal && sleep 5 && clear
    eval zsh
}

function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

function historygrep() {
    history | grep "$1" | tr -s ' ' | cut -d' ' -f5-
}

#change directory and list content
function cl() {
    DIRECTORY="$*"
    # if no DIR given, go home
    if [ $# -lt 1 ]; then
        DIRECTORY=$HOME
    fi
    builtin cd "${DIRECTORY}" &&
        # use your preferred ls command
        ls -F --color=auto
}

# mkdir && cd
mkcd() {
    mkdir -p -- "$1" &&
        cd -- "$1" || exit 1
}

list_ips() {
    ip a show scope global | awk '/^[0-9]+:/ { sub(/:/,"",$2); iface=$2 } /^[[:space:]]*inet / { split($2, a, "/"); print "[\033[96m" iface"\033[0m] "a[1] }'
}

function python_server() {
    list_ips
    echo "http://"$(ip -br a | grep tun0 | tr -s " " | cut -d" " -f3 | cut -d'/' -f1)"/" | xclip -sel clip
    echo -e "[\e[96m$(pwd)\e[0m]\e[34m" && echo -en "\e[0m"
    echo "Files" && ls
    python3 -m http.server 80
}

# Create a data URL from a file
function dataurl() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

setip() {
    export IP="$1"
}

newnote() {
    cp ~/cfg/templates/notes_template.md ./notes.md
    subl notes.md
}
#-----------
# Templates

## create bash boilerplate code
newBash() {
    cp ~/cfg/templates/bash_template.sh "./${1}"
    subl "${1}"
}

## create python request boilerplate code
newPython_request() {
    cp ~/cfg/templates/pythonRequests_template.py "./${1}"
    subl "${1}"
}
## create python database command boilerplate code
newPython_db() {
    cp ~/cfg/templates/pythonDbCommands_template.py "./${1}"
    subl "${1}"
}

function semgrepcheck() {
    "semgrep --config=p/ci --verbose $1 $2"
}

function nmap_run() {
    nmap -p- -Pn -T4 --min-rate 1000 --max-retries 5 "$1" "${@:2}"
}

# Functions

## gobuster
function godirbust {
    gobuster dir -u http://"$1" -w /usr/share/wordlists/dirb/common.txt -e -s "200,301,302,401" -x "php,html,txt" -t 100 -o gobuster-"$1"
}

function gosubdomain() {
    gobuster vhost -u http://"$1" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -o subdomain-gobuster-"$1"
}

## FFUF

### ffuf directory bruteforcing
function ffuf_directory_bruteforcing() {
    ffuf -c -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://"${1}"/FUZZ -o ffuf_"${1}".md -of md -t 100 -r "${@:2}"
}

### ffuf directory bruteforcing recursive
function ffuf_directory_bruteforcing_recursion() {
    ffuf -c -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://"${1}"/FUZZ -o ffuf_"${1}".md -of md -t 100 -recursion "${@:2}"
}
function ffuf_onelistforall() {
    ffuf -c -w /usr/share/wordlists/OneListForAll/onelistforallmicro.txt -u http://"${1}"/FUZZ -t 100 -r -of md -o onelistforallFUZZ.md "${@:2}"
}

### ffuf subdomain enumeration
function ffuf_subdomain_enum() {
    ffuf -c -u http://"$1" -H "Host: FUZZ.${1}" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -o ffuf-subdomain_enum-"${1}".md -of md -v "${@:2}"
}

## wfuzz

### wfuzz directory bruteforcing
function wfuzz_directory_bruteforcing() {
    wfuzz -c -w /usr/share/seclists/Discovery/Web-Content/common.txt -f wfuzz_"$1".md -u http://"$1"/FUZZ "${@:2}"
}

### wfuzz subdomain enum
function wfuzz_subdomain_enum() {
    sudo wfuzz -c -Z -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -H "Host: FUZZ.${1}" -f subdomain_wfuzz_"$1".md -u http://"$1" "${@:2}"
}

function grep_js_files() {
    cmd <"$1" | js-beautify | grep "$2"
}

# nikto with output
function nicto() {
    nikto -output nikto-"$1".txt -ask no -url http://"$1"
}

function nuclei_run() {
    nuclei -u "${1}" -as -o nuclei_output.txt "${@:2}"
}

john_rock() {
    if [ $# -eq 0 ]; then
        echo "[+] Usage: rock_john wordlist (options)"
    else
        john "${@}" --wordlist=/usr/share/wordlists/rockyou.txt
    fi
}

# optimized rustscan with nmap script and version scanning
function rscan() {
    domain="$1" && shift
    rustscan -a "$domain" --ulimit 5000 -n -- -sCV -v "$@"
}

# SSH aliases

## check for authentication type
function sshAuthCheck() {
    ssh user@"${1}" -G | grep -E 'pubkeyauthentication|passwordauthentication'
}

## login with saving host in KnownHostsFile
function sshLogin() {
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${@}"
}

# OSINT

## ipinfo
ipinfo() {
    curl ipinfo.io/"$1"
}
ipinfo_file() {
    file="$1"
    for ip in $(cat "$file"); do
        echo -n "$ip: "
        curl -s ipinfo.io/"$ip" | jq .org
    done
}

## emailrep.io
email_info() {
    curl emailrep.io/"${1}"
}

# docker

dockershellhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v "$(pwd)":/"${dirname}" -w /"${dirname}" "$@"
}
dockershellshhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v "$(pwd)":/"${dirname}" -w /"${dirname}" "$@"
}
alias impacket_docker="docker run --rm -it rflathers/impacket"

smbservehere() {
    local sharename
    [[ -z $1 ]] && sharename="SHARE" || sharename=$1
    docker run --rm -it -p 445:445 -v "${PWD}:/tmp/serve" rflathers/impacket smbserver.py -smb2support "$sharename" /tmp/serve
}

# chisel
function chisel_server_start() {

    echo 'Usage'
    echo './chisel server --reverse -p LISTEN_PORT'
    echo './chisel client ATTACKING_IP:LISTEN_PORT R:LOCAL_PORT:TARGET_IP:TARGET_PORT'
    echo ''
    echo 'This will create a tunnel to `TARGET_IP:TARGET_PORT` accessible through `127.0.0.1:LOCAL_PORT`'
    echo ''
    /home/$USER/Tools/chisel/chisel_1.7.6_linux_amd64 server --reverse --port "${1}"
}

# TODO Improve this
function xnLinkFinder() {
    cd /home/$USER/Tools/xnLinkFinder || exit 1
    pipenv run python xnLinkFinder.py "${@}"
    cd - || exit 1
    mv "$OLDPWD/output.txt" ./xnLinkFinder_output.txt
    mv "$OLDPWD/parameters.txt" ./xnLinkFinder_parameters.txt
}
