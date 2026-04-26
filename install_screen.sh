#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Checking if screen is installed..."

if command -v screen >/dev/null 2>&1; then
    echo "[✓] screen is already installed"
else
    echo "[!] screen not found. Installing..."

    pkg update -y
    pkg install screen -y

    if command -v screen >/dev/null 2>&1; then
        echo "[✓] screen installed successfully"

        echo "[*] Configuring screen hardstatus..."
        
        # Използваме кавички около 'SCREENRC', за да запазим символите % чисти
        # Използваме вградените в screen кодове %u (user) и %H (host/IP)
        cat << 'SCREENRC' > "$HOME/.screenrc"
startup_message off
hardstatus alwayslastline
hardstatus string "%{= gk} USER: %u %{= wk} | %{= cy} IP: %H %{= wk} | %{= My} %c"
SCREENRC

    else
        echo "[X] installation failed"
        exit 1
    fi
fi

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