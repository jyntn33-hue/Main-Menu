#!/bin/bash
set -euo pipefail

# =============================================================================
# PRATIK EXTRAS V7.0 - PREMIUM INSTALLER SYSTEM
# Enhanced UI | Secure Auth | Resource Monitoring | Error Handling
# =============================================================================

# --- THEME CONFIGURATION ---
declare -A COLORS=(
    [PINK]='\033[38;5;213m'
    [PURPLE]='\033[38;5;99m'
    [GREEN]='\033[38;5;46m'
    [CYAN]='\033[38;5;51m'
    [YELLOW]='\033[1;93m'
    [WHITE]='\033[1;97m'
    [RED]='\033[1;91m'
    [DIM]='\033[2m'
    [NC]='\033[0m'
)

# SHA-256 Hash of "pratik123" (Never store plain text passwords)
PASSWORD_HASH="a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2" 
# NOTE: Replace above with actual hash. Generate via: echo -n "pratik123" | sha256sum | awk '{print $1}'

MAX_ATTEMPTS=3
LOG_FILE="/tmp/pratik_extras_$(date +%Y%m%d_%H%M%S).log"

# --- UTILITY FUNCTIONS ---
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"; }

print_banner() {
    clear
    echo -e "${COLORS[PINK]}"
    cat << "EOF"
    ██████╗ ██████╗  █████╗ ████████╗██╗██╗  ██╗
    ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║██║ ██╔╝
    ██████╔╝██████╔╝███████║   ██║   ██║█████╔╝ 
    ██╔═══╝ ██╔══██╗██╔══██║   ██║   ██║██╔═██╗ 
    ██║     ██║  ██║██║  ██║   ██║   ██║██║  ██╗
    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝
EOF
    echo -e "${COLORS[NC]}"
    echo -e "${COLORS[PURPLE]}                    V7.0${NC}"
    echo -e "${COLORS[GREEN]}              PRATIK EXTRAS${NC}"
    echo -e "${COLORS[DIM]}────────────────────────────────────────────${NC}"
}

show_system_info() {
    local os ram cpu disk user    os=$(grep '^PRETTY_NAME=' /etc/os-release 2>/dev/null | cut -d'=' -f2 | tr -d '"' || echo "Unknown")
    ram=$(free -h 2>/dev/null | awk '/^Mem:/ {print $2}' || echo "N/A")
    cpu=$(nproc 2>/dev/null || echo "N/A")
    disk=$(df -h / 2>/dev/null | awk 'NR==2 {printf "%s/%s (%s)", $3, $2, $5}' || echo "N/A")
    user=$(whoami)

    echo -e "${COLORS[CYAN]}┌─ System Information ─────────────────────┐${NC}"
    printf "${COLORS[WHITE]}│${NC} %-8s : ${COLORS[GREEN]}%-33s${COLORS[WHITE]}│${NC}\n" "OS" "$os"
    printf "${COLORS[WHITE]}│${NC} %-8s : ${COLORS[GREEN]}%-33s${COLORS[WHITE]}│${NC}\n" "User" "$user"
    printf "${COLORS[WHITE]}│${NC} %-8s : ${COLORS[GREEN]}%-33s${COLORS[WHITE]}│${NC}\n" "CPU" "$cpu Cores"
    printf "${COLORS[WHITE]}│${NC} %-8s : ${COLORS[GREEN]}%-33s${COLORS[WHITE]}│${NC}\n" "RAM" "$ram"
    printf "${COLORS[WHITE]}│${NC} %-8s : ${COLORS[GREEN]}%-33s${COLORS[WHITE]}│${NC}\n" "Disk" "$disk"
    echo -e "${COLORS[CYAN]}└──────────────────────────────────────────┘${NC}"
    echo ""
}

loading_bar() {
    local duration=$1
    local width=40
    printf "${COLORS[CYAN]}["
    for ((i=0; i<=width; i++)); do
        sleep "$(echo "scale=4; $duration/$width" | bc)"
        printf "${COLORS[GREEN]}#${COLORS[CYAN]}"
    done
    printf "]${COLORS[NC]} Done!\n"
}

