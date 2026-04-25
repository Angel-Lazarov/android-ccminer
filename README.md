# android-ccminer
yes | pkg update && pkg upgrade

yes | pkg install libjansson wget nano

wget https://raw.githubusercontent.com/Angel-Lazarov/android-ccminer/refs/heads/main/auto_ssh_install.sh
chmod +x auto_ssh_install.sh
./auto_ssh_install.sh
