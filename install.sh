#!/bin/bash

# --- COLORS ---
PINK='\033[38;5;213m'
PURPLE='\033[38;5;99m'
GREEN='\033[38;5;46m'
CYAN='\033[38;5;51m'
YELLOW='\033[1;93m'
WHITE='\033[1;97m'
RED='\033[1;91m'
NC='\033[0m'

# --- PASSWORD CONFIG ---
CORRECT_PASSWORD="pratik123"
MAX_ATTEMPTS=3

check_password() {
    local attempts=0

    while [ $attempts -lt $MAX_ATTEMPTS ]; do
        clear
        echo -e "${PURPLE}╔══════════════════════════════════════════╗${NC}"
        echo -e "${PURPLE}║${WHITE}      ENTER PASSWORD TO ACCESS SYSTEM     ${PURPLE}║${NC}"
        echo -e "${PURPLE}╚══════════════════════════════════════════╝${NC}"
        echo ""

        read -sp "Enter Password => " INPUT_PASSWORD
        echo ""

        if [ "$INPUT_PASSWORD" = "$CORRECT_PASSWORD" ]; then
            echo -e "${GREEN}[✓] Access Granted!${NC}"
            sleep 1
            return 0
        else
            attempts=$((attempts + 1))
            remaining=$((MAX_ATTEMPTS - attempts))
            echo -e "${RED}[✗] Wrong Password! Attempts left: $remaining${NC}"
            sleep 1
        fi
    done

    echo -e "${RED}[!] Too many attempts. Exiting...${NC}"
    exit 1
}

check_password

while true; do
    clear

    # --- HEADER ---
    echo -e "${PINK}"
    echo "██████╗ ██████╗  █████╗ ████████╗██╗██╗  ██╗"
    echo "██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║██║ ██╔╝"
    echo "██████╔╝██████╔╝███████║   ██║   ██║█████╔╝"
    echo "██╔═══╝ ██╔══██╗██╔══██║   ██║   ██║██╔═██╗"
    echo "██║     ██║  ██║██║  ██║   ██║   ██║██║  ██╗"
    echo "╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝"
    echo -e "${NC}"

    echo -e "${PURPLE}                    V7.0${NC}"
    echo -e "${GREEN}              PRATIK EXTRAS${NC}"
    echo ""

    echo -e "${PINK}╔══════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${WHITE}        PREMIUM INSTALLER SYSTEM         ${PURPLE}║${NC}"
    echo -e "${PINK}╚══════════════════════════════════════════╝${NC}"
    echo ""

    # --- SYSTEM INFO ---
    echo -e "${CYAN}System Information${NC}"
    echo -e "OS   : $(grep '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '\"')"
    echo -e "RAM  : $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "CPU  : $(nproc) Cores"
    echo -e "User : $(whoami)"
    echo ""

    # --- MENU ---
    echo -e "${WHITE}[1]${NC} ${GREEN}Panels${NC}"
    echo -e "${WHITE}[2]${NC} ${CYAN}NeoFetch Installer${NC}"
    echo -e "${WHITE}[3]${NC} ${RED}Exit${NC}"
    echo ""

    read -rp "Select => " OPTION

    case "$OPTION" in

        1)
            clear
            echo -e "${CYAN}╔════════════════════╗${NC}"
            echo -e "${GREEN}║       PANELS      ║${NC}"
            echo -e "${CYAN}╚════════════════════╝${NC}"
            echo ""

            echo -e "${WHITE}[1]${NC} Crispy Adventure Panel"
            echo -e "${WHITE}[2]${NC} Back"
            echo ""

            read -rp "Select => " PANEL

            case "$PANEL" in
                1)
                    echo -e "${CYAN}[+] Installing Crispy Adventure...${NC}"

                    sudo apt update -y
                    sudo apt upgrade -y

                    rm -rf crispy-adventure
                    git clone https://github.com/pratikgamer11/crispy-adventure

                    cd crispy-adventure || {
                        echo -e "${RED}[!] Clone failed.${NC}"
                        sleep 2
                        continue
                    }

                    sudo apt install -y nodejs npm
                    npm install express

                    echo -e "${GREEN}[✓] Starting panel...${NC}"
                    node index.js 2>/dev/null || node .

                    exit 0
                    ;;

                2)
                    continue
                    ;;
            esac
            ;;

        2)
            clear
            echo -e "${CYAN}[+] Installing NeoFetch...${NC}"
            sudo apt update -y
            sudo apt install -y neofetch
            neofetch
            read -rp "Press Enter to return..."
            ;;

        3)
            echo -e "${GREEN}Goodbye, Pratik! 🙌${NC}"
            exit 0
            ;;

        *)
            echo -e "${RED}Invalid option!${NC}"
            sleep 1
            ;;
    esac
done
            
