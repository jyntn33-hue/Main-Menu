#!/bin/bash

set -euo pipefail

# Global variables
LOG_FILE="/tmp/pratik_extras.log"
PASSWORD_FILE="/tmp/.pratik_extras_password"
LOCKOUT_FILE="/tmp/.pratik_extras_lockout"
FAILED_ATTEMPTS_FILE="/tmp/.failed_attempts"
SESSION_FILE="/tmp/.pratik_session"
BACKUP_DIR="/tmp/backups"

# Color definitions
PINK='\033[38;5;205m'
PURPLE='\033[38;5;93m'
CYAN='\033[38;5;87m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Logging function
log_action() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$LOG_FILE"
}

# Print colored text with box drawing characters
print_box() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Print dashboard header
print_dashboard_header() {
    clear
    echo -e "${PINK}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${PINK}║           PRATIK EXTRAS V10 ULTRA           ║${NC}"
    echo -e "${PINK}║      Professional VPS Management Suite      ║${NC}"
    echo -e "${PINK}╚══════════════════════════════════════════════╝${NC}"
    echo
}

# Print colored text
print_color() {
    local color=$1    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

# Authentication system
authenticate() {
    if [[ -f "$LOCKOUT_FILE" ]]; then
        local lockout_time=$(stat -c %Y "$LOCKOUT_FILE")
        local current_time=$(date +%s)
        local time_diff=$((current_time - lockout_time))
        
        if [[ $time_diff -lt 300 ]]; then # 5 minute lockout
            print_color $RED "Account locked due to too many failed attempts. Try again later."
            exit 1
        else
            rm -f "$LOCKOUT_FILE" "$FAILED_ATTEMPTS_FILE"
        fi
    fi

    if [[ ! -f "$PASSWORD_FILE" ]]; then
        print_color $YELLOW "Set up your password:"
        read -s -p "Enter new password: " password
        echo
        read -s -p "Confirm password: " confirm_password
        echo
        
        if [[ "$password" != "$confirm_password" ]]; then
            print_color $RED "Passwords do not match!"
            exit 1
        fi
        
        echo -n "$password" | sha256sum | cut -d' ' -f1 > "$PASSWORD_FILE"
        print_color $GREEN "Password set successfully!"
    fi

    local max_attempts=3
    local attempts=0
    
    while [[ $attempts -lt $max_attempts ]]; do
        read -s -p "Enter password: " input_password
        echo        local hashed_input=$(echo -n "$input_password" | sha256sum | cut -d' ' -f1)
        local stored_hash=$(cat "$PASSWORD_FILE")
        
        if [[ "$hashed_input" == "$stored_hash" ]]; then
            print_color $GREEN "Authentication successful!"
            touch "$SESSION_FILE"
            log_action "User authenticated successfully"
            return 0
        else
            ((attempts++))
            print_color $RED "Incorrect password. Attempts remaining: $((max_attempts - attempts))"
            log_action "Failed authentication attempt ($attempts/$max_attempts)"
            
            if [[ $attempts -ge $max_attempts ]]; then
                print_color $RED "Too many failed attempts. Account locked for 5 minutes."
                touch "$LOCKOUT_FILE"
                exit 1
            fi
        fi
    done
}

# Dependency check
check_dependency() {
    local cmd=$1
    if ! command -v "$cmd" &> /dev/null; then
        print_color $RED "Required dependency '$cmd' is not installed."
        return 1
    fi
    return 0
}

# Animated loading bar
show_loading() {
    local duration=${1:-3}
    local msg=${2:-"Loading"}
    
    echo -ne "${msg}: ["
    local dots=0
    for ((i=0; i<duration*10; i++)); do
        case $dots in
            0) echo -ne "${CYAN}.${NC}";;
            1) echo -ne "${PURPLE}o${NC}";;
            2) echo -ne "${PINK}*${NC}";;
        esac
        dots=$(( (dots + 1) % 3 ))
        sleep 0.1
        echo -ne "\b\b\b   \b\b\b["
        for ((j=0; j<i; j++)); do
            echo -ne "="        done
        for ((j=i; j<duration*10-1; j++)); do
            echo -ne " "
        done
        echo -ne "]"
    done
    echo -ne "\b]"
    for ((i=0; i<duration*10; i++)); do
        echo -ne "="
    done
    echo "] 100%"
}

# Detect environment
detect_environment() {
    if [ -f /.dockerenv ]; then
        echo "Docker Container"
    elif [[ -n "${CODESPACES:-}" ]]; then
        echo "GitHub Codespace"
    elif [ -d "/run/systemd/system" ]; then
        echo "Standard VPS"
    else
        echo "Unknown Environment"
    fi
}

