#!/bin/bash

# =============================================================================
#   PRATIK EXTRAS V10 ULTRA - Professional VPS Management Suite
#   Fixed, Enhanced & Beautified Edition
# =============================================================================

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# GLOBAL VARIABLES
# ─────────────────────────────────────────────────────────────────────────────
LOG_FILE="/tmp/pratik_extras.log"
PASSWORD_FILE="/tmp/.pratik_extras_password"
LOCKOUT_FILE="/tmp/.pratik_extras_lockout"
FAILED_ATTEMPTS_FILE="/tmp/.failed_attempts"
SESSION_FILE="/tmp/.pratik_session"
BACKUP_DIR="/tmp/backups"
VERSION="V10 ULTRA"

# ─────────────────────────────────────────────────────────────────────────────
# COLORS & GRADIENTS (256-color + true-color ANSI)
# ─────────────────────────────────────────────────────────────────────────────
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
BLINK='\033[5m'

# Foreground colors
BLACK='\033[30m'
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
MAGENTA='\033[95m'
CYAN='\033[96m'
WHITE='\033[97m'

# 256-color palette for gradients
C1='\033[38;5;201m'   # Hot pink
C2='\033[38;5;171m'   # Violet-pink
C3='\033[38;5;141m'   # Soft purple
C4='\033[38;5;111m'   # Periwinkle
C5='\033[38;5;87m'    # Aqua cyan
C6='\033[38;5;51m'    # Electric cyan
C7='\033[38;5;45m'    # Sky blue
C8='\033[38;5;39m'    # Ocean blue
C9='\033[38;5;226m'   # Neon yellow
C10='\033[38;5;208m'  # Orange

# Background colors
BG_BLACK='\033[40m'
BG_DARK='\033[48;5;235m'
BG_DARKER='\033[48;5;232m'
BG_BLUE='\033[48;5;17m'
BG_PURPLE='\033[48;5;54m'

# ─────────────────────────────────────────────────────────────────────────────
# UTILITY FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────

log_action() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$LOG_FILE" 2>/dev/null || true
}

print_color() {
    local color="${1:-$RESET}"
    local message="${2:-}"
    echo -e "${color}${message}${RESET}"
}

