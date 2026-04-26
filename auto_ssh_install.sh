#!/data/data/com.termux/files/usr/bin/bash

# 1. ОСНОВНА ИНСТАЛАЦИЯ
echo "[*] Updating and installing dependencies..."
pkg update -y -o Dpkg::Options::="--force-confold"
pkg install openssh iproute2 procps -y

# 2. ЗАДАВАНЕ НА ПАРОЛА
echo "[*] Setting up credentials..."
echo -e "acidlord\nacidlord" | passwd

# 3. СЪЗДАВАНЕ НА .BASHRC
cat << 'BASHRC' > ~/.bashrc
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
BASHRC

# 4. STORAGE ПРОВЕРКА (Закоментирана за избягване на popup)
# if [ ! -d "$HOME/storage" ]; then
#     echo "[*] Please allow storage permission..."
#     termux-setup-storage
# else
#     echo "[-] Storage already configured."
# fi

# 5. ФИНАЛ
echo "[+] Done! SSH is ready."
source ~/.bashrc