# Main dashboard
show_dashboard() {
    print_dashboard_header
    
    echo -e "${PURPLE}┌─────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│                    SYSTEM INFO              │${NC}"
    echo -e "${PURPLE}└─────────────────────────────────────────────┘${NC}"
    
    # OS Information
    local os_name=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
    local kernel_version=$(uname -r)
    local cpu_cores=$(nproc)
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local ram_total=$(free -h | awk '/^Mem:/ {print $2}')
    local ram_used=$(free -h | awk '/^Mem:/ {print $3}')
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}')
    local public_ip=$(curl -s https://api.ipify.org 2>/dev/null || echo "N/A")
    local local_ip=$(hostname -I | awk '{print $1}')
    local uptime=$(uptime -p)
    
    echo -e "${CYAN}OS Name:${NC}        $os_name"
    echo -e "${CYAN}Kernel Version:${NC} $kernel_version"
    echo -e "${CYAN}CPU Cores:${NC}      $cpu_cores"
    echo -e "${CYAN}CPU Usage:${NC}      ${cpu_usage}%"    echo -e "${CYAN}RAM Total:${NC}      $ram_total"
    echo -e "${CYAN}RAM Used:${NC}       $ram_used"
    echo -e "${CYAN}Disk Usage:${NC}     $disk_usage"
    echo -e "${CYAN}Public IP:${NC}      $public_ip"
    echo -e "${CYAN}Local IP:${NC}       $local_ip"
    echo -e "${CYAN}Uptime:${NC}         $uptime"
    echo
    
    echo -e "${PURPLE}┌─────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│                   SERVICES                  │${NC}"
    echo -e "${PURPLE}└─────────────────────────────────────────────┘${NC}"
    
    # Service checks
    local docker_status="Not Installed"
    if check_dependency "docker"; then
        if docker info &>/dev/null; then
            docker_status="Active"
        else
            docker_status="Inactive"
        fi
    fi
    
    local wings_status="Not Installed"
    if [[ -f "/usr/local/bin/wings" ]] || [[ -f "/usr/bin/wings" ]]; then
        if check_dependency "systemctl"; then
            if systemctl is-active --quiet wings; then
                wings_status="Active"
            else
                wings_status="Inactive"
            fi
        else
            wings_status="Unknown"
        fi
    fi
    
    local nodejs_version="Not Installed"
    if check_dependency "node"; then
        nodejs_version=$(node --version 2>/dev/null || echo "Error")
    fi
    
    local java_version="Not Installed"
    if check_dependency "java"; then
        java_version=$(java -version 2>&1 | head -n1 | cut -d'"' -f2)
    fi
    
    echo -e "${CYAN}Docker Status:${NC}    $docker_status"
    echo -e "${CYAN}Wings Status:${NC}     $wings_status"
    echo -e "${CYAN}Node.js Version:${NC}  $nodejs_version"
    echo -e "${CYAN}Java Version:${NC}     $java_version"
    echo    
    echo -e "${PURPLE}┌─────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│                 ENVIRONMENT                 │${NC}"
    echo -e "${PURPLE}└─────────────────────────────────────────────┘${NC}"
    
    local env_type=$(detect_environment)
    echo -e "${CYAN}Current Environment:${NC} $env_type"
    
    read -p "Press Enter to continue..."
}