# Print a gradient text line (cycles through colors character by character)
print_gradient_line() {
    local text="$1"
    local colors=("$C1" "$C2" "$C3" "$C4" "$C5" "$C6" "$C7" "$C8")
    local len=${#text}
    local output=""
    for ((i=0; i<len; i++)); do
        local idx=$((i % ${#colors[@]}))
        output+="${colors[$idx]}${text:$i:1}"
    done
    echo -e "${output}${RESET}"
}

# Terminal width helper
term_width() {
    tput cols 2>/dev/null || echo 80
}

# Centered text
center_text() {
    local text="$1"
    local color="${2:-$WHITE}"
    local width
    width=$(term_width)
    local text_len=${#text}
    local pad=$(( (width - text_len) / 2 ))
    printf "%${pad}s" ""
    echo -e "${color}${BOLD}${text}${RESET}"
}

# Separator line with gradient
print_separator() {
    local width
    width=$(term_width)
    local chars=""
    local colors=("$C1" "$C2" "$C3" "$C4" "$C5" "$C6" "$C7" "$C8")
    for ((i=0; i<width; i++)); do
        local idx=$((i % ${#colors[@]}))
        chars+="${colors[$idx]}─"
    done
    echo -e "${chars}${RESET}"
}

# Thin separator
print_thin_sep() {
    local width
    width=$(term_width)
    printf "${DIM}${C3}"
    printf '─%.0s' $(seq 1 "$width")
    echo -e "${RESET}"
}

# Box drawing with gradient border
print_box_line() {
    local left="$1"
    local text="$2"
    local right="$3"
    local color="${4:-$C3}"
    echo -e "${color}${left}${RESET} ${text} ${color}${right}${RESET}"
}

# Status indicator
status_dot() {
    local status="$1"
    case "${status,,}" in
        active|running|connected|yes|ok|available) echo -e "${GREEN}${BOLD}●${RESET}" ;;
        inactive|stopped|disconnected|no) echo -e "${RED}${BOLD}●${RESET}" ;;
        unknown|"not installed") echo -e "${YELLOW}${BOLD}●${RESET}" ;;
        *) echo -e "${DIM}●${RESET}" ;;
    esac
}

# Animated spinner
spinner() {
    local pid=$1
    local msg="${2:-Working}"
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        local idx=$((i % ${#frames[@]}))
        printf "\r${C5}${frames[$idx]}${RESET} ${WHITE}${msg}...${RESET}"
        ((i++))
        sleep 0.1
    done
    printf "\r${GREEN}✔${RESET} ${WHITE}${msg} done!${RESET}\n"
}

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local filled=$(( current * width / total ))
    local empty=$(( width - filled ))
    local percent=$(( current * 100 / total ))

    local bar="${C5}["
    for ((i=0; i<filled; i++)); do bar+="${C1}█"; done
    for ((i=0; i<empty; i++)); do bar+="${DIM}░"; done
    bar+="${C5}]${RESET}"

    printf "\r${bar} ${BOLD}${WHITE}%3d%%${RESET}" "$percent"
}

# Loading animation
show_loading() {
    local duration="${1:-3}"
    local msg="${2:-Loading}"
    local steps=$(( duration * 10 ))

    echo -ne "${C4}${msg}${RESET} "
    for ((i=1; i<=steps; i++)); do
        progress_bar "$i" "$steps"
        sleep 0.1
    done
    echo ""
}

# Require root for destructive operations
require_root() {
    if [[ $EUID -ne 0 ]]; then
        print_color "$RED" "  ${BOLD}✗ Root privileges required for this operation.${RESET}"
        print_color "$YELLOW" "  Run with: ${BOLD}sudo $0${RESET}"
        return 1
    fi
    return 0
}

# Check dependency, return 0 if available
check_dependency() {
    local cmd="$1"
    command -v "$cmd" &>/dev/null
}

# ─────────────────────────────────────────────────────────────────────────────
# HEADER / BANNER
# ─────────────────────────────────────────────────────────────────────────────
print_banner() {
    clear
    echo ""
    print_separator
    echo ""

    center_text "██████╗ ██████╗  █████╗ ████████╗██╗██╗  ██╗" "$C1"
    center_text "██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║██║ ██╔╝" "$C2"
    center_text "██████╔╝██████╔╝███████║   ██║   ██║█████╔╝ " "$C3"
    center_text "██╔═══╝ ██╔══██╗██╔══██║   ██║   ██║██╔═██╗ " "$C4"
    center_text "██║     ██║  ██║██║  ██║   ██║   ██║██║  ██╗" "$C5"
    center_text "╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝" "$C6"

    echo ""
    center_text "E X T R A S  ─  ${VERSION}" "$C3"
    center_text "Professional VPS Management Suite" "$DIM$WHITE"
    echo ""
    print_separator
    echo ""
}

# Compact header for sub-menus
print_header() {
    local title="${1:-Menu}"
    clear
    echo ""
    print_thin_sep
    echo -e "  ${C1}${BOLD}✦ PRATIK EXTRAS${RESET}  ${DIM}│${RESET}  ${C5}${BOLD}${title}${RESET}"
    print_thin_sep
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# AUTHENTICATION
# ─────────────────────────────────────────────────────────────────────────────
authenticate() {
    # Check lockout
    if [[ -f "$LOCKOUT_FILE" ]]; then
        local lockout_time current_time time_diff remaining
        lockout_time=$(stat -c %Y "$LOCKOUT_FILE" 2>/dev/null || stat -f %m "$LOCKOUT_FILE" 2>/dev/null || echo 0)
        current_time=$(date +%s)
        time_diff=$(( current_time - lockout_time ))
        remaining=$(( 300 - time_diff ))

        if [[ $time_diff -lt 300 ]]; then
            print_banner
            echo -e "  ${RED}${BOLD}🔒 Account Locked${RESET}"
            echo -e "  ${YELLOW}Too many failed attempts. Try again in ${BOLD}${remaining}s${RESET}${YELLOW}.${RESET}"
            echo ""
            exit 1
        else
            rm -f "$LOCKOUT_FILE" "$FAILED_ATTEMPTS_FILE"
        fi
    fi

    # First-time password setup
    if [[ ! -f "$PASSWORD_FILE" ]]; then
        print_banner
        echo -e "  ${C3}${BOLD}🔐 First Run — Set Your Password${RESET}"
        echo ""

        local password confirm_password
        while true; do
            read -r -s -p "$(echo -e "  ${C5}Enter new password: ${RESET}")" password
            echo ""
            read -r -s -p "$(echo -e "  ${C5}Confirm password:   ${RESET}")" confirm_password
            echo ""

            if [[ -z "$password" ]]; then
                print_color "$RED" "  Password cannot be empty."
            elif [[ "$password" != "$confirm_password" ]]; then
                print_color "$RED" "  Passwords do not match. Try again."
            else
                break
            fi
        done

        echo -n "$password" | sha256sum | cut -d' ' -f1 > "$PASSWORD_FILE"
        chmod 600 "$PASSWORD_FILE"
        echo ""
        print_color "$GREEN" "  ${BOLD}✔ Password set successfully!${RESET}"
        sleep 1
    fi

    # Login prompt
    print_banner
    echo -e "  ${C3}${BOLD}🔐 Authentication Required${RESET}"
    echo ""

    local max_attempts=3
    local attempts=0

    while [[ $attempts -lt $max_attempts ]]; do
        local remaining_attempts=$(( max_attempts - attempts ))
        local dot_color="$GREEN"
        [[ $remaining_attempts -eq 2 ]] && dot_color="$YELLOW"
        [[ $remaining_attempts -eq 1 ]] && dot_color="$RED"

        echo -e "  ${DIM}Attempts remaining: ${dot_color}${BOLD}${remaining_attempts}${RESET}"
        local input_password
        read -r -s -p "$(echo -e "  ${C5}Password: ${RESET}")" input_password
        echo ""

        local hashed_input stored_hash
        hashed_input=$(echo -n "$input_password" | sha256sum | cut -d' ' -f1)
        stored_hash=$(cat "$PASSWORD_FILE")

        if [[ "$hashed_input" == "$stored_hash" ]]; then
            echo ""
            print_color "$GREEN" "  ${BOLD}✔ Authentication successful!${RESET}"
            touch "$SESSION_FILE"
            log_action "User authenticated successfully"
            sleep 0.8
            return 0
        else
            (( attempts++ )) || true
            echo ""
            print_color "$RED" "  ${BOLD}✗ Incorrect password.${RESET}"
            log_action "Failed authentication attempt ($attempts/$max_attempts)"
            echo ""

            if [[ $attempts -ge $max_attempts ]]; then
                echo -e "  ${RED}${BOLD}🔒 Too many failed attempts. Account locked for 5 minutes.${RESET}"
                touch "$LOCKOUT_FILE"
                log_action "Account locked due to failed attempts"
                exit 1
            fi
        fi
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# ENVIRONMENT DETECTION
# ─────────────────────────────────────────────────────────────────────────────
detect_environment() {
    if [[ -f /.dockerenv ]]; then
        echo "Docker Container"
    elif [[ -n "${CODESPACES:-}" ]]; then
        echo "GitHub Codespace"
    elif [[ -n "${KUBERNETES_SERVICE_HOST:-}" ]]; then
        echo "Kubernetes Pod"
    elif [[ -d "/run/systemd/system" ]]; then
        echo "Standard VPS / Linux"
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "macOS"
    else
        echo "Unknown Environment"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# SYSTEM INFO HELPERS
# ─────────────────────────────────────────────────────────────────────────────
get_cpu_usage() {
    # Use /proc/stat for accuracy instead of top parsing
    local idle1 total1 idle2 total2
    read -r _ user1 nice1 system1 idle1 iowait1 irq1 softirq1 <<< "$(grep '^cpu ' /proc/stat)"
    total1=$(( user1 + nice1 + system1 + idle1 + iowait1 + irq1 + softirq1 ))
    sleep 0.3
    read -r _ user2 nice2 system2 idle2 iowait2 irq2 softirq2 <<< "$(grep '^cpu ' /proc/stat)"
    total2=$(( user2 + nice2 + system2 + idle2 + iowait2 + irq2 + softirq2 ))
    local idle_delta=$(( idle2 - idle1 ))
    local total_delta=$(( total2 - total1 ))
    if [[ $total_delta -gt 0 ]]; then
        printf "%.1f" "$(echo "scale=1; (1 - $idle_delta / $total_delta) * 100" | bc 2>/dev/null || echo 0)"
    else
        echo "0.0"
    fi
}

get_public_ip() {
    local ip
    ip=$(curl -s --max-time 4 https://api.ipify.org 2>/dev/null \
        || curl -s --max-time 4 https://ifconfig.me 2>/dev/null \
        || echo "N/A")
    echo "$ip"
}

get_service_status() {
    local service="$1"
    if check_dependency "systemctl"; then
        systemctl is-active "$service" 2>/dev/null || echo "inactive"
    else
        echo "unknown"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# INFO LABEL PRINTER
# ─────────────────────────────────────────────────────────────────────────────
info_row() {
    local label="$1"
    local value="$2"
    local icon="${3:-  }"
    printf "  ${icon} ${C4}${BOLD}%-20s${RESET} ${WHITE}%s${RESET}\n" "${label}:" "${value}"
}

info_row_status() {
    local label="$1"
    local value="$2"
    local icon="${3:-  }"
    local dot
    dot=$(status_dot "$value")
    printf "  ${icon} ${C4}${BOLD}%-20s${RESET} ${dot} ${WHITE}%s${RESET}\n" "${label}:" "${value}"
}

# ─────────────────────────────────────────────────────────────────────────────
# MAIN DASHBOARD
# ─────────────────────────────────────────────────────────────────────────────
show_dashboard() {
    print_header "System Overview"

    # ── System ───────────────────────────────────────────────────────────────
    echo -e "  ${C1}${BOLD}◈  SYSTEM${RESET}"
    print_thin_sep

    local os_name kernel_version cpu_cores ram_total ram_used disk_total disk_used disk_pct public_ip local_ip uptime_str
    os_name=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || uname -s)
    kernel_version=$(uname -r)
    cpu_cores=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo 2>/dev/null || echo "?")
    ram_total=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}' || echo "?")
    ram_used=$(free -h 2>/dev/null | awk '/^Mem:/{print $3}' || echo "?")
    disk_total=$(df -h / 2>/dev/null | awk 'NR==2{print $2}' || echo "?")
    disk_used=$(df -h / 2>/dev/null | awk 'NR==2{print $3}' || echo "?")
    disk_pct=$(df / 2>/dev/null | awk 'NR==2{print $5}' || echo "?")
    public_ip=$(get_public_ip)
    local_ip=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "?")
    uptime_str=$(uptime -p 2>/dev/null || uptime | sed 's/.*up /up /' | cut -d, -f1)

    info_row "OS" "$os_name" "🐧"
    info_row "Kernel" "$kernel_version" "⚙️ "
    info_row "CPU Cores" "$cpu_cores" "💻"
    info_row "RAM" "${ram_used} / ${ram_total}" "🧠"
    info_row "Disk" "${disk_used} / ${disk_total} (${disk_pct})" "💾"
    info_row "Public IP" "$public_ip" "🌐"
    info_row "Local IP" "$local_ip" "🔗"
    info_row "Uptime" "$uptime_str" "⏱️ "
    info_row "Environment" "$(detect_environment)" "🔍"

    echo ""

    # ── Services ─────────────────────────────────────────────────────────────
    echo -e "  ${C5}${BOLD}◈  SERVICES${RESET}"
    print_thin_sep

    # Docker
    local docker_status="Not Installed"
    if check_dependency "docker"; then
        if docker info &>/dev/null 2>&1; then
            docker_status="Active"
        else
            docker_status="Inactive"
        fi
    fi

    # Wings
    local wings_status="Not Installed"
    if [[ -f "/usr/local/bin/wings" ]] || [[ -f "/usr/bin/wings" ]]; then
        wings_status=$(get_service_status "wings")
    fi

    # Node.js
    local nodejs_ver="Not Installed"
    check_dependency "node" && nodejs_ver=$(node --version 2>/dev/null || echo "Error")

    # Java
    local java_ver="Not Installed"
    check_dependency "java" && java_ver=$(java -version 2>&1 | head -n1 | cut -d'"' -f2)

    # Python
    local python_ver="Not Installed"
    check_dependency "python3" && python_ver=$(python3 --version 2>&1 | awk '{print $2}')

    info_row_status "Docker" "$docker_status" "🐳"
    info_row_status "Wings (Pterodactyl)" "$wings_status" "🪽"
    info_row "Node.js" "$nodejs_ver" "🟢"
    info_row "Java" "$java_ver" "☕"
    info_row "Python" "$python_ver" "🐍"

    echo ""
    print_thin_sep
    read -r -p "$(echo -e "  ${DIM}Press Enter to continue...${RESET}")"
}

# ─────────────────────────────────────────────────────────────────────────────
# VPS DASHBOARD (Real-time Snapshot)
# ─────────────────────────────────────────────────────────────────────────────
show_vps_dashboard() {
    print_header "VPS Dashboard"

    echo -e "  ${C1}${BOLD}◈  COMPUTE${RESET}"
    print_thin_sep

    local cpu_usage cpu_cores ram_total ram_used ram_pct swap_total swap_used swap_pct
    cpu_cores=$(nproc 2>/dev/null || echo "?")
    cpu_usage=$(get_cpu_usage)
    ram_total=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}')
    ram_used=$(free -h 2>/dev/null | awk '/^Mem:/{print $3}')
    ram_pct=$(free 2>/dev/null | awk '/^Mem:/{printf "%.1f%%", $3/$2*100}')
    swap_total=$(free -h 2>/dev/null | awk '/^Swap:/{print $2}')
    swap_used=$(free -h 2>/dev/null | awk '/^Swap:/{print $3}')
    swap_pct=$(free 2>/dev/null | awk '/^Swap:/{if($2>0) printf "%.1f%%", $3/$2*100; else print "0.0%"}')

    info_row "CPU Usage" "${cpu_usage}%  (${cpu_cores} cores)" "💻"
    info_row "RAM" "${ram_used} / ${ram_total} (${ram_pct})" "🧠"
    info_row "Swap" "${swap_used} / ${swap_total} (${swap_pct})" "🔄"

    echo ""

    local disk_used disk_total disk_pct uptime_str load_avg net_status
    disk_used=$(df -h / 2>/dev/null | awk 'NR==2{print $3}')
    disk_total=$(df -h / 2>/dev/null | awk 'NR==2{print $2}')
    disk_pct=$(df / 2>/dev/null | awk 'NR==2{print $5}')
    uptime_str=$(uptime -p 2>/dev/null || echo "unknown")
    load_avg=$(uptime 2>/dev/null | awk -F'load average:' '{print $2}' | xargs)
    net_status=$(ping -c1 -W2 8.8.8.8 &>/dev/null 2>&1 && echo "Connected" || echo "Disconnected")

    echo -e "  ${C3}${BOLD}◈  STORAGE & NETWORK${RESET}"
    print_thin_sep
    info_row "Disk" "${disk_used} / ${disk_total} (${disk_pct})" "💾"
    info_row "Uptime" "$uptime_str" "⏱️ "
    info_row "Load Average" "$load_avg" "📊"
    info_row_status "Network" "$net_status" "🌐"

    echo ""

    if check_dependency "systemctl"; then
        local svc_count
        svc_count=$(systemctl list-units --type=service --state=running --no-pager 2>/dev/null | grep -c ".service" || echo "?")
        echo -e "  ${C5}${BOLD}◈  SERVICES${RESET}"
        print_thin_sep
        info_row "Active Services" "$svc_count" "⚙️ "
        if check_dependency "docker"; then
            local docker_count
            docker_count=$(docker ps -q 2>/dev/null | wc -l)
            info_row "Running Containers" "$docker_count" "🐳"
        fi
        if [[ -f "/usr/local/bin/wings" ]] || [[ -f "/usr/bin/wings" ]]; then
            info_row_status "Wings" "$(get_service_status wings)" "🪽"
        fi
    fi

    echo ""
    print_thin_sep
    read -r -p "$(echo -e "  ${DIM}Press Enter to continue...${RESET}")"
}

# ─────────────────────────────────────────────────────────────────────────────
# VPS LIVE MONITOR
# ─────────────────────────────────────────────────────────────────────────────
show_vps_monitor() {
    echo -e "\n  ${YELLOW}${BOLD}Live monitor — press Ctrl+C to stop${RESET}\n"
    sleep 1

    while true; do
        clear
        print_header "VPS Live Monitor"
        echo -e "  ${DIM}Refreshing every 2s — Ctrl+C to exit${RESET}\n"

        # CPU
        local cpu_usage
        cpu_usage=$(top -bn1 2>/dev/null | grep "Cpu(s)" | awk '{print $2}' | tr -d '%us,' || echo "?")
        info_row "CPU Usage" "${cpu_usage}%" "💻"

        # RAM
        local ram_used ram_total
        ram_used=$(free -h 2>/dev/null | awk '/^Mem:/{print $3}')
        ram_total=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}')
        info_row "RAM" "${ram_used} / ${ram_total}" "🧠"

        # Disk
        local disk_used disk_total disk_pct
        disk_used=$(df -h / 2>/dev/null | awk 'NR==2{print $3}')
        disk_total=$(df -h / 2>/dev/null | awk 'NR==2{print $2}')
        disk_pct=$(df / 2>/dev/null | awk 'NR==2{print $5}')
        info_row "Disk" "${disk_used} / ${disk_total} (${disk_pct})" "💾"

        # Load Average
        local load_avg
        load_avg=$(uptime 2>/dev/null | awk -F'load average:' '{print $2}' | xargs)
        info_row "Load Average" "$load_avg" "📊"

        echo ""
        
