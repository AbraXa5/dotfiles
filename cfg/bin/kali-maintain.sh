#!/usr/bin/env  bash

LOGFILE="/var/log/kali-maintenance.log"
# shellcheck disable=SC2034
AUTO_MODE=false

# Safety Check
if [ -z "$BASH_VERSION" ]; then
    echo "This script must be run with bash." >&2
    exit 1
fi

sudo touch "$LOGFILE" 2>/dev/null
sudo chmod 666 "$LOGFILE" 2>/dev/null

log() {
    echo -e "$(date '+%F %T') $1" | tee -a "$LOGFILE"
}
update_system() {
    log "Updating pkg lists..."
    sudo apt update

    log "Upgrading installed pkgs..."
    sudo apt upgrade -y

    log "Running full system upgrade..."
    sudo apt full-upgrade -y
}


clean_system() {
    log "Cleaning unused pkgs..."
    sudo apt autoremove -y

    log "Cleaning APT cache..."
    sudo apt autoclean
    sudo apt clean

    log "Cleaning usr cache..."
    # rm -rf ~/.cache/* 2>/dev/null || true
    rm -rf ~/.cache/thumbnails ~/.cache/pip ~/.cache/pip-tools || true

}


repair_pkgs() {
    log "Checking broken pkgs..."
    sudo apt --fix-broken install -y
    sudo dpkg --configure -a
}

update_tool_dbs() {
    # log "Updating MsF DB..."
    # command -v msfdb >/dev/null && sudo msfdb update
    # command -v msfupdate >/dev/null && sudo msfupdate

    log "Updating Nmap scripts db..."
    sudo nmap --script-updatedb

    log "Updating file search database"
    sudo updatedb
}

clean_logs() {
    log "Vacuuming system logs to 200mb limit..."
    sudo journalctl --vacuum-size=200M

    log "Cleaning crrash logs..."
    sudo find /var/crash -type f -delete

    log "Cleaning burp logs..."
    rm -f ~/burp/*.log 2>/dev/null || true
    rm -f ~/.BurpSuite/*.log 2>/dev/null || true
}

network_diagnostics() {
    log "--- n/w diagnostics start ---"

    log "Interfaces:"
    ip a | tee -a "$LOGFILE"
    log "Default routes:"
    ip route | tee -a "$LOGFILE"
    log "Checking DNS configuration:"
    # resolvectl status | tee -a "$LOGFILE"
    if command -v resolvectl >/dev/null 2>&1 && systemctl is-active --quiet systemd-resolved; then
        resolvectl status | tee -a "$LOGFILE"
    else
        log "systemd-resolved not active. Showing /etc/resolv.conf instead:"
        cat /etc/resolv.conf | tee -a "$LOGFILE"
    fi

    # log "Flushing firewall rules (iptables)..."
    # if ip link show tun0 >/dev/null 2>&1; then
    #     log "tun0 active, skipping iptables flush to avoid breaking VPNs"
    # else
    #     log "Resetting iptables..."
    #     sudo iptables -F
    #     sudo iptables -t nat -F
    #     sudo iptables -t mangle -F
    # fi

    if ip link show tun0 >/dev/null 2>&1; then
        log "tun0 active, skipping firewall flush to avoid breaking VPNs"
    else
        if command -v nft >/dev/null 2>&1; then
            log "Flushing nftables rules..."
            sudo nft flush ruleset
        fi
        if command -v iptables >/dev/null 2>&1; then
            log "Flushing iptables rules..."
            sudo iptables -F
            sudo iptables -t nat -F
            sudo iptables -t mangle -F
        fi
    fi

    if [[ -n "$SSH_CONNECTION" ]]; then
        log "SSH session detected — skipping NetworkManager restart."
    else
        log "Restarting Networking"
        sudo systemctl restart NetworkManager
    fi


    if systemctl is-active --quiet systemd-resolved; then
        log "Flushing systemd DNS cache..."
        sudo resolvectl flush-caches
    else
        log "systemd-resolved not active; skipping DNS cache flush."
    fi

    log "Ping test 8.8.8.8..."
    ping -c 3 8.8.8.8 | tee -a "$LOGFILE"

    log "DNS test for google.com..."
    if command -v dig >/dev/null 2>&1; then
        dig google.com +short | tee -a "$LOGFILE"
    else
        ping -c 3 google.com | tee -a "$LOGFILE"
    fi
    log "--- End of n/w Diagnostics---"


}

health_check() {
    log "--- System Health Check ---"
    log "CPU Load:"
    uptime | tee -a "$LOGFILE"
    log "Memory Usage:"
    free -h | tee -a "$LOGFILE"
    log "Disk Usage:"
    df -h | tee -a "$LOGFILE"
    log "Memory intensive processes rn:"
    ps aux --sort=-%mem | head -n 10 | tee -a "$LOGFILE"
    log "--- End of System Health Check ---"
}

python_maintenance() {
    log "Upgrading Python system packages via apt..."
    sudo apt install --only-upgrade python3-pip python3-setuptools python3-wheel -y

}

lynis_audit() {
    log "Running Lynis security audit..."
    sudo lynis audit system | tee -a "$LOGFILE"
}

boot_analysis() {
    log "Sys boot analysis"
    systemd-analyze | tee -a "$LOGFILE"
    # systemd-analyze blame | tee -a "$LOGFILE"
    systemd-analyze critical-chain | tee -a "$LOGFILE"

}

reboot_prompt() {
    if [ -f /var/run/reboot-required ]; then
        log "Reboot required."
    else
        log "Reboot not required at the moment"
    fi

    read -rp "Maintenance Complete, Reboot now? (y/n): " answer
    [[ "$answer" == "y" ]] && sudo reboot
}

vmware_optimization() {
    log "--- VMware Optimization Start ---"

    if ! dpkg -s open-vm-tools >/dev/null 2>&1; then
        log "Installing open-vm-tools..."
        sudo apt install -y open-vm-tools open-vm-tools-desktop
    else
        log "open-vm-tools already installed."
    fi

    if systemd-detect-virt | grep -qi "vmware"; then
        log "Restarting VMware services..."
        sudo systemctl restart vmtoolsd
    else
        log "Not running inside VMware — skipping VMware services."
    fi

    if command -v fstrim >/dev/null 2>&1; then
        log "Running fstrim on all mounted filesystems..."
        sudo fstrim -av | tee -a "$LOGFILE"
    else
        log "fstrim not found; skipping."
    fi

    log "Ensuring fstrim.timer is enabled..."
    sudo systemctl enable fstrim.timer --now

    log "Cleaning VMware guest log files..."
    sudo find /var/log -name "vmware-*.log" -delete 2>/dev/null

    if ! dpkg -s haveged >/dev/null 2>&1; then
        log "Installing haveged for better entropy..."
        sudo apt install -y haveged
        sudo systemctl enable --now haveged
    else
        log "haveged already installed."
    fi

    for mod in vmhgfs vmxnet3 vmw_balloon vmw_vmci; do
        if lsmod | grep -q "$mod"; then
            log "Module loaded: $mod"
        else
            log "Missing VMware module: $mod"
        fi
    done

    log "--- VMware Optimization Complete ---"
}



# log "=== Starting Kali Maintenance ==="
# update_system
# clean_system
# repair_pkgs
# update_tool_dbs
# clean_logs
# network_diagnostics
# health_check
# python_maintenance
# lynis_audit
# boot_analysis
# log "=== Maintenance Finished ==="
# reboot_prompt

menu() {
    while true; do
        clear
        echo "===== Kali Maintenance Menu ====="
        echo "1) System Maintenance (Update, Clean, Repair, DB)"
        echo "2) Network Diagnostics"
        echo "3) Health & Python Maintenance"
        echo "4) Security (Lynis Audit, Boot Analysis)"
        echo "5) VMware Optimization"
        echo "6) Run Everything"
        echo "7) Run Everything but security"
        echo "8) Reboot"
        echo "9) Exit"
        echo "================================"
        read -rp "Choose an option: " choice
        case $choice in
            1)
                update_system
                clean_system
                repair_pkgs
                update_tool_dbs
                clean_logs
                read -rp "Press Enter to return to menu..."
                ;;
            2)
                network_diagnostics
                read -rp "Press Enter to return to menu..."
                ;;
            3)
                health_check
                python_maintenance
                read -rp "Press Enter to return to menu..."
                ;;
            4)
                lynis_audit
                boot_analysis
                read -rp "Press Enter to return to menu..."
                ;;
            5)
                vmware_optimization
                read -rp "Press Enter to return to menu..."
                ;;
            6)
                update_system
                clean_system
                repair_pkgs
                update_tool_dbs
                clean_logs
                network_diagnostics
                health_check
                python_maintenance
                lynis_audit
                boot_analysis
                vmware_optimization
                reboot_prompt
                ;;
            8)
                reboot_prompt
                ;;
            9)
                log "Exiting maintenance."
                log "======== Maintenance Finished ========"
                exit 0
                ;;
            *)
                echo "Invalid option. Try again."
                ;;
        esac
    done
}

log "======== Starting Kali Maintenance ========"
menu
exit 0