check_dependencies() {
    local deps=("git" "nodejs" "npm" "curl")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${COLORS[YELLOW]}[!] Missing dependencies: ${missing[*]}${NC}"
        read -rp "Install automatically? [Y/n] " confirm
        if [[ "${confirm,,}" != "n" ]]; then
            sudo apt update -y && sudo apt install -y "${missing[@]}"
        else
            echo -e "${COLORS[RED]}[✗] Cannot proceed without dependencies.${NC}"
            exit 1
        fi
    fi
}


    while [ $attempts -lt $MAX_ATTEMPTS ]; do
        print_banner
        echo -e "${COLORS[PURPLE]}╔══════════════════════════════════════════╗${NC}"
        echo -e "${COLORS[PURPLE]}║${COLORS[WHITE]}      🔒 SECURE ACCESS TERMINAL          ${COLORS[PURPLE]}║${NC}"
        echo -e "${COLORS[PURPLE]}╚══════════════════════════════════════════╝${NC}"
        echo ""
        
        read -rsp "Enter Password => " INPUT_PASSWORD
        echo ""
        
        # Compute hash of input and compare
        INPUT_HASH=$(echo -n "$INPUT_PASSWORD" | sha256sum | awk '{print $1}')
        
        if [ "$INPUT_HASH" = "$PASSWORD_HASH" ]; then
            log "Authentication successful"
            echo -e "\n${COLORS[GREEN]}[✓] Access Granted! Welcome back, Pratik.${NC}"
            loading_bar 1
            return 0
        else
            attempts=$((attempts + 1))
            remaining=$((MAX_ATTEMPTS - attempts))
            log "Failed authentication attempt ($attempts/$MAX_ATTEMPTS)"
            echo -e "${COLORS[RED]}[✗] Invalid credentials. Attempts remaining: $remaining${NC}"
            sleep 1.5
        fi
    done
    
    log "Account locked due to excessive failed attempts"
    echo -e "\n${COLORS[RED]}[!] SECURITY ALERT: Too many failed attempts.${NC}"
    echo -e "${COLORS[RED]}[!] Session terminated. Incident logged.${NC}"
    exit 1
}

# --- PANEL INSTALLATION MODULE ---
install_crispy_panel() {
    clear
    print_banner
    echo -e "${COLORS[CYAN]}╔══════════════════════════════════════════╗${NC}"
    echo -e "${COLORS[CYAN]}║${COLORS[WHITE]}    🎮 CRISPY ADVENTURE PANEL SETUP      ${COLORS[CYAN]}║${NC}"
    echo -e "${COLORS[CYAN]}╚══════════════════════════════════════════╝${NC}"
    echo ""
    
    check_dependencies
    
    echo -e "${COLORS[YELLOW]}[*] Cleaning previous installation...${NC}"
    rm -rf ~/crispy-adventure
    loading_bar 0.5
        echo -e "${COLORS[YELLOW]}[*] Cloning repository...${NC}"
    if git clone https://github.com/pratikgamer11/crispy-adventure ~/crispy-adventure 2>>"$LOG_FILE"; then
        cd ~/crispy-adventure
        echo -e "${COLORS[YELLOW]}[*] Installing Node.js dependencies...${NC}"
        npm install express --save 2>>"$LOG_FILE"
        loading_bar 2
        
        echo -e "${COLORS[GREEN]}[✓] Installation complete!${NC}"
        echo -e "${COLORS[CYAN]}[*] Starting panel on port 3000...${NC}"
        log "Crispy Adventure Panel started successfully"
        node index.js 2>>"$LOG_FILE" || node . 2>>"$LOG_FILE"
    else
        echo -e "${COLORS[RED]}[✗] Repository clone failed. Check network or URL.${NC}"
        log "Git clone failed for crispy-adventure"
        read -rp "Press Enter to return..."
    fi
}

