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

    # --- HEADER (Fixed: No more EOF issues) ---
    echo -e "${PINK}"
    echo "██████╗ ██████╗  █████╗ ████████╗██╗██╗  ██╗"    echo "██╔══██╗██══██╗██╔══██╗╚══██╔══╝██║██║ ██╔╝"
    echo "██████╝██████╔╝███████║   ██║   ██║█████╔╝"
    echo "██╔═══╝ ██══██╗██╔══██║   ██║   ██║██╔═██╗"
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
    echo -e "OS      : $(grep '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '\"')"
    echo -e "RAM     : $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "CPU     : $(nproc) Cores"
    echo -e "User    : $(whoami)"
    echo ""

    # --- MAIN MENU ---
    echo -e "${WHITE}[1]${NC} ${GREEN}Panels${NC}"
    echo -e "${YELLOW}[2]${NC} ${CYAN}Neo${WHITE}Fetch ${CYAN}Installer${NC}"
    echo -e "${WHITE}[3]${NC} ${RED}Exit${NC}"
    echo ""

    read -rp "Select => " OPTION

    case "$OPTION" in
        1)
            clear
            echo -e "${CYAN}╔════════════════════════════╗${NC}"
            echo -e "${GREEN}║          PANELS           ║${NC}"
            echo -e "${CYAN}╚════════════════════════════╝${NC}"
            echo ""
            echo -e "${WHITE}[1]${NC} ${GREEN}UnOfficial Panel (Crispy Adventure)${NC}"
            echo -e "${WHITE}[2]${NC} ${RED}Back${NC}"
            echo ""
            read -rp "Select => " PANEL

            case "$PANEL" in
                1)
                    echo -e "${CYAN}[+] Installing Crispy Adventure Panel...${NC}"
                    sudo apt update -y
                    sudo apt upgrade -y
                    rm -rf crispy-adventure                    git clone https://github.com/pratikgamer11/crispy-adventure
                    cd crispy-adventure || { echo -e "${RED}[!] Clone failed.${NC}"; sleep 2; continue; }
                    apt install -y nodejs
                    npm install express
                    echo -e "${GREEN}[✓] Starting panel...${NC}"
                    node .
                    exit 0
                    ;;
                2)
                    continue
                    ;;
                *)
                    echo -e "${RED}[!] Invalid choice.${NC}"
                    sleep 1
                    ;;
            esac
            ;;

        2)
            clear
            echo -e "${CYAN}[+] Updating system & installing NeoFetch...${NC}"
            apt update -y
            apt upgrade -y
            apt install -y neofetch
            echo -e "${GREEN}[✓] Done!${NC}"
            neofetch
            echo ""
            read -rp "Press Enter to return..."
            ;;

        3)
            echo -e "${GREEN}Goodbye, Pratik! 🙌${NC}"
            exit 0
            ;;

        *)
            echo -e "${RED}[!] Please enter 1, 2, or 3.${NC}"
            sleep 1
            ;;
    esac
done        fi
    done
    echo -e "${RED}[!] Too many attempts. Exiting...${NC}"
    exit 1
}

check_password

