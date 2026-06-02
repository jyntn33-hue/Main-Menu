#!/bin/bash

PINK='\033[1;95m'
PURPLE='\033[1;35m'
GREEN='\033[1;92m'
CYAN='\033[1;96m'
WHITE='\033[1;97m'
RED='\033[1;91m'
NC='\033[0m'

while true; do

clear

echo -e "${PINK}"
cat << "EOF"

██████╗ ██████╗  █████╗ ████████╗██╗██╗  ██╗
██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║██║ ██╔╝
██████╔╝██████╔╝███████║   ██║   ██║█████╔╝
██╔═══╝ ██╔══██╗██╔══██║   ██║   ██║██╔═██╗
██║     ██║  ██║██║  ██║   ██║   ██║██║  ██╗
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝

EOF

echo -e "${PURPLE}                    V7.0${NC}"
echo -e "${GREEN}                PRATIK EXTRAS${NC}"
echo -e "${PINK}════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}System Information${NC}"
echo "OS      : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
echo "RAM     : $(free -h | awk '/Mem:/ {print $2}')"
echo "CPU     : $(nproc) Cores"
echo "User    : $(whoami)"
echo ""

echo "[1] Panel"
echo "[2] Exit"
echo ""

read -p "Select => " OPTION

case $OPTION in

1)
    clear

    echo "=============================="
    echo "          PANELS"
    echo "=============================="
    echo ""
    echo "[1] UnOfficial Panel"
    echo "[2] Back"
    echo ""

    read -p "Select => " PANEL

    case $PANEL in

    1)
        echo ""
        echo "[+] Updating System..."
        apt update -y

        echo "[+] Installing Dependencies..."
        apt install -y git nodejs npm curl wget

        echo "[+] Downloading Panel..."
        rm -rf crispy-adventure
        git clone https://github.com/pratikgamer11/crispy-adventure

        cd crispy-adventure || exit

        echo "[+] Installing Packages..."
        npm install express

        echo "[✓] Installation Complete!"
        echo "[✓] Starting Panel..."

        node .
        exit
        ;;

    2)
        ;;
    esac
    ;;

2)
    echo "Goodbye!"
    exit 0
    ;;

*)
    echo "Invalid Option!"
    sleep 1
    ;;

esac

done 