# VPS Dashboard Module
show_vps_dashboard() {
    print_dashboard_header
    print_color $PURPLE "=== VPS Dashboard ==="
    
    # CPU Usage
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local cpu_cores=$(nproc)
    print_color $CYAN "CPU Usage: ${cpu_usage}% (Cores: $cpu_cores)"
    
    # RAM Usage
    local ram_total=$(free -h | awk '/^Mem:/ {print $2}')
    local ram_used=$(free -h | awk '/^Mem:/ {print $3}')
    local ram_percent=$(free | awk '/^Mem:/ {printf("%.2f%%", $3/$2 * 100.0)}')
    print_color $CYAN "RAM Usage: $ram_used / $ram_total ($ram_percent)"
    
    # Disk Usage
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}')
    local disk_total=$(df -h / | awk 'NR==2 {print $2}')
    local disk_used=$(df -h / | awk 'NR==2 {print $3}')
    print_color $CYAN "Disk Usage: $disk_used / $disk_total ($disk_usage)"
    
    # Swap Usage
    local swap_total=$(free -h | awk '/^Swap:/ {print $2}')
    local swap_used=$(free -h | awk '/^Swap:/ {print $3}')
    local swap_percent=$(free | awk '/^Swap:/ {if($2>0) printf("%.2f%%", $3/$2 * 100.0); else print "0.00%"}')
    print_color $CYAN "Swap Usage: $swap_used / $swap_total ($swap_percent)"
    
    # Uptime
    local uptime=$(uptime -p)
    print_color $CYAN "Uptime: $uptime"
    
    # Load Average
    local load_avg=$(uptime | awk -F'load average:' '{print $2}')
    print_color $CYAN "Load Average:$load_avg"
    
    # Network Speed (simple check)
    local network_check=$(ping -c 1 google.com &>/dev/null && echo "Connected" || echo "Disconnected")
    print_color $CYAN "Network Status: $network_check"    
    # Running Services
    print_color $CYAN "Running Services:"
    if check_dependency "systemctl"; then
        systemctl list-units --type=service --state=running --no-pager | wc -l | xargs -I {} echo "  Active Services: {}"
    fi
    
    # Docker Status
    if check_dependency "docker"; then
        local docker_running=$(docker ps --format "table {{.Names}}" | wc -l)
        print_color $CYAN "Docker Containers Running: $((docker_running - 1))"
    fi
    
    # Wings Status
    if [[ -f "/usr/local/bin/wings" ]] || [[ -f "/usr/bin/wings" ]]; then
        if check_dependency "systemctl"; then
            local wings_state=$(systemctl is-active wings 2>/dev/null || echo "unknown")
            print_color $CYAN "Wings Service: $wings_state"
        fi
    fi
    
    read -p "Press Enter to continue..."
}

# VPS Monitor Module
show_vps_monitor() {
    print_dashboard_header
    print_color $PURPLE "=== VPS Monitor ==="
    
    while true; do
        clear
        print_dashboard_header
        print_color $PURPLE "=== VPS Live Monitor (Press Ctrl+C to exit) ==="
        
        # Live CPU Monitor
        print_color $CYAN "CPU Usage:"
        top -bn1 | grep "Cpu(s)" | awk '{print $2 "%"}'
        
        # Live RAM Monitor
        print_color $CYAN "RAM Usage:"
        free -h | awk '/^Mem:/ {print $3 "/" $2 " (" $3/$2*100 "%)"}'
        
        # Live Disk Monitor
        print_color $CYAN "Disk Usage:"
        df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}'
        
        # Network Monitor
        print_color $CYAN "Network Info:"
        ss -tuln | head -10
                # Top Processes by CPU
        print_color $CYAN "Top 5 Processes by CPU:"
        ps aux --sort=-%cpu | head -n 6
        
        # Top Processes by RAM
        print_color $CYAN "Top 5 Processes by RAM:"
        ps aux --sort=-%mem | head -n 6
        
        sleep 2
    done
}

