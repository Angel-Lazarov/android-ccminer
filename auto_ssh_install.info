cat << 'EOF' > setup_ssh.sh
#!/data/data/com.termux/files/usr/bin/bash

# 1. ОСНОВНА ИНСТАЛАЦИЯ (Тиха и без въпроси)
echo "[*] Updating and installing dependencies..."
pkg update -y -o Dpkg::Options::="--force-confold"
pkg install openssh iproute2 procps -y

# 2. ЗАДАВАНЕ НА ПАРОЛА (Автоматично)
echo "[*] Setting up credentials..."
echo -e "acidlord\nacidlord" | passwd

# 3. СЪЗДАВАНЕ НА УНИВЕРСАЛЕН .BASHRC
# Това гарантира, че SSH ще тръгне на всеки телефон при отваряне на Termux
cat << 'BASHRC' > ~/.bashrc
# Автоматичен старт на сървъра с проверка
if ! pgrep -x "sshd" > /dev/null; then
    sshd
    SSH_STATUS="STARTED NOW"
else
    SSH_STATUS="ALREADY RUNNING"
fi

# Информация за отдалечен достъп
USER_NAME=$(whoami)
IP_ADDR=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -n 1)

GREEN='\033[0;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# clear # Оставям го закоментиран, както искаше
echo -e "${GREEN}===============================================${NC}"
echo -e "STATUS: ${CYAN}$SSH_STATUS${NC}"
echo -e "USER:   ${CYAN}$USER_NAME${NC}"
echo -e "IP:     ${CYAN}$IP_ADDR${NC}"
echo -e "LOGIN:  ${YELLOW}ssh $USER_NAME@$IP_ADDR -p 8022${NC}"
echo -e "${GREEN}===============================================${NC}"

# Полезни преки пътища
alias storage='termux-setup-storage'
BASHRC

# 4. STORAGE ПРОВЕРКА (За да не ти досажда по 100 пъти)
if [ ! -d "$HOME/storage" ]; then
    echo "[*] Please allow storage permission on the phone popup..."
    termux-setup-storage
else
    echo "[-] Storage already configured."
fi

# 5. ФИНАЛ
echo "[+] Done! SSH is ready on this device."
source ~/.bashrc
EOF

chmod +x setup_ssh.sh && ./setup_ssh.sh