while true; do
    clear

    # Logo
    echo -e "${PINK}"
    cat << "EOF"██████╗ ██████╗  █████╗ ████████╗██╗██╗  ██╗
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

    # System Info
    echo -e "${CYAN}System Information${NC}"
    echo -e "OS      : $(grep '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '\"')"
    echo -e "RAM     : $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "CPU     : $(nproc) Cores"
    echo -e "User    : $(whoami)"
    echo ""

    # Main Menu
    echo -e "${WHITE}[1]${NC} ${GREEN}Panels${NC}"
    echo -e "${YELLOW}[2]${NC} ${CYAN}Neo${WHITE}Fetch ${CYAN}Installer${NC}"
    echo -e "${WHITE}[3]${NC} ${RED}Exit${NC}"
    echo ""

    read -rp "Select => " OPTION

    case "$OPTION" in
        1)
            clear
            echo -e "${CYAN}╔════════════════════════════╗${NC}"
            echo -e "${GREEN}║          PANELS           ║${NC}"
            echo -e "${CYAN}╚════════════════════════════╝${NC}"
            echo ""
            echo -e "${WHITE}[1]${NC} ${GREEN}UnOfficial Panel (Crispy Adventure)${NC}"
            echo -e "${WHITE}[2]${NC} ${RED}Back${NC}"
            echo ""
            read -rp "Select => " PANEL

            case "$PANEL" in
                1)
                    echo -e "${CYAN}[+] Installing Crispy Adventure Panel...${NC}"
                    sudo apt update -y
                    sudo apt upgrade -y
                    rm -rf crispy-adventure                    git clone https://github.com/pratikgamer11/crispy-adventure
                    cd crispy-adventure || { echo -e "${RED}[!] Clone failed.${NC}"; sleep 2; continue; }
                    apt install -y nodejs
                    npm install express
                    echo -e "${GREEN}[✓] Starting panel...${NC}"
                    node .
                    exit 0
                    ;;
                2)
                    continue
                    ;;
                *)
                    echo -e "${RED}[!] Invalid choice.${NC}"
                    sleep 1
                    ;;
            esac
            ;;

        2)
            clear
            echo -e "${CYAN}[+] Updating system & installing NeoFetch...${NC}"
            apt update -y
            apt upgrade -y
            apt install -y neofetch
            echo -e "${GREEN}[✓] Done!${NC}"
            neofetch
            echo ""
            read -rp "Press Enter to return..."
            ;;

        3)
            echo -e "${GREEN}Goodbye, Pratik! 🙌${NC}"
            exit 0
            ;;

        *)
            echo -e "${RED}[!] Please enter 1, 2, or 3.${NC}"
            sleep 1
            ;;
    esac
done    # Header
    echo -e "${PINK}╔══════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${WHITE}        PREMIUM INSTALLER SYSTEM         ${PURPLE}║${NC}"
    echo -e "${PINK}╚══════════════════════════════════════════╝${NC}"
    echo ""

    # System Info
    echo -e "${CYAN}System Information${NC}"
    echo -e "OS      : $(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '\"')"
    echo -e "RAM     : $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "CPU     : $(nproc) Cores"
    echo -e "User    : $(whoami)"
    echo ""

    # Menu Options (Multi-color)
    echo -e "${WHITE}[1]${NC} ${GREEN}Panels${NC}"
    echo -e "${YELLOW}[2]${NC} ${CYAN}Neo${WHITE}Fetch ${CYAN}Installer${NC}"
    echo -e "${WHITE}[3]${NC} ${RED}Exit${NC}"
    echo ""

    # Input
    read -rp "Select => " OPTION

    case "$OPTION" in
        1)
            clear
            echo -e "${CYAN}╔════════════════════════════╗${NC}"
            echo -e "${GREEN}║          PANELS           ║${NC}"
            echo -e "${CYAN}╚════════════════════════════╝${NC}"
            echo ""
            echo -e "${WHITE}[1]${NC} ${GREEN}UnOfficial Panel (Crispy Adventure)${NC}"
            echo -e "${WHITE}[2]${NC} ${RED}Back${NC}"
            echo ""
            read -rp "Select => " PANEL
            case "$PANEL" in
                1)
                    echo ""
                    echo -e "${CYAN}[+] Starting One-Click Installation...${NC}"
                    sudo apt update -y && \
                    sudo apt upgrade -y && \
                    git clone https://github.com/pratikgamer11/crispy-adventure && \
                    cd crispy-adventure && \
                    apt install -y nodejs && \
                    npm install express && \
                    node .
                    exit 0
                    ;;
                2)
                    continue
                    ;;
                *)
                    echo -e "${RED}[!] Invalid selection.${NC}"
                    sleep 1
                    ;;
            esac
            ;;

        2)
            clear
            echo -e "${CYAN}[+] Installing NeoFetch & Updating System...${NC}"
            apt update -y && \
            apt upgrade -y && \
            apt install -y neofetch

            echo ""
            echo -e "${GREEN}[✓] NeoFetch Installed Successfully!${NC}"
            neofetch
            echo ""
            read -rp "Press Enter to continue..."
            ;;

        3)
            echo -e "${GREEN}Goodbye, Pratik!${NC}"
            exit 0
            ;;

        *)
            echo -e "${RED}[!] Invalid option: '$OPTION'. Please enter 1, 2, or 3.${NC}"
            sleep 1
            ;;
    esac
    
        fi
        
    done
    
    echo -e "${RED}[!] Maximum attempts exceeded. Exiting...${NC}"
    exit 1
}