# Pterodactyl Tools Module
show_pterodactyl_menu() {
    while true; do
        clear
        print_dashboard_header
        print_color $PURPLE "=== Pterodactyl Tools ==="
        print_color $CYAN "1. Wings Status"
        print_color $CYAN "2. Start Wings"
        print_color $CYAN "3. Stop Wings"
        print_color $CYAN "4. Restart Wings"
        print_color $CYAN "5. Wings Logs"
        print_color $CYAN "6. Install Wings"
        print_color $CYAN "7. Update Wings"
        print_color $CYAN "8. Docker Check"
        print_color $CYAN "9. Java Check"
        print_color $CYAN "10. Node Resource Check"
        print_color $CYAN "11. Back to Main Menu"
        print_color $PURPLE "========================"
        
        read -p "Select option: " sub_choice
        
        case $sub_choice in
            1)
                if check_dependency "systemctl"; then
                    systemctl status wings
                else
                    print_color $RED "systemctl not available"
                fi
                ;;
            2)
                if check_dependency "systemctl"; then
                    sudo systemctl start wings
                    log_action "Started Wings service"
                    print_color $GREEN "Wings service started"
                else
                    print_color $RED "systemctl not available"
                fi
                ;;            3)
                if check_dependency "systemctl"; then
                    sudo systemctl stop wings
                    log_action "Stopped Wings service"
                    print_color $GREEN "Wings service stopped"
                else
                    print_color $RED "systemctl not available"
                fi
                ;;
            4)
                if check_dependency "systemctl"; then
                    sudo systemctl restart wings
                    log_action "Restarted Wings service"
                    print_color $GREEN "Wings service restarted"
                else
                    print_color $RED "systemctl not available"
                fi
                ;;
            5)
                if check_dependency "journalctl"; then
                    journalctl -u wings -f
                else
                    print_color $RED "journalctl not available"
                fi
                ;;
            6)
                if ! check_dependency "docker"; then
                    print_color $RED "Docker is required for Wings installation"
                    break
                fi
                
                if [[ -f "/usr/local/bin/wings" ]] || [[ -f "/usr/bin/wings" ]]; then
                    print_color $YELLOW "Wings is already installed"
                    break
                fi
                
                print_color $YELLOW "Installing Wings..."
                curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
                chmod +x /usr/local/bin/wings
                log_action "Installed Wings"
                print_color $GREEN "Wings installed successfully"
                ;;
            7)
                print_color $YELLOW "Updating Wings..."
                curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
                chmod +x /usr/local/bin/wings
                log_action "Updated Wings"
                print_color $GREEN "Wings updated successfully"
                ;;
            8)                if check_dependency "docker"; then
                    docker version
                    print_color $GREEN "Docker is available"
                else
                    print_color $RED "Docker is not installed"
                fi
                ;;
            9)
                if check_dependency "java"; then
                    java -version
                    print_color $GREEN "Java is available"
                else
                    print_color $RED "Java is not installed"
                fi
                ;;
            10)
                print_color $CYAN "Node Resource Check:"
                if check_dependency "docker"; then
                    print_color $GREEN "Docker: Available"
                else
                    print_color $RED "Docker: Not Available"
                fi
                
                if check_dependency "java"; then
                    print_color $GREEN "Java: Available"
                else
                    print_color $RED "Java: Not Available"
                fi
                
                if check_dependency "node"; then
                    print_color $GREEN "Node.js: Available"
                else
                    print_color $RED "Node.js: Not Available"
                fi
                ;;
            11)
                break
                ;;
            *)
                print_color $RED "Invalid option"
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

# Docker Manager Module
show_docker_menu() {
    while true; do        clear
        print_dashboard_header
        print_color $PURPLE "=== Docker Manager ==="
        print_color $CYAN "1. List Containers"
        print_color $CYAN "2. Start Container"
        print_color $CYAN "3. Stop Container"
        print_color $CYAN "4. Restart Container"
        print_color $CYAN "5. Remove Container"
        print_color $CYAN "6. View Logs"
        print_color $CYAN "7. Docker Images"
        print_color $CYAN "8. Docker Volumes"
        print_color $CYAN "9. Docker Networks"
        print_color $CYAN "10. Docker System Prune"
        print_color $CYAN "11. Back to Main Menu"
        print_color $PURPLE "========================"
        
        read -p "Select option: " sub_choice
        
        case $sub_choice in
            1)
                if ! check_dependency "docker"; then
                    print_color $RED "Docker is not installed or not in PATH"
                    break
                fi
                print_color $BLUE "=== Docker Containers ==="
                docker ps -a
                ;;
            2)
                if ! check_dependency "docker"; then
                    print_color $RED "Docker is not installed or not in PATH"
                    break
                fi
                print_color $YELLOW "Enter container name:"
                read container_name
                docker start "$container_name"
                log_action "Started Docker container: $container_name"
                print_color $GREEN "Container $container_name started"
                ;;
            3)
                if ! check_dependency "docker"; then
                    print_color $RED "Docker is not installed or not in PATH"
                    break
                fi
                print_color $YELLOW "Enter container name:"
                read container_name
                docker stop "$container_name"
                log_action "Stopped Docker container: $container_name"
                print_color $GREEN "Container $container_name stopped"
                ;;
            4)                if ! check_dependency "docker"; then
                    print_color $RED "Docker is not installed or not in PATH"
                    break
                fi
                print_color $YELLOW "Enter container name:"
                read container_name
                docker restart "$container_name"
                log_action "Restarted Docker container: $container_name"
                print_color $GREEN "Container $container_name restarted"
                ;;
            5)
                if ! check_dependency "docker"; then
                    print_color $RED "Docker is not installed or not in PATH"
                    break
                fi
                print_color $YELLOW "Enter container name:"
                read container_name
                print_color $RED "Are you sure you want to remove container $container_name? (y/N):"
                read confirm
                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    docker rm "$container_name"
                    log_action "Removed Docker container: $container_name"
                    print_color $GREEN "Container $container_name removed"
                else
                    print_color $YELLOW "Operation cancelled"
                fi
                ;;
            6)
                if ! check_dependency 