# --- MAIN MENU LOOP ---
main_menu() {
    while true; do
        print_banner
        show_system_info
        
        echo -e "${COLORS[WHITE]}┌─ Available Modules ──────────────────────┐${NC}"
        echo -e "${COLORS[WHITE]}│${NC} ${COLORS[WHITE]}[1]${NC} ${COLORS[GREEN]}Panels Manager           ${COLORS[DIM]}►${NC}         ${COLORS[WHITE]}│${NC}"
        echo -e "${COLORS[WHITE]}│${NC} ${COLORS[WHITE]}[2]${NC} ${COLORS[CYAN]}NeoFetch Installer         ${COLORS[DIM]}►${NC}         ${COLORS[WHITE]}│${NC}"
        echo -e "${COLORS[WHITE]}│${NC} ${COLORS[WHITE]}[3]${NC} ${COLORS[YELLOW]}View Logs                  ${COLORS[DIM]}►${NC}         ${COLORS[WHITE]}│${NC}"
        echo -e "${COLORS[WHITE]}│${NC} ${COLORS[WHITE]}[4]${NC} ${COLORS[RED]}Exit System                ${COLORS[DIM]}►${NC}         ${COLORS[WHITE]}│${NC}"
        echo -e "${COLORS[WHITE]}└──────────────────────────────────────────┘${NC}"
        echo ""
        
        read -rp "$(echo -e "${COLORS[PURPLE]}Select Module => ${NC}")" OPTION
        
        case "$OPTION" in
            1)
                clear
                print_banner
                echo -e "${COLORS[CYAN]}╔══════════════════════════════════════════╗${NC}"
                echo -e "${COLORS[CYAN]}║${COLORS[WHITE]}         📦 PANELS SUBMENU               ${COLORS[CYAN]}║${NC}"
                echo -e "${COLORS[CYAN]}╚══════════════════════════════════════════╝${NC}"
                echo ""
                echo -e "${COLORS[WHITE]}[1]${NC} ${COLORS[GREEN]}Crispy Adventure Panel${NC}"
                echo -e "${COLORS[WHITE]}[2]${NC} ${COLORS[YELLOW]}AirLink Panel (Coming Soon)${NC}"
                echo -e "${COLORS[WHITE]}[3]${NC} ${COLORS[RED]}Back to Main Menu${NC}"
                echo ""
                
                read -rp "$(echo -e "${COLORS[PURPLE]}Select Panel => ${NC}")" PANEL
                case "$PANEL" in
                    1) install_crispy_panel ;;                    2) echo -e "${COLORS[YELLOW]}[!] AirLink integration pending...${NC}"; sleep 2 ;;
                    3) continue ;;
                    *) echo -e "${COLORS[RED]}[✗] Invalid selection${NC}"; sleep 1 ;;
                esac
                ;;
            2)
                clear
                print_banner
                echo -e "${COLORS[CYAN]}[*] Installing NeoFetch...${NC}"
                sudo apt update -qq && sudo apt install -y neofetch -qq
                echo ""
                neofetch
                echo ""
                read -rp "$(echo -e "${COLORS[DIM]}Press Enter to continue...${NC}")"
                ;;
            3)
                clear
                print_banner
                echo -e "${COLORS[CYAN]}📋 Session Log: $LOG_FILE${NC}"
                echo -e "${COLORS[DIM]}────────────────────────────────────────────${NC}"
                tail -n 20 "$LOG_FILE" 2>/dev/null || echo "No logs available yet."
                echo -e "${COLORS[DIM]}────────────────────────────────────────────${NC}"
                read -rp "$(echo -e "${COLORS[DIM]}Press Enter to return...${NC}")"
                ;;
            4)
                echo -e "\n${COLORS[GREEN]}🙏 Goodbye, Pratik! Stay awesome! 🚀${NC}"
                log "Session ended normally"
                exit 0
                ;;
            *)
                echo -e "${COLORS[RED]}[✗] Invalid option. Please select 1-4.${NC}"
                sleep 1
                ;;
        esac
    done
}

# --- CLEANUP HANDLER ---
cleanup() {
    echo -e "\n${COLORS[YELLOW]}[!] Interrupted. Cleaning up...${NC}"
    log "Session interrupted by user (SIGINT)"
    exit 130
}
trap cleanup SIGINT SIGTERM

# --- ENTRY POINT ---
authenticate
main_menu            echo -e "${RED}[✗] Wrong Password! Attempts left: $remaining${NC}"
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
            
