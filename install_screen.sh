#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Checking if screen is installed..."

# 1. Инсталация (само ако липсва)
if command -v screen >/dev/null 2>&1; then
    echo "[✓] screen is already installed"
else
    echo "[!] screen not found. Installing..."

    pkg update -y
    pkg install screen -y

    if command -v screen >/dev/null 2>&1; then
        echo "[✓] screen installed successfully"
    else
        echo "[X] installation failed"
        exit 1
    fi
fi

# 2. СЪЗДАВАНЕ НА .SCREENRC (Винаги се изпълнява)
echo "[*] Configuring screen hardstatus..."
C_IP=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -n 1)
C_USER=$(whoami)

pkill -9 screen
chmod 644 "$HOME/.screenrc" 2>/dev/null
rm -rf "$HOME/.screenrc"

cat << EOF > "$HOME/.screenrc"
startup_message off
hardstatus alwayslastline
hardstatus string "%{= 7;4} USER: $C_USER | IP: $C_IP %=%d.%m.%Y | %c %{-b}"
EOF

# 3. Инжектиране в .bashrc
BASHRC="$HOME/.bashrc"

echo "[*] Injecting ccminer auto-start into bashrc..."

if ! grep -q "ccminer_screen_autostart" "$BASHRC"; then

cat << 'EOF' >> "$BASHRC"
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
EOF

    echo "[✓] Injected successfully"
else
    echo "[✓] Already exists, skipping"
fi

echo "[✓] Setup complete. Removing installer..."
rm -- "$0"