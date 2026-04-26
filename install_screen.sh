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
CURRENT_IP=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -n 1)
CURRENT_USER=$(whoami)

cat << SCREENRC > "$HOME/.screenrc"
startup_message off
hardstatus alwayslastline
hardstatus string "%{= gk} USER: $CURRENT_USER %{= wk} | %{= cy} IP: $CURRENT_IP %{= wk} | %{= My} %c"
SCREENRC

# 3. Инжектиране в .bashrc
BASHRC="$HOME/.bashrc"

echo "[*] Injecting ccminer auto-start into bashrc..."

if ! grep -q "ccminer_screen_autostart" "$BASHRC"; then

cat << 'EOF' >> "$BASHRC"

# ccminer_screen_autostart
if ! screen -list | grep -q "ccminer"; then
    cd "$HOME/ccminer" && screen -dmS ccminer ./start.sh
fi
# ccminer_screen_autostart

EOF

    echo "[✓] Injected successfully"
else
    echo "[✓] Already exists, skipping"
fi

echo "[✓] Setup complete. Removing installer..."
rm -- "$0"