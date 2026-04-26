if ! pgrep -x "sshd" > /dev/null; then
    sshd
    SSH_STATUS="STARTED NOW"
else
    SSH_STATUS="ALREADY RUNNING"
fi

USER_NAME=$(whoami)
IP_ADDR=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -n 1)

GREEN='\033[0;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# clear
echo -e "${GREEN}===============================================${NC}"
echo -e "STATUS: ${CYAN}$SSH_STATUS${NC}"
echo -e "USER:   ${CYAN}$USER_NAME${NC}"
echo -e "IP:     ${CYAN}$IP_ADDR${NC}"
echo -e "LOGIN:  ${YELLOW}ssh $USER_NAME@$IP_ADDR -p 8022${NC}"
echo -e "${GREEN}-----------------------------------------------${NC}"
echo -e "COMMANDS: reboot, poweroff, storage, clear"
echo -e "MINER COMMANDS: miner_start, miner_screen"
echo -e "${GREEN}===============================================${NC}"

alias storage='termux-setup-storage'
alias reboot='su -c reboot'
alias poweroff='su -c "reboot -p"'
# ccminer auto-start (single instance + repair)

# 1. fix broken screen state
if screen -list 2>/dev/null | grep -q "Dead\|Remote"; then
    screen -wipe >/dev/null 2>&1
    sleep 2

    if screen -list 2>/dev/null | grep -q "Dead\|Remote"; then
        rm -rf ~/.screen 2>/dev/null
    fi
fi

# 2. start miner if not running
if ! pgrep -f "ccminer" >/dev/null 2>&1 || ! screen -list | grep -q "ccminer"; then
	pkill -9 ccminer >/dev/null 2>&1
    cd "$HOME/ccminer" && screen -dmS ccminer ./start.sh
fi

# ccminer control functions
miner_start() {
   if ! pgrep -f "ccminer" >/dev/null 2>&1 || ! screen -list | grep -q "ccminer"; then
   pkill -9 ccminer >/dev/null 2>&1
        cd "$HOME/ccminer" && screen -dmS ccminer ./start.sh
        echo "[✓] ccminer started"
    else
        echo "[✓] ccminer already running"
    fi
}

miner_screen() {
    if screen -list | grep -q "ccminer"; then
        screen -x ccminer
    else
        echo "[X] ccminer screen not found"
    fi
}
sleep 3
miner_screen
