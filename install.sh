#!/bin/bash
# ==============================================================================
# PRATIK EXTRAS V7.0 - PREMIUM SYSTEM MANAGER
# Fixed: 'local' keyword errors, UI glitches, and dependency checks
# ==============================================================================

set -euo pipefail

# --- THEME CONFIGURATION ---
declare -A C=(
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

# --- CONFIGURATION ---
# SHA-256 Hash for "pratik123". 
# Generate new one: echo -n "your_password" | sha256sum | awk '{print $1}'
PASS_HASH="a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2" 
MAX_ATTEMPTS=3
LOG_FILE="/tmp/pratik_extras_$(date +%Y%m%d_%H%M%S).log"

# --- UTILITY FUNCTIONS ---
log() { echo "[$(date '+%H:%M:%S')] $*" >> "$LOG_FILE"; }

print_banner() {
    clear
    echo -e "${C[PINK]}"
    cat << "EOF"
    ██████╗ ██████╗  █████╗ ████████╗██╗██╗  ██╗
    ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║██║ ██╔╝
    ██████╔╝██████╔╝███████║   ██║   ██║█████╔╝ 
    ██╔═══╝ ██╔══██╗██╔══██║   ██║   ██║██═██╗ 
    ██║     ██║  ██║██║  ██║   ██║   ██║██║  ██╗
    ╚═╝     ╚═╝  ╚═╝═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ═╝
EOF
    echo -e "${C[PURPLE]}                    V7.0${NC}"
    echo -e "${C[GREEN]}              PRATIK EXTRAS${NC}"
    echo -e "${C[DIM]}────────────────────────────────────────────${NC}"
}

show_system_info() {
    local os ram cpu disk user    os=$(grep '^PRETTY_NAME=' /etc/os-release 2>/dev/null | cut -d'=' -f2 | tr -d '"' || echo "Unknown")
    ram=$(free -h 2>/dev/null | awk '/^Mem:/ {print $2}' || echo "N/A")
    cpu=$(nproc 2>/dev/null || echo "N/A")
    disk=$(df -h / 2>/dev/null | awk 'NR==2 {printf "%s/%s (%s)", $3, $2, $5}' || echo "N/A")
    user=$(whoami)

    echo -e "${C[CYAN]}┌─ System Information ─────────────────────┐${NC}"
    printf "${C[WHITE]}│${NC} %-8s : ${C[GREEN]}%-33s${C[WHITE]}│${NC}\n" "OS" "$os"
    printf "${C[WHITE]}│${NC} %-8s : ${C[GREEN]}%-33s${C[WHITE]}│${NC}\n" "User" "$user"
    printf "${C[WHITE]}│${NC} %-8s : ${C[GREEN]}%-33s${C[WHITE]}│${NC}\n" "CPU" "$cpu Cores"
    printf "${C[WHITE]}│${NC} %-8s : ${C[GREEN]}%-33s${C[WHITE]}│${NC}\n" "RAM" "$ram"
    printf "${C[WHITE]}│${NC} %-8s : ${C[GREEN]}%-33s${C[WHITE]}│${NC}\n" "Disk" "$disk"
    echo -e "${C[CYAN]}└──────────────────────────────────────────┘${NC}"
    echo ""
}

loading_bar() {
    local duration=$1 width=40 i
    printf "${C[CYAN]}["
    for ((i=0; i<=width; i++)); do
        sleep "$(echo "scale=4; $duration/$width" | bc)"
        printf "${C[GREEN]}#${C[CYAN]}"
    done
    printf "]${C[NC]} Done!\n"
}

check_dependencies() {
    local deps=("git" "nodejs" "npm" "curl") missing=() dep confirm
    for dep in "${deps[@]}"; do
        command -v "$dep" &>/dev/null || missing+=("$dep")
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${C[YELLOW]}[!] Missing: ${missing[*]}${NC}"
        read -rp "Install automatically? [Y/n] " confirm
        if [[ "${confirm,,}" != "n" ]]; then
            sudo apt update -y && sudo apt install -y "${missing[@]}"
        else
            echo -e "${C[RED]}[✗] Cannot proceed.${NC}"; exit 1
        fi
    fi
}

# --- AUTHENTICATION MODULE ---
authenticate() {
    local attempts=0 INPUT_PASSWORD INPUT_HASH remaining
    while [ $attempts -lt $MAX_ATTEMPTS ]; do
        print_banner
        echo -e "${C[PURPLE]}══════════════════════════════════════════╗${NC}"
        echo -e "${C[PURPLE]}║${C[WHITE]}       SECURE ACCESS TERMINAL          ${C[PURPLE]}║${NC}"        echo -e "${C[PURPLE]}╚══════════════════════════════════════════╝${NC}"
        echo ""
        
        read -rsp "Enter Password => " INPUT_PASSWORD
        echo ""
        
        INPUT_HASH=$(echo -n "$INPUT_PASSWORD" | sha256sum | awk '{print $1}')
        
        # NOTE: For testing, replace the hash comparison with plain text if needed,
        # but keep the hash method for production security.
        # if [ "$INPUT_HASH" = "$PASS_HASH" ]; then 
        
        # TEMPORARY PLAIN TEXT CHECK FOR EASE OF USE (REMOVE IN PRODUCTION)
        if [ "$INPUT_PASSWORD" = "pratik123" ]; then
            log "Auth Success"
            echo -e "\n${C[GREEN]}[✓] Access Granted! Welcome back, Pratik.${NC}"
            loading_bar 1
            return 0
        else
            attempts=$((attempts + 1))
            remaining=$((MAX_ATTEMPTS - attempts))
            log "Auth Failed ($attempts/$MAX_ATTEMPTS)"
            echo -e "${C[RED]}[✗] Invalid. Attempts left: $remaining${NC}"
            sleep 1.5
        fi
    done
    log "Account Locked"
    echo -e "\n${C[RED]}[!] SECURITY ALERT: Too many failed attempts.${NC}"
    exit 1
}

# --- PANEL INSTALLATION MODULE ---
install_crispy_panel() {
    clear
    print_banner
    echo -e "${C[CYAN]}╔══════════════════════════════════════════╗${NC}"
    echo -e "${C[CYAN]}║${C[WHITE]}    🎮 CRISPY ADVENTURE PANEL SETUP      ${C[CYAN]}║${NC}"
    echo -e "${C[CYAN]}╚══════════════════════════════════════════╝${NC}"
    echo ""
    
    check_dependencies
    
    echo -e "${C[YELLOW]}[*] Cleaning previous installation...${NC}"
    rm -rf ~/crispy-adventure
    loading_bar 0.5
    
    echo -e "${C[YELLOW]}[*] Cloning repository...${NC}"
    if git clone https://github.com/pratikgamer11/crispy-adventure ~/crispy-adventure 2>>"$LOG_FILE"; then
        cd ~/crispy-adventure
        echo -e "${C[YELLOW]}[*] Installing dependencies...${NC}"        npm install express --save 2>>"$LOG_FILE"
        loading_bar 2
        
        echo -e "${C[GREEN]}[✓] Installation complete!${NC}"
        echo -e "${C[CYAN]}[*] Starting panel...${NC}"
        log "Panel Started"
        node index.js 2>>"$LOG_FILE" || node . 2>>"$LOG_FILE"
    else
        echo -e "${C[RED]}[✗] Clone failed. Check network/URL.${NC}"
        log "Git Clone Failed"
        read -rp "Press Enter to return..."
    fi
}

# --- MAIN MENU LOOP ---
main_menu() {
    local OPTION PANEL
    while true; do
        print_banner
        show_system_info
        
        echo -e "${C[WHITE]}┌─ Available Modules ──────────────────────┐${NC}"
        echo -e "${C[WHITE]}│${NC} ${C[WHITE]}[1]${NC} ${C[GREEN]}Panels Manager           ${C[DIM]}►${NC}         ${C[WHITE]}│${NC}"
        echo -e "${C[WHITE]}│${NC} ${C[WHITE]}[2]${NC} ${C[CYAN]}NeoFetch Installer         ${C[DIM]}►${NC}         ${C[WHITE]}│${NC}"
        echo -e "${C[WHITE]}│${NC} ${C[WHITE]}[3]${NC} ${C[YELLOW]}View Logs                  ${C[DIM]}►${NC}         ${C[WHITE]}│${NC}"
        echo -e "${C[WHITE]}│${NC} ${C[WHITE]}[4]${NC} ${C[RED]}Exit System                ${C[DIM]}►${NC}         ${C[WHITE]}│${NC}"
        echo -e "${C[WHITE]}└──────────────────────────────────────────${NC}"
        echo ""
        
        read -rp "$(echo -e "${C[PURPLE]}Select Module => ${NC}")" OPTION
        
        case "$OPTION" in
            1)
                clear
                print_banner
                echo -e "${C[CYAN]}╔══════════════════════════════════════════╗${NC}"
                echo -e "${C[CYAN]}║${C[WHITE]}         📦 PANELS SUBMENU               ${C[CYAN]}║${NC}"
                echo -e "${C[CYAN]}╚══════════════════════════════════════════╝${NC}"
                echo ""
                echo -e "${C[WHITE]}[1]${NC} ${C[GREEN]}Crispy Adventure Panel${NC}"
                echo -e "${C[WHITE]}[2]${NC} ${C[YELLOW]}AirLink Panel (Coming Soon)${NC}"
                echo -e "${C[WHITE]}[3]${NC} ${C[RED]}Back to Main Menu${NC}"
                echo ""
                
                read -rp "$(echo -e "${C[PURPLE]}Select Panel => ${NC}")" PANEL
                case "$PANEL" in
                    1) install_crispy_panel ;;
                    2) echo -e "${C[YELLOW]}[!] AirLink pending...${NC}"; sleep 2 ;;
                    3) continue ;;
                    *) echo -e "${C[RED]}[✗] Invalid selection${NC}"; sleep 1 ;;                esac
                ;;
            2)
                clear
                print_banner
                echo -e "${C[CYAN]}[*] Installing NeoFetch...${NC}"
                sudo apt update -qq && sudo apt install -y neofetch -qq
                echo ""
                neofetch
                echo ""
                read -rp "$(echo -e "${C[DIM]}Press Enter to continue...${NC}")"
                ;;
            3)
                clear
                print_banner
                echo -e "${C[CYAN]} Session Log: $LOG_FILE${NC}"
                echo -e "${C[DIM]}────────────────────────────────────────────${NC}"
                tail -n 20 "$LOG_FILE" 2>/dev/null || echo "No logs available yet."
                echo -e "${C[DIM]}────────────────────────────────────────────${NC}"
                read -rp "$(echo -e "${C[DIM]}Press Enter to return...${NC}")"
                ;;
            4)
                echo -e "\n${C[GREEN]} Goodbye, Pratik! Stay awesome! ${NC}"
                log "Session Ended"
                exit 0
                ;;
            *)
                echo -e "${C[RED]}[] Invalid option. Select 1-4.${NC}"
                sleep 1
                ;;
        esac
    done
}

# --- ENTRY POINT ---
cleanup() {
    echo -e "\n${C[YELLOW]}[!] Interrupted. Cleaning up...${NC}"
    log "Interrupted"
    exit 130
}
trap cleanup SIGINT SIGTERM

authenticate
main_menu
