#!/bin/bash

PINK='\033[38;5;213m'
PURPLE='\033[38;5;99m'
GREEN='\033[38;5;46m'
CYAN='\033[38;5;51m'
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
echo -e "${GREEN}              PRATIK EXTRAS${NC}"
echo ""

echo -e "${PINK}╔══════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║${WHITE}        PREMIUM INSTALLER SYSTEM         ${PURPLE}║${NC}"
echo -e "${PINK}╚══════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}System Information${NC}"
echo -e "OS      : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
echo -e "RAM     : $(free -h | awk '/Mem:/ {print $2}')"
echo -e "CPU     : $(nproc) Cores"
echo -e "User    : $(whoami)"
echo ""

echo -e "${WHITE}[1]${NC} ${GREEN}Panel${NC}"
echo -e "${WHITE}[2]${NC} ${CYAN}NeoFetch Installer${NC}"
echo -e "${WHITE}[3]${NC} ${RED}Exit${NC}"
echo ""

read -p "Select => " OPTION

case $OPTION in

1)
    clear

    echo -e "${CYAN}╔════════════════════════════╗${NC}"
    echo -e "${GREEN}║          PANELS           ║${NC}"
    echo -e "${CYAN}╚════════════════════════════╝${NC}"
    echo ""

    echo -e "${WHITE}[1]${NC} ${GREEN}UnOfficial Panel${NC}"
    echo -e "${WHITE}[2]${NC} ${RED}Back${NC}"
    echo ""

    read -p "Select => " PANEL

    case $PANEL in

    1)
        echo ""
        echo -e "${CYAN}[+] Updating System...${NC}"
        apt update -y

        echo -e "${CYAN}[+] Installing Dependencies...${NC}"
        apt install -y git nodejs npm curl wget

        echo -e "${CYAN}[+] Downloading Panel...${NC}"

        rm -rf crispy-adventure
        git clone https://github.com/pratikgamer11/crispy-adventure

        cd crispy-adventure || exit

        echo -e "${CYAN}[+] Installing Packages...${NC}"
        npm install express

        echo -e "${GREEN}[✓] Installation Complete!${NC}"
        echo -e "${GREEN}[✓] Starting Panel...${NC}"

        node .
        exit 0
        ;;

    2)
        ;;
    esac
    ;;

2)
    echo ""
    echo -e "${CYAN}[+] Installing NeoFetch...${NC}"

    apt update -y
    apt install -y neofetch

    echo ""
    echo -e "${GREEN}[✓] NeoFetch Installed Successfully!${NC}"
    echo ""

    neofetch

    echo ""
    read -p "Press Enter to continue..."
    ;;

3)
    echo -e "${GREEN}Goodbye!${NC}"
    exit 0
    ;;

*)
    echo -e "${RED}Invalid Option!${NC}"
    sleep 1
    ;;
esac

doneecho -e "OS      : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
echo -e "RAM     : $(free -h | awk '/Mem:/ {print $2}')"
echo -e "CPU     : $(nproc) Cores"
echo -e "User    : $(whoami)"
echo ""

echo -e "${WHITE}[1]${NC} ${GREEN}Panel${NC}"
echo -e "${WHITE}[2]${NC} ${CYAN}NeoFetch Installer${NC}"
echo -e "${WHITE}[3]${NC} ${RED}Exit${NC}"
echo ""

read -p "Select => " OPTION

case $OPTION in

1)
    clear

    echo -e "${CYAN}╔════════════════════════════╗${NC}"
    echo -e "${GREEN}║          PANELS           ║${NC}"
    echo -e "${CYAN}╚════════════════════════════╝${NC}"
    echo ""

    echo -e "${WHITE}[1]${NC} ${GREEN}UnOfficial Panel${NC}"
    echo -e "${WHITE}[2]${NC} ${RED}Back${NC}"
    echo ""

    read -p "Select => " PANEL

    case $PANEL in

    1)
        echo ""
        echo -e "${CYAN}[+] Updating System...${NC}"
        apt update -y

        echo -e "${CYAN}[+] Installing Dependencies...${NC}"
        apt install -y git nodejs npm curl wget

        echo -e "${CYAN}[+] Downloading Panel...${NC}"

        rm -rf crispy-adventure
        git clone https://github.com/pratikgamer11/crispy-adventure

        cd crispy-adventure || exit

        echo -e "${CYAN}[+] Installing Packages...${NC}"
        npm install express

        echo -e "${GREEN}[✓] Installation Complete!${NC}"
        echo -e "${GREEN}[✓] Starting Panel...${NC}"

        node .
        exit 0
        ;;

    2)
        ;;
    esac
    ;;

2)
    echo ""
    echo -e "${CYAN}[+] Installing NeoFetch...${NC}"

    apt update -y
    apt install -y neofetch

    echo ""
    echo -e "${GREEN}[✓] NeoFetch Installed Successfully!${NC}"
    echo ""

    neofetch

    echo ""
    read -p "Press Enter to continue..."
    ;;

3)
    echo -e "${GREEN}Goodbye!${NC}"
    exit 0
    ;;

*)
    echo -e "${RED}Invalid Option!${NC}"
    sleep 1
    ;;
esac

doneecho ""

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