check_password

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

# Multi-color Menu Options
echo -e "${WHITE}[1]${NC} ${GREEN}Panels${NC}"
echo -e "${YELLOW}[2]${NC} ${CYAN}Neo${WHITE}Fetch ${CYAN}Installer${NC}"
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
    echo -e "${WHITE}[1]${NC} ${GREEN}UnOfficial Panel (Crispy Adventure)${NC}"
    echo -e "${WHITE}[2]${NC} ${RED}Back${NC}"
    echo ""
    read -p "Select => " PANEL

    case $PANEL in    1)
        echo ""
        echo -e "${CYAN}[+] Starting One-Click Installation...${NC}"
        sudo apt update -y && sudo apt upgrade -y && git clone https://github.com/pratikgamer11/crispy-adventure && cd crispy-adventure && apt install nodejs -y && npm install express && node .
        exit 0
        ;;
    2)
        ;;
    esac
    ;;

2)
    clear
    echo -e "${CYAN}[+] Installing NeoFetch & Updating System...${NC}"
    # Your requested command
    apt install neofetch -y && apt update -y && apt upgrade -y
    
    echo ""
    echo -e "${GREEN}[✓] Installation Complete!${NC}"
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

done        fi
    done
    
    echo -e "${RED}[!] Maximum attempts exceeded. Exiting...${NC}"
    exit 1
}

check_password

while true; do

clear

echo -e "${PINK}"cat << "EOF"

██████╗ ██████╗  █████╗ ████████╗██╗██╗  ██╗
██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║██║ ██╔╝
██████╔╝██████╔╝███████║   ██║   ██║█████╔╝
██╔═══╝ ██══██╗██╔══██║   ██║   ██║██╔═██╗
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

echo -e "${WHITE}[1]${NC} ${GREEN}UnOfficial Panel (Crispy Adventure)${NC}"
echo -e "${WHITE}[2]${NC} ${CYAN}Pterodactyl Panel (Official)${NC}"
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
        echo ""        echo -e "${CYAN}[+] Starting One-Click Installation...${NC}"
        sudo apt update -y && sudo apt upgrade -y && git clone https://github.com/pratikgamer11/crispy-adventure && cd crispy-adventure && apt install nodejs -y && npm install express && node .
        exit 0
        ;;
    2)
        ;;
    esac
    ;;

2)
    clear
    echo -e "${CYAN}[+] Preparing Pterodactyl Installation...${NC}"
    echo -e "${YELLOW}Note: This will install the official Pterodactyl Panel.${NC}"
    echo -e "${YELLOW}Requirements: Fresh Ubuntu/Debian Server & Domain Name.${NC}"
    echo ""
    read -p "Press Enter to continue or Ctrl+C to cancel..."
    
    # Official Pterodactyl Installer Script Execution
    curl -sSL https://install.pterodactyl.io | bash
    
    echo ""
    echo -e "${GREEN}[✓] Installation Script Finished.${NC}"
    echo -e "${CYAN}Please follow the on-screen instructions to complete database and admin setup.${NC}"
    read -p "Press Enter to go back..."
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

done
