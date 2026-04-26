# android-ccminer

1. Get Termux:
```
https://raw.githubusercontent.com/Angel-Lazarov/android-ccminer/main/termux-app_v0.118.0%2Bgithub-debug_arm64-v8a.apk
```

2. Get Termux ready:
```
yes | pkg update && pkg upgrade
yes | pkg install libjansson wget nano
```

2. setup ssh server:
```
wget https://raw.githubusercontent.com/Angel-Lazarov/android-ccminer/refs/heads/main/auto_ssh_install.sh
chmod +x auto_ssh_install.sh
./auto_ssh_install.sh
rm auto_ssh_install.sh
```

3. Download ccminer, config, start:
```
mkdir ccminer && cd ccminer
wget https://raw.githubusercontent.com/Angel-Lazarov/android-ccminer/main/ccminer
wget https://raw.githubusercontent.com/Angel-Lazarov/android-ccminer/main/config.json
wget https://raw.githubusercontent.com/Angel-Lazarov/android-ccminer/main/start.sh
chmod +x ccminer start.sh
```

4. setup screen:
```
wget https://raw.githubusercontent.com/Angel-Lazarov/android-ccminer/refs/heads/main/install_screen.sh
chmod +x install_screen.sh
./install_screen.sh
source ~/.bashrc
```

5. AutoStart App Manager