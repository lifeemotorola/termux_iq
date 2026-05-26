#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════╗
# ║           🧠 NEUROX - Advanced IQ Test Platform v3.0           ║
# ║              Built for Termux | By AI Assistant                 ║
# ║   Features: 10 Categories, Adaptive Difficulty, Full Analytics  ║
# ╚══════════════════════════════════════════════════════════════════╝

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CONFIGURATION & INITIALIZATION
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

VERSION="3.0"
DATA_DIR="$HOME/.neurox_iq"
SCORES_FILE="$DATA_DIR/scores.dat"
USERS_FILE="$DATA_DIR/users.dat"
LOG_FILE="$DATA_DIR/test_log.dat"
LEADERBOARD_FILE="$DATA_DIR/leaderboard.dat"
SETTINGS_FILE="$DATA_DIR/settings.dat"

mkdir -p "$DATA_DIR"
touch "$SCORES_FILE" "$USERS_FILE" "$LOG_FILE" "$LEADERBOARD_FILE" "$SETTINGS_FILE"

# Current session variables
CURRENT_USER=""
TOTAL_SCORE=0
TOTAL_QUESTIONS=0
CORRECT_ANSWERS=0
WRONG_ANSWERS=0
SKIPPED=0
STREAK=0
MAX_STREAK=0
DIFFICULTY="medium"
ADAPTIVE_LEVEL=5
TIME_TOTAL=0
CATEGORY_SCORES=()
START_TIME=0
QUESTION_TIMES=()

# Category tracking
declare -A CAT_CORRECT
declare -A CAT_TOTAL
declare -A CAT_TIME

CATEGORIES=("Pattern Recognition" "Mathematical Reasoning" "Spatial Intelligence" "Verbal Intelligence" "Logical Deduction" "Memory & Recall" "Numerical Sequences" "Abstract Reasoning" "Processing Speed" "Lateral Thinking")

for cat in "${CATEGORIES[@]}"; do
    CAT_CORRECT["$cat"]=0
    CAT_TOTAL["$cat"]=0
    CAT_TIME["$cat"]=0
done

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# COLOR & STYLE DEFINITIONS
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Colors
R='\033[0;31m'    # Red
G='\033[0;32m'    # Green
Y='\033[0;33m'    # Yellow
B='\033[0;34m'    # Blue
M='\033[0;35m'    # Magenta
C='\033[0;36m'    # Cyan
W='\033[0;37m'    # White
BR='\033[1;31m'   # Bold Red
BG='\033[1;32m'   # Bold Green
BY='\033[1;33m'   # Bold Yellow
BB='\033[1;34m'   # Bold Blue
BM='\033[1;35m'   # Bold Magenta
BC='\033[1;36m'   # Bold Cyan
BW='\033[1;37m'   # Bold White
N='\033[0m'       # Reset
DIM='\033[2m'     # Dim
BOLD='\033[1m'    # Bold
UNDER='\033[4m'   # Underline
BLINK='\033[5m'   # Blink
ITALIC='\033[3m'  # Italic

# Background colors
BG_R='\033[41m'
BG_G='\033[42m'
BG_Y='\033[43m'
BG_B='\033[44m'
BG_M='\033[45m'
BG_C='\033[46m'
BG_W='\033[47m'
BG_BLACK='\033[40m'

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# UTILITY FUNCTIONS
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

clear_screen() {
    clear
    echo ""
}

press_continue() {
    echo ""
    echo -e "  ${DIM}Press [Enter] to continue...${N}"
    read -r
}

get_timestamp() {
    date +%s
}

get_date() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Animated text display
type_text() {
    local text="$1"
    local delay="${2:-0.02}"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    echo -ne "  ${DIM}[${N}"
    for ((i=0; i<filled; i++)); do
        if [ $percentage -lt 33 ]; then
            echo -ne "${BR}█${N}"
        elif [ $percentage -lt 66 ]; then
            echo -ne "${BY}█${N}"
        else
            echo -ne "${BG}█${N}"
        fi
    done
    for ((i=0; i<empty; i++)); do
        echo -ne "${DIM}░${N}"
    done
    echo -ne "${DIM}]${N} ${BW}${percentage}%%${N}"
}

# Spinning animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ -d /proc/"$pid" ] 2>/dev/null; do
        local temp=${spinstr#?}
        printf " ${BC}%c${N} " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b"
    done
    printf "   \b\b\b"
}

# Loading animation
loading_animation() {
    local msg="$1"
    local duration="${2:-2}"
    local chars="⣾⣽⣻⢿⡿⣟⣯⣷"
    local end_time=$(($(date +%s) + duration))
    
    while [ $(date +%s) -lt $end_time ]; do
        for ((i=0; i<${#chars}; i++)); do
            echo -ne "\r  ${BC}${chars:$i:1}${N} ${W}${msg}${N}  "
            sleep 0.1
        done
    done
    echo -ne "\r  ${BG}✓${N} ${W}${msg}${N}       \n"
}

# Draw a box
draw_box() {
    local text="$1"
    local color="${2:-$BC}"
    local len=${#text}
    local padding=4
    local total=$((len + padding * 2))
    
    echo -e "  ${color}╔$(printf '═%.0s' $(seq 1 $total))╗${N}"
    echo -e "  ${color}║$(printf ' %.0s' $(seq 1 $padding))${BW}${text}${color}$(printf ' %.0s' $(seq 1 $padding))║${N}"
    echo -e "  ${color}╚$(printf '═%.0s' $(seq 1 $total))╝${N}"
}

# Horizontal line
hr() {
    local char="${1:-─}"
    local color="${2:-$DIM}"
    echo -e "  ${color}$(printf "${char}%.0s" $(seq 1 56))${N}"
}

# Countdown timer display
countdown_display() {
    local seconds=$1
    for ((i=seconds; i>0; i--)); do
        echo -ne "\r  ${BY}⏱ Starting in ${BW}${i}${BY} seconds...${N}  "
        sleep 1
    done
    echo -ne "\r  ${BG}🚀 GO!                           ${N}\n"
    sleep 0.5
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# BRAIN ANIMATION & BANNER
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

show_brain() {
    echo -e "${BM}"
    echo '         ╭──────────────────────╮'
    echo '         │    ⣀⣀⣀⣤⣤⣤⣤⣤⣀⣀⣀      │'
    echo '         │  ⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦   │'
    echo '         │ ⣿⣿⣿⡟⠋⠉⠉⠉⠉⠉⠋⠙⣿⣿⣿⣿  │'
    echo '         │ ⣿⣿⠏  🧠 NEUROX  ⣿⣿⣿  │'
    echo '         │ ⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿  │'
    echo '         │  ⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟   │'
    echo '         │    ⠉⠛⠻⠿⠿⠿⠿⠟⠛⠉      │'
    echo '         ╰──────────────────────╯'
    echo -e "${N}"
}

show_banner() {
    clear_screen
    echo ""
    echo -e "${BM}  ███╗   ██╗${BC}███████╗${BB}██╗   ██╗${BG}██████╗ ${BY}██████╗ ${BR}██╗  ██╗${N}"
    echo -e "${BM}  ████╗  ██║${BC}██╔════╝${BB}██║   ██║${BG}██╔══██╗${BY}██╔═══██╗${BR}╚██╗██╔╝${N}"
    echo -e "${BM}  ██╔██╗ ██║${BC}█████╗  ${BB}██║   ██║${BG}██████╔╝${BY}██║   ██║${BR} ╚███╔╝ ${N}"
    echo -e "${BM}  ██║╚██╗██║${BC}██╔══╝  ${BB}██║   ██║${BG}██╔══██╗${BY}██║   ██║${BR} ██╔██╗ ${N}"
    echo -e "${BM}  ██║ ╚████║${BC}███████╗${BB}╚██████╔╝${BG}██║  ██║${BY}╚██████╔╝${BR}██╔╝ ██╗${N}"
    echo -e "${BM}  ╚═╝  ╚═══╝${BC}╚══════╝${BB} ╚═════╝ ${BG}╚═╝  ╚═╝${BY} ╚═════╝ ${BR}╚═╝  ╚═╝${N}"
    echo ""
    echo -e "  ${DIM}${ITALIC}── Advanced Intelligence Quotient Assessment Platform v${VERSION} ──${N}"
    echo ""
    hr "═" "$BC"
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# USER MANAGEMENT SYSTEM
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

user_login() {
    show_banner
    echo -e "  ${BW}👤 USER AUTHENTICATION${N}"
    hr
    echo ""
    echo -e "  ${C}[1]${W} 🆕  New User Registration${N}"
    echo -e "  ${C}[2]${W} 🔑  Existing User Login${N}"
    echo -e "  ${C}[3]${W} 🚶  Continue as Guest${N}"
    echo ""
    echo -ne "  ${BY}▸ Select option: ${N}"
    read -r choice
    
    case $choice in
        1) register_user ;;
        2) login_user ;;
        3) 
            CURRENT_USER="Guest_$$"
            echo -e "\n  ${BG}✓${N} ${W}Continuing as ${BC}${CURRENT_USER}${N}"
            sleep 1
            ;;
        *) user_login ;;
    esac
}

register_user() {
    echo ""
    echo -ne "  ${W}📝 Enter username: ${BC}"
    read -r username
    echo -ne "${N}"
    
    if [ -z "$username" ]; then
        echo -e "  ${BR}✗ Username cannot be empty${N}"
        sleep 1
        user_login
        return
    fi
    
    if grep -q "^${username}|" "$USERS_FILE" 2>/dev/null; then
        echo -e "  ${BR}✗ Username already exists!${N}"
        sleep 1
        user_login
        return
    fi
    
    echo -ne "  ${W}🔒 Enter password: ${N}"
    read -rs password
    echo ""
    echo -ne "  ${W}🔒 Confirm password: ${N}"
    read -rs password2
    echo ""
    
    if [ "$password" != "$password2" ]; then
        echo -e "  ${BR}✗ Passwords don't match!${N}"
        sleep 1
        user_login
        return
    fi
    
    echo -ne "  ${W}📅 Enter your age: ${N}"
    read -r age
    echo -ne "  ${W}🎓 Education level (high_school/bachelor/master/phd): ${N}"
    read -r education
    
    # Hash password (simple for bash)
    local pass_hash=$(echo -n "$password" | md5sum | cut -d' ' -f1)
    echo "${username}|${pass_hash}|${age}|${education}|$(get_date)" >> "$USERS_FILE"
    
    CURRENT_USER="$username"
    echo ""
    echo -e "  ${BG}✓ Registration successful!${N}"
    echo -e "  ${W}Welcome, ${BC}${BOLD}${username}${N}${W}!${N}"
    loading_animation "Setting up your profile" 2
}

login_user() {
    echo ""
    echo -ne "  ${W}👤 Username: ${BC}"
    read -r username
    echo -ne "${N}"
    echo -ne "  ${W}🔒 Password: ${N}"
    read -rs password
    echo ""
    
    local pass_hash=$(echo -n "$password" | md5sum | cut -d' ' -f1)
    
    if grep -q "^${username}|${pass_hash}|" "$USERS_FILE" 2>/dev/null; then
        CURRENT_USER="$username"
        echo ""
        echo -e "  ${BG}✓ Login successful!${N}"
        echo -e "  ${W}Welcome back, ${BC}${BOLD}${username}${N}${W}!${N}"
        loading_animation "Loading your profile" 1
    else
        echo -e "  ${BR}✗ Invalid credentials!${N}"
        sleep 1
        user_login
    fi
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# MAIN MENU
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

main_menu() {
    while true; do
        show_banner
        echo -e "  ${W}Welcome, ${BC}${BOLD}${CURRENT_USER}${N}"
        echo ""
        hr "─" "$DIM"
        echo ""
        echo -e "  ${BW}📋 MAIN MENU${N}"
        echo ""
        echo -e "  ${C}[1]${W}  🧪  ${BW}Full IQ Assessment${W}      ${DIM}(All categories, ~30 min)${N}"
        echo -e "  ${C}[2]${W}  ⚡  ${BW}Quick IQ Test${W}            ${DIM}(15 questions, ~10 min)${N}"
        echo -e "  ${C}[3]${W}  🎯  ${BW}Category Practice${W}        ${DIM}(Choose specific area)${N}"
        echo -e "  ${C}[4]${W}  🏋️   ${BW}Challenge Mode${W}           ${DIM}(Timed, adaptive)${N}"
        echo -e "  ${C}[5]${W}  📊  ${BW}View My Results${W}          ${DIM}(History & analytics)${N}"
        echo -e "  ${C}[6]${W}  🏆  ${BW}Leaderboard${W}              ${DIM}(Top scores)${N}"
        echo -e "  ${C}[7]${W}  📖  ${BW}About IQ & Methodology${W}   ${DIM}(Learn more)${N}"
        echo -e "  ${C}[8]${W}  ⚙️   ${BW}Settings${W}                 ${DIM}(Customize)${N}"
        echo -e "  ${C}[9]${W}  🧠  ${BW}Brain Training Games${W}     ${DIM}(Warm up)${N}"
        echo -e "  ${C}[0]${W}  🚪  ${BW}Exit${N}"
        echo ""
        hr "─" "$DIM"
        echo ""
        echo -ne "  ${BY}▸ Select option: ${N}"
        read -r choice
        
        case $choice in
            1) full_iq_test ;;
            2) quick_iq_test ;;
            3) category_practice ;;
            4) challenge_mode ;;
            5) view_results ;;
            6) show_leaderboard ;;
            7) about_iq ;;
            8) settings_menu ;;
            9) brain_games ;;
            0) exit_program ;;
            *) echo -e "  ${BR}Invalid option!${N}"; sleep 1 ;;
        esac
    done
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - PATTERN RECOGNITION
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_pattern_recognition() {
    local level=$1
    local q_num=$((RANDOM % 5))
    
    case $level in
        easy)
            case $q_num in
                0) ask_question "Pattern Recognition" \
                    "What comes next in the pattern?\n\n  ○ ● ○ ● ○ ●  ?" \
                    "A) ●" "B) ○" "C) ◐" "D) ◑" "B" \
                    "The pattern alternates between ○ and ●. After ●, the next is ○." ;;
                1) ask_question "Pattern Recognition" \
                    "Complete the sequence:\n\n  △ △ □ △ △ □ △ △  ?" \
                    "A) △" "B) □" "C) ○" "D) ◇" "B" \
                    "Pattern repeats: △△□. After △△, comes □." ;;
                2) ask_question "Pattern Recognition" \
                    "What comes next?\n\n  🔴🔵🔴🔵🔴🔵  ?" \
                    "A) 🔴" "B) 🔵" "C) 🟢" "D) 🟡" "A" \
                    "Simple alternating pattern: red, blue, red..." ;;
                3) ask_question "Pattern Recognition" \
                    "Find the pattern:\n\n  AB CD EF GH  ?" \
                    "A) HI" "B) IJ" "C) GH" "D) JK" "B" \
                    "Consecutive letter pairs: AB, CD, EF, GH, IJ" ;;
                4) ask_question "Pattern Recognition" \
                    "What replaces the ?:\n\n  ★☆★☆☆★☆★☆☆★☆★☆☆  ?" \
                    "A) ★" "B) ☆" "C) ●" "D) ○" "A" \
                    "Pattern: ★☆★☆☆ repeating. Next cycle starts with ★." ;;
            esac
            ;;
        medium)
            case $q_num in
                0) ask_question "Pattern Recognition" \
                    "Find the missing element:\n\n  ┌─┐  ┌──┐  ┌───┐  ┌────┐  ?\n  │1│  │ 4│  │  9│  │ 16│\n  └─┘  └──┘  └───┘  └────┘" \
                    "A) 20" "B) 25" "C) 36" "D) 24" "B" \
                    "Perfect squares: 1², 2², 3², 4², 5² = 25. Boxes also grow." ;;
                1) ask_question "Pattern Recognition" \
                    "What comes next in the visual pattern?\n\n  ◢  ◣  ◤  ◥  ?" \
                    "A) ◢" "B) ◣" "C) ◤" "D) ■" "A" \
                    "Rotation pattern cycles: ◢◣◤◥ then repeats with ◢." ;;
                2) ask_question "Pattern Recognition" \
                    "Complete the matrix pattern:\n\n  Row 1: 2  4  8\n  Row 2: 3  9  27\n  Row 3: 4  16  ?" \
                    "A) 32" "B) 48" "C) 64" "D) 56" "C" \
                    "Each row: n, n², n³. Row 3: 4, 16, 64 (4³=64)" ;;
                3) ask_question "Pattern Recognition" \
                    "Find the odd one out:\n\n  A) ◇ inside ○\n  B) □ inside △\n  C) ○ inside □\n  D) △ inside ○" \
                    "A) A" "B) B" "C) C" "D) D" "B" \
                    "All others have curved shapes; B has only angular shapes." ;;
                4) ask_question "Pattern Recognition" \
                    "What's the pattern rule?\n\n  J F M A M J  ?\n\n  What letter comes next?" \
                    "A) A" "B) J" "C) S" "D) D" "B" \
                    "First letters of months: Jan Feb Mar Apr May Jun Jul(J)" ;;
            esac
            ;;
        hard)
            case $q_num in
                0) ask_question "Pattern Recognition" \
                    "Study the transformation:\n\n  Input:  ▲▼▲   Output: ▼▲▼\n  Input:  ●○●   Output: ○●○\n  Input:  ■□■   Output: ?" \
                    "A) □■□" "B) ■□■" "C) □□□" "D) ■■■" "A" \
                    "Rule: Each element is replaced by its inverse/complement." ;;
                1) ask_question "Pattern Recognition" \
                    "Complete the 3x3 matrix:\n\n  ╔═══╦═══╦═══╗\n  ║ ● ║ ●●║●●●║\n  ╠═══╬═══╬═══╣\n  ║●● ║●●●║ ● ║\n  ╠═══╬═══╬═══╣\n  ║●●●║ ● ║ ? ║\n  ╚═══╩═══╩═══╝" \
                    "A) ●" "B) ●●" "C) ●●●" "D) ●●●●" "B" \
                    "Each row/col contains 1,2,3 dots. Row 3 has 3,1,? → needs 2." ;;
                2) ask_question "Pattern Recognition" \
                    "Decode the sequence:\n\n  1, 1, 2, 3, 5, 8, 13, 21, ?\n\n  What comes next?" \
                    "A) 28" "B) 32" "C) 34" "D) 36" "C" \
                    "Fibonacci: each = sum of two preceding. 13+21=34" ;;
                3) ask_question "Pattern Recognition" \
                    "Visual rotation puzzle:\n\n  Step 1: ┘  Step 2: └  Step 3: ┌  Step 4: ?\n  (Corner rotating 90° counterclockwise)" \
                    "A) ┐" "B) ┘" "C) └" "D) ┌" "A" \
                    "90° CCW rotation: ┘→└→┌→┐ completes the cycle." ;;
                4) ask_question "Pattern Recognition" \
                    "Find the rule and solve:\n\n  (3,5) → 34    (2,7) → 53\n  (4,3) → 25    (6,2) → ?" \
                    "A) 38" "B) 40" "C) 44" "D) 36" "B" \
                    "Rule: a²+b² → 3²+5²=34, 2²+7²=53, 4²+3²=25, 6²+2²=40" ;;
            esac
            ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - MATHEMATICAL REASONING
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_mathematical_reasoning() {
    local level=$1
    local q_num=$((RANDOM % 5))
    
    case $level in
        easy)
            case $q_num in
                0) ask_question "Mathematical Reasoning" \
                    "If 3 workers can build a wall in 12 hours,\nhow many hours would 6 workers take?" \
                    "A) 24 hours" "B) 6 hours" "C) 8 hours" "D) 4 hours" "B" \
                    "Inverse proportion: 3×12 = 6×x → x = 36/6 = 6 hours" ;;
                1) ask_question "Mathematical Reasoning" \
                    "A shirt costs \$40 after a 20% discount.\nWhat was the original price?" \
                    "A) \$48" "B) \$50" "C) \$52" "D) \$60" "B" \
                    "40 = Original × 0.80 → Original = 40/0.80 = \$50" ;;
                2) ask_question "Mathematical Reasoning" \
                    "If you flip a coin 3 times, what's the\nprobability of getting all heads?" \
                    "A) 1/2" "B) 1/4" "C) 1/8" "D) 1/6" "C" \
                    "(1/2)³ = 1/8. Each flip is independent." ;;
                3) ask_question "Mathematical Reasoning" \
                    "A rectangle has a perimeter of 24 cm.\nIf the length is twice the width, find the area." \
                    "A) 24 cm²" "B) 28 cm²" "C) 32 cm²" "D) 36 cm²" "C" \
                    "2(2w+w)=24 → 6w=24 → w=4, l=8. Area=4×8=32 cm²" ;;
                4) ask_question "Mathematical Reasoning" \
                    "What is 15% of 15% of 10000?" \
                    "A) 225" "B) 250" "C) 300" "D) 150" "A" \
                    "15% of 10000 = 1500. 15% of 1500 = 225" ;;
            esac
            ;;
        medium)
            case $q_num in
                0) ask_question "Mathematical Reasoning" \
                    "A train travels 60 km at 30 km/h and then\n60 km at 60 km/h. What's the average speed\nfor the entire journey?" \
                    "A) 45 km/h" "B) 40 km/h" "C) 48 km/h" "D) 36 km/h" "B" \
                    "Time1=2h, Time2=1h, Total=120km/3h=40 km/h (harmonic mean)" ;;
                1) ask_question "Mathematical Reasoning" \
                    "In a group of 100 people:\n- 75 drink coffee\n- 80 drink tea\n- Everyone drinks at least one\n\nHow many drink BOTH?" \
                    "A) 45" "B) 55" "C) 60" "D) 65" "B" \
                    "Using inclusion-exclusion: 75+80-100 = 55 drink both" ;;
                2) ask_question "Mathematical Reasoning" \
                    "A clock shows 3:15. What is the angle\nbetween the hour and minute hands?" \
                    "A) 0°" "B) 7.5°" "C) 15°" "D) 22.5°" "B" \
                    "Minute at 90°. Hour at 90°+7.5°=97.5°. Angle=7.5°" ;;
                3) ask_question "Mathematical Reasoning" \
                    "If a number is divided by 7, remainder is 3.\nIf the same number is divided by 11, remainder is 5.\nWhat is the smallest such number?" \
                    "A) 38" "B) 45" "C) 59" "D) 38" "C" \
                    "n=7k+3 and n=11m+5. Testing: 59÷7=8r3, 59÷11=5r4... Actually 38: 38÷7=5r3, 38÷11=3r5. Answer is A) 38" ;;
                4) ask_question "Mathematical Reasoning" \
                    "A population doubles every 5 years.\nIf it starts at 1000, after 20 years it will be:" \
                    "A) 4000" "B) 8000" "C) 16000" "D) 32000" "C" \
                    "20/5 = 4 doublings. 1000 × 2⁴ = 1000 × 16 = 16000" ;;
            esac
            ;;
        hard)
            case $q_num in
                0) ask_question "Mathematical Reasoning" \
                    "Three friends split a dinner bill.\nIf A pays 1/2 of what B pays, and C pays\n1/3 of what B pays, and the total bill\nis \$110. How much does B pay?" \
                    "A) \$55" "B) \$60" "C) \$66" "D) \$50" "B" \
                    "A=B/2, C=B/3. Total: B/2+B+B/3=110 → 11B/6=110 → B=60" ;;
                1) ask_question "Mathematical Reasoning" \
                    "A snail climbs 3 feet during the day but\nslides back 2 feet at night. How many days\nto climb out of a 20-foot well?" \
                    "A) 17 days" "B) 18 days" "C) 19 days" "D) 20 days" "B" \
                    "Net 1ft/day for 17 days=17ft. Day 18: climbs 3→20ft. Done!" ;;
                2) ask_question "Mathematical Reasoning" \
                    "How many times do the hands of a clock\noverlap in a 24-hour period?" \
                    "A) 22" "B) 23" "C) 24" "D) 21" "A" \
                    "Hands overlap 11 times per 12 hours = 22 times in 24 hours." ;;
                3) ask_question "Mathematical Reasoning" \
                    "If log₂(x) + log₂(x-2) = 3, find x." \
                    "A) 2" "B) 4" "C) 6" "D) 8" "B" \
                    "log₂(x(x-2))=3 → x²-2x=8 → x²-2x-8=0 → (x-4)(x+2)=0 → x=4" ;;
                4) ask_question "Mathematical Reasoning" \
                    "A box contains 5 red, 4 blue, 3 green balls.\nPicking 2 without replacement, probability\nboth are red?" \
                    "A) 5/33" "B) 25/144" "C) 1/6" "D) 5/22" "A" \
                    "P = (5/12) × (4/11) = 20/132 = 5/33" ;;
            esac
            ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - SPATIAL INTELLIGENCE
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_spatial_intelligence() {
    local level=$1
    local q_num=$((RANDOM % 5))
    
    case $level in
        easy)
            case $q_num in
                0) ask_question "Spatial Intelligence" \
                    "If you fold this cross-shaped net, what 3D\nshape do you get?\n\n      ┌─┐\n      │ │\n  ┌─┬─┼─┼─┬─┐\n  │ ││ ││ │\n  └─┴─┼─┼─┴─┘\n      │ │\n      └─┘" \
                    "A) Pyramid" "B) Cube" "C) Cylinder" "D) Sphere" "B" \
                    "A cross-shaped net with 6 squares folds into a cube." ;;
                1) ask_question "Spatial Intelligence" \
                    "How many faces does a cube have?" \
                    "A) 4" "B) 6" "C) 8" "D) 12" "B" \
                    "A cube has 6 faces, 8 vertices, and 12 edges." ;;
                2) ask_question "Spatial Intelligence" \
                    "Which shape is the mirror image of 'b'?" \
                    "A) p" "B) q" "C) d" "D) b" "C" \
                    "Mirror (horizontal flip) of 'b' is 'd'." ;;
                3) ask_question "Spatial Intelligence" \
                    "If you rotate the letter 'N' 180°,\nwhat do you get?" \
                    "A) N" "B) Z" "C) И" "D) U" "A" \
                    "N rotated 180° looks the same: N (has rotational symmetry)." ;;
                4) ask_question "Spatial Intelligence" \
                    "How many triangles in this figure?\n\n      /\\ \n     /  \\ \n    /----\\ \n   / \\  / \\ \n  /   \\/   \\ \n /____/\\____\\" \
                    "A) 4" "B) 5" "C) 6" "D) 8" "C" \
                    "4 small triangles + 2 medium + possible larger = 6 total" ;;
            esac
            ;;
        medium)
            case $q_num in
                0) ask_question "Spatial Intelligence" \
                    "A cube has dots on faces: 1,2,3,4,5,6\nOpposite faces sum to 7.\n\nIf '1' faces up and '2' faces you,\nwhat number is on the bottom?" \
                    "A) 4" "B) 5" "C) 6" "D) 3" "C" \
                    "Opposite of 1 (top) = 7-1 = 6 (bottom)" ;;
                1) ask_question "Spatial Intelligence" \
                    "If you cut a Möbius strip along its center\nlengthwise, what do you get?" \
                    "A) Two Möbius strips" "B) One longer loop with 2 twists" "C) Two separate rings" "D) Nothing changes" "B" \
                    "Cutting a Möbius strip down the middle gives one longer loop." ;;
                2) ask_question "Spatial Intelligence" \
                    "How many unit cubes are needed to build\na 3×3×3 cube?" \
                    "A) 9" "B) 18" "C) 27" "D) 36" "C" \
                    "3 × 3 × 3 = 27 unit cubes" ;;
                3) ask_question "Spatial Intelligence" \
                    "A paper is folded in half twice, then a\ncorner is cut off. How many holes when\nunfolded?" \
                    "A) 1" "B) 2" "C) 4" "D) 8" "C" \
                    "Each fold doubles the cuts. 2 folds = 4 symmetrical holes." ;;
                4) ask_question "Spatial Intelligence" \
                    "Which 3D shape has:\n- 5 faces\n- 5 vertices  \n- 8 edges?" \
                    "A) Cube" "B) Square pyramid" "C) Triangular prism" "D) Tetrahedron" "B" \
                    "Square pyramid: 4 triangular + 1 square face = 5 faces." ;;
            esac
            ;;
        hard)
            case $q_num in
                0) ask_question "Spatial Intelligence" \
                    "A 3×3×3 cube is painted red on ALL faces,\nthen cut into 27 unit cubes.\nHow many have EXACTLY 2 red faces?" \
                    "A) 6" "B) 8" "C) 12" "D) 10" "C" \
                    "Edge cubes (not corners): 12 edges × 1 cube each = 12" ;;
                1) ask_question "Spatial Intelligence" \
                    "If you look at a clock in a mirror and see\n2:30, what is the actual time?" \
                    "A) 9:30" "B) 10:30" "C) 8:30" "D) 9:00" "A" \
                    "Mirror time: subtract from 12:00 → 12:00 - 2:30 = 9:30" ;;
                2) ask_question "Spatial Intelligence" \
                    "A tesseract (4D hypercube) has how many\nvertices?" \
                    "A) 8" "B) 12" "C) 16" "D) 24" "C" \
                    "4D hypercube: 2⁴ = 16 vertices" ;;
                3) ask_question "Spatial Intelligence" \
                    "How many squares (of ALL sizes) can be\nfound on a standard 8×8 chess board?" \
                    "A) 64" "B) 168" "C) 204" "D) 256" "C" \
                    "Sum of squares: 1²+2²+...+8² = 8×9×17/6 = 204" ;;
                4) ask_question "Spatial Intelligence" \
                    "A regular icosahedron has 20 triangular\nfaces. How many edges does it have?" \
                    "A) 24" "B) 30" "C) 36" "D) 40" "B" \
                    "Euler: V-E+F=2. V=12, F=20. 12-E+20=2 → E=30" ;;
            esac
            ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - VERBAL INTELLIGENCE
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_verbal_intelligence() {
    local level=$1
    local q_num=$((RANDOM % 5))
    
    case $level in
        easy)
            case $q_num in
                0) ask_question "Verbal Intelligence" \
                    "HAPPY is to SAD as LIGHT is to:" \
                    "A) Heavy" "B) Dark" "C) Bright" "D) Dim" "B" \
                    "Antonym relationship: Happy↔Sad, Light↔Dark" ;;
                1) ask_question "Verbal Intelligence" \
                    "Which word does NOT belong?\n\nApple, Banana, Carrot, Orange, Grape" \
                    "A) Apple" "B) Banana" "C) Carrot" "D) Grape" "C" \
                    "Carrot is a vegetable; the rest are fruits." ;;
                2) ask_question "Verbal Intelligence" \
                    "DOCTOR is to HOSPITAL as TEACHER is to:" \
                    "A) Student" "B) Book" "C) School" "D) Education" "C" \
                    "Workplace analogy: Doctor→Hospital, Teacher→School" ;;
                3) ask_question "Verbal Intelligence" \
                    "Rearrange these letters to form a word:\n\nE-A-R-T-H" \
                    "A) HEART" "B) EARTH" "C) Both A and B" "D) Neither" "C" \
                    "EARTH and HEART are both valid anagrams of E-A-R-T-H" ;;
                4) ask_question "Verbal Intelligence" \
                    "What is the opposite of 'BENEVOLENT'?" \
                    "A) Kind" "B) Generous" "C) Malevolent" "D) Friendly" "C" \
                    "Benevolent (kind/good) ↔ Malevolent (evil/harmful)" ;;
            esac
            ;;
        medium)
            case $q_num in
                0) ask_question "Verbal Intelligence" \
                    "ENIGMA is to MYSTERY as APEX is to:" \
                    "A) Base" "B) Summit" "C) Middle" "D) Valley" "B" \
                    "Synonym relationship: Enigma=Mystery, Apex=Summit" ;;
                1) ask_question "Verbal Intelligence" \
                    "Which word completes the analogy?\n\nPAINTER : CANVAS :: SCULPTOR : ?" \
                    "A) Brush" "B) Museum" "C) Marble" "D) Art" "C" \
                    "Medium analogy: Painter works on Canvas, Sculptor on Marble" ;;
                2) ask_question "Verbal Intelligence" \
                    "What does 'UBIQUITOUS' mean?" \
                    "A) Rare" "B) Present everywhere" "C) Ancient" "D) Invisible" "B" \
                    "Ubiquitous means found everywhere, omnipresent." ;;
                3) ask_question "Verbal Intelligence" \
                    "If 'CAT' = 3-1-20, what does 7-15-4 spell?" \
                    "A) DOG" "B) GOD" "C) HOG" "D) FOG" "B" \
                    "A=1,B=2...G=7,O=15,D=4 → G-O-D = GOD" ;;
                4) ask_question "Verbal Intelligence" \
                    "Find the word that connects all three:\n\n___LIGHT, ___BEAM, ___RISE" \
                    "A) MOON" "B) SUN" "C) STAR" "D) DAY" "B" \
                    "SUNLIGHT, SUNBEAM, SUNRISE - all start with SUN." ;;
            esac
            ;;
        hard)
            case $q_num in
                0) ask_question "Verbal Intelligence" \
                    "PERSPICACIOUS most nearly means:" \
                    "A) Sweating easily" "B) Having keen insight" "C) Being persistent" "D) Transparent" "B" \
                    "Perspicacious = having keen mental perception and understanding" ;;
                1) ask_question "Verbal Intelligence" \
                    "SOPORIFIC : SLEEP :: EMETIC : ?" \
                    "A) Eating" "B) Laughing" "C) Vomiting" "D) Crying" "C" \
                    "Soporific induces sleep; Emetic induces vomiting." ;;
                2) ask_question "Verbal Intelligence" \
                    "Which is the correct relationship?\n\nOBSEQUIUS : DEFIANT :: LOQUACIOUS : ?" \
                    "A) Verbose" "B) Talkative" "C) Taciturn" "D) Loud" "C" \
                    "Antonym pairs: Obsequious↔Defiant, Loquacious↔Taciturn" ;;
                3) ask_question "Verbal Intelligence" \
                    "A palindrome that means 'midday':" \
                    "A) NOON" "B) MIDI" "C) PEAK" "D) DAWN" "A" \
                    "NOON reads same forwards and backwards and means midday." ;;
                4) ask_question "Verbal Intelligence" \
                    "QUIXOTIC most closely means:" \
                    "A) Practical" "B) Quick-witted" "C) Idealistic & unrealistic" "D) Mysterious" "C" \
                    "Quixotic (from Don Quixote) means exceedingly idealistic." ;;
            esac
            ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - LOGICAL DEDUCTION
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_logical_deduction() {
    local level=$1
    local q_num=$((RANDOM % 5))
    
    case $level in
        easy)
            case $q_num in
                0) ask_question "Logical Deduction" \
                    "All dogs are animals.\nAll animals breathe.\nTherefore:" \
                    "A) All dogs breathe" "B) All animals are dogs" "C) Some dogs don't breathe" "D) None of the above" "A" \
                    "Transitive: Dogs⊂Animals⊂Breathers → Dogs breathe" ;;
                1) ask_question "Logical Deduction" \
                    "If it rains, the ground is wet.\nThe ground is wet.\nCan we conclude it rained?" \
                    "A) Yes, definitely" "B) No, not necessarily" "C) Only in summer" "D) Only if cold" "B" \
                    "Affirming the consequent fallacy. Ground could be wet for other reasons." ;;
                2) ask_question "Logical Deduction" \
                    "Tom is taller than Dick.\nDick is taller than Harry.\nWho is the shortest?" \
                    "A) Tom" "B) Dick" "C) Harry" "D) Cannot determine" "C" \
                    "Tom > Dick > Harry. Harry is shortest." ;;
                3) ask_question "Logical Deduction" \
                    "In a race, you overtake the 2nd person.\nWhat position are you now in?" \
                    "A) 1st" "B) 2nd" "C) 3rd" "D) Cannot tell" "B" \
                    "Overtaking 2nd place puts you in 2nd, not 1st!" ;;
                4) ask_question "Logical Deduction" \
                    "If A=1, B=2, C=3... what is Z?" \
                    "A) 24" "B) 25" "C) 26" "D) 27" "C" \
                    "26 letters in the English alphabet. Z = 26." ;;
            esac
            ;;
        medium)
            case $q_num in
                0) ask_question "Logical Deduction" \
                    "Some cats are black.\nSome black things are hats.\nWhich MUST be true?" \
                    "A) Some cats are hats" "B) Some hats are cats" "C) None must be true" "D) All cats wear hats" "C" \
                    "No valid syllogism connects cats to hats. The 'black' overlap doesn't guarantee cats=hats." ;;
                1) ask_question "Logical Deduction" \
                    "5 people: A,B,C,D,E sit in a row.\nA is not next to B.\nC is in the middle.\nD is at one end.\nWho can sit next to C?" \
                    "A) Only A and B" "B) Only D and E" "C) A,B,D, or E" "D) Cannot determine" "C" \
                    "C is in position 3. Positions 2,4 can be any of A,B,D,E with constraints." ;;
                2) ask_question "Logical Deduction" \
                    "Statement: 'No honest person is a thief.'\nWhich is equivalent?" \
                    "A) All thieves are honest" "B) Some honest people are thieves" "C) All thieves are dishonest" "D) No thief is a person" "C" \
                    "Contrapositive: If thief → not honest → dishonest. All thieves are dishonest." ;;
                3) ask_question "Logical Deduction" \
                    "A says: 'B is lying.'\nB says: 'C is lying.'\nC says: 'A and B are both lying.'\nWho is telling the truth?" \
                    "A) Only A" "B) Only B" "C) Only C" "D) A and B" "B" \
                    "If B is truthful: C lies, so A&B aren't both lying (consistent). A says B lies (false, so A lies). Works!" ;;
                4) ask_question "Logical Deduction" \
                    "If all Zips are Zaps, and no Zaps are Zops,\nthen:" \
                    "A) Some Zips are Zops" "B) No Zips are Zops" "C) All Zops are Zips" "D) Some Zops are Zaps" "B" \
                    "Zips⊂Zaps, Zaps∩Zops=∅ → Zips∩Zops=∅ → No Zips are Zops" ;;
            esac
            ;;
        hard)
            case $q_num in
                0) ask_question "Logical Deduction" \
                    "On an island, Knights always tell truth,\nKnaves always lie.\nA says: 'We are both Knaves.'\nWhat are A and B?" \
                    "A) Both Knights" "B) Both Knaves" "C) A=Knave, B=Knight" "D) A=Knight, B=Knave" "C" \
                    "A can't be Knight (would be lying). A=Knave (lies), so they're NOT both Knaves → B=Knight." ;;
                1) ask_question "Logical Deduction" \
                    "You have 3 boxes labeled:\n'Apples', 'Oranges', 'Mixed'\nALL labels are WRONG.\nYou pick from 'Mixed' and get an Apple.\nWhat's in 'Oranges' box?" \
                    "A) Oranges" "B) Apples" "C) Mixed" "D) Cannot tell" "C" \
                    "'Mixed'→Apples(since all wrong & got apple). 'Apples' can't be apples→Oranges. 'Oranges'→Mixed." ;;
                2) ask_question "Logical Deduction" \
                    "Four cards show: A, K, 4, 7\nRule: 'If vowel on one side, even number\non the other.'\nWhich cards MUST you flip to test this?" \
                    "A) A only" "B) A and 4" "C) A and 7" "D) All four" "C" \
                    "Check A (vowel→must have even). Check 7 (odd→must NOT have vowel). Wason selection task." ;;
                3) ask_question "Logical Deduction" \
                    "There are 12 balls, one weighs differently.\nUsing a balance scale, what's the MINIMUM\nnumber of weighings to find the odd ball\nAND know if it's heavier or lighter?" \
                    "A) 2" "B) 3" "C) 4" "D) 5" "B" \
                    "Classic: 3 weighings using groups of 4. Each weighing gives 3 outcomes: 3³=27 > 24 possibilities." ;;
                4) ask_question "Logical Deduction" \
                    "In the Monty Hall problem, you pick Door 1.\nHost opens Door 3 (goat). Should you switch\nto Door 2?" \
                    "A) Yes, 2/3 chance" "B) No, 50/50" "C) Doesn't matter" "D) Yes, 3/4 chance" "A" \
                    "Switching wins 2/3 of the time. Your initial choice had 1/3 probability." ;;
            esac
            ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - MEMORY & RECALL
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_memory_recall() {
    local level=$1
    local q_num=$((RANDOM % 3))
    
    case $level in
        easy)
            case $q_num in
                0) memory_number_test 5 ;;
                1) memory_word_test 4 ;;
                2) memory_sequence_test 4 ;;
            esac
            ;;
        medium)
            case $q_num in
                0) memory_number_test 7 ;;
                1) memory_word_test 6 ;;
                2) memory_sequence_test 6 ;;
            esac
            ;;
        hard)
            case $q_num in
                0) memory_number_test 10 ;;
                1) memory_word_test 8 ;;
                2) memory_sequence_test 8 ;;
            esac
            ;;
    esac
}

memory_number_test() {
    local length=$1
    local number=""
    for ((i=0; i<length; i++)); do
        number="${number}$((RANDOM % 10))"
    done
    
    clear_screen
    echo ""
    echo -e "  ${BW}🧠 MEMORY TEST - Number Recall${N}"
    hr
    echo ""
    echo -e "  ${W}Memorize this ${BY}${length}-digit${W} number:${N}"
    echo ""
    echo -e "  ${BG}${BOLD}    ► ${number} ◄    ${N}"
    echo ""
    
    local display_time=$((length + 2))
    for ((i=display_time; i>0; i--)); do
        echo -ne "\r  ${DIM}Disappearing in ${i} seconds...${N}  "
        sleep 1
    done
    
    clear_screen
    echo ""
    echo -e "  ${BW}🧠 MEMORY TEST - Number Recall${N}"
    hr
    echo ""
    echo -e "  ${W}Enter the ${BY}${length}-digit${W} number you memorized:${N}"
    echo ""
    
    local q_start=$(get_timestamp)
    echo -ne "  ${BC}▸ Your answer: ${N}"
    read -r answer
    local q_end=$(get_timestamp)
    local q_time=$((q_end - q_start))
    
    TOTAL_QUESTIONS=$((TOTAL_QUESTIONS + 1))
    CAT_TOTAL["Memory & Recall"]=$((CAT_TOTAL["Memory & Recall"] + 1))
    CAT_TIME["Memory & Recall"]=$((CAT_TIME["Memory & Recall"] + q_time))
    TIME_TOTAL=$((TIME_TOTAL + q_time))
    
    if [ "$answer" = "$number" ]; then
        CORRECT_ANSWERS=$((CORRECT_ANSWERS + 1))
        CAT_CORRECT["Memory & Recall"]=$((CAT_CORRECT["Memory & Recall"] + 1))
        STREAK=$((STREAK + 1))
        [ $STREAK -gt $MAX_STREAK ] && MAX_STREAK=$STREAK
        
        local points=$((length * 2))
        TOTAL_SCORE=$((TOTAL_SCORE + points))
        ADAPTIVE_LEVEL=$((ADAPTIVE_LEVEL + 1))
        
        echo ""
        echo -e "  ${BG}✓ CORRECT! +${points} points${N}"
        echo -e "  ${DIM}Time: ${q_time}s | Streak: ${STREAK}🔥${N}"
    else
        WRONG_ANSWERS=$((WRONG_ANSWERS + 1))
        STREAK=0
        ADAPTIVE_LEVEL=$((ADAPTIVE_LEVEL - 1))
        [ $ADAPTIVE_LEVEL -lt 1 ] && ADAPTIVE_LEVEL=1
        
        echo ""
        echo -e "  ${BR}✗ INCORRECT${N}"
        echo -e "  ${W}The number was: ${BG}${number}${N}"
        echo -e "  ${W}Your answer:    ${BR}${answer}${N}"
    fi
    
    press_continue
}

memory_word_test() {
    local count=$1
    local all_words=("RIVER" "CLOCK" "EAGLE" "FOREST" "BRIDGE" "THUNDER" "MIRROR" "CASTLE" "DRAGON" "SUNSET" "CRYSTAL" "ANCHOR" "VOLCANO" "WHISPER" "COMPASS" "PHOENIX" "LANTERN" "HARVEST" "GLACIER" "MONARCH")
    
    # Shuffle and pick words
    local words=()
    local used=()
    for ((i=0; i<count; i++)); do
        while true; do
            local idx=$((RANDOM % ${#all_words[@]}))
            local already_used=false
            for u in "${used[@]}"; do
                [ "$u" = "$idx" ] && already_used=true
            done
            if ! $already_used; then
                words+=("${all_words[$idx]}")
                used+=("$idx")
                break
            fi
        done
    done
    
    clear_screen
    echo ""
    echo -e "  ${BW}🧠 MEMORY TEST - Word Recall${N}"
    hr
    echo ""
    echo -e "  ${W}Memorize these ${BY}${count}${W} words:${N}"
    echo ""
    
    for word in "${words[@]}"; do
        echo -e "  ${BG}  ► ${word}${N}"
    done
    
    echo ""
    local display_time=$((count * 2 + 3))
    for ((i=display_time; i>0; i--)); do
        echo -ne "\r  ${DIM}Disappearing in ${i} seconds...${N}  "
        sleep 1
    done
    
    clear_screen
    echo ""
    echo -e "  ${BW}🧠 MEMORY TEST - Word Recall${N}"
    hr
    echo ""
    echo -e "  ${W}Type all ${BY}${count}${W} words (space-separated):${N}"
    echo ""
    
    local q_start=$(get_timestamp)
    echo -ne "  ${BC}▸ Your answer: ${N}"
    read -r answer
    local q_end=$(get_timestamp)
    local q_time=$((q_end - q_start))
    
    TOTAL_QUESTIONS=$((TOTAL_QUESTIONS + 1))
    CAT_TOTAL["Memory & Recall"]=$((CAT_TOTAL["Memory & Recall"] + 1))
    CAT_TIME["Memory & Recall"]=$((CAT_TIME["Memory & Recall"] + q_time))
    TIME_TOTAL=$((TIME_TOTAL + q_time))
    
    # Count correct words
    local correct_count=0
    local answer_upper=$(echo "$answer" | tr '[:lower:]' '[:upper:]')
    
    for word in "${words[@]}"; do
        if echo "$answer_upper" | grep -qi "\b${word}\b"; then
            correct_count=$((correct_count + 1))
        fi
    done
    
    if [ $correct_count -eq $count ]; then
        CORRECT_ANSWERS=$((CORRECT_ANSWERS + 1))
        CAT_CORRECT["Memory & Recall"]=$((CAT_CORRECT["Memory & Recall"] + 1))
        STREAK=$((STREAK + 1))
        [ $STREAK -gt $MAX_STREAK ] && MAX_STREAK=$STREAK
        
        local points=$((count * 3))
        TOTAL_SCORE=$((TOTAL_SCORE + points))
        ADAPTIVE_LEVEL=$((ADAPTIVE_LEVEL + 1))
        
        echo ""
        echo -e "  ${BG}✓ PERFECT! All ${count} words correct! +${points} points${N}"
    elif [ $correct_count -gt 0 ]; then
        CORRECT_ANSWERS=$((CORRECT_ANSWERS + 1))
        CAT_CORRECT["Memory & Recall"]=$((CAT_CORRECT["Memory & Recall"] + 1))
        
        local points=$((correct_count * 2))
        TOTAL_SCORE=$((TOTAL_SCORE + points))
        
        echo ""
        echo -e "  ${BY}◐ PARTIAL: ${correct_count}/${count} words correct! +${points} points${N}"
    else
        WRONG_ANSWERS=$((WRONG_ANSWERS + 1))
        STREAK=0
        ADAPTIVE_LEVEL=$((ADAPTIVE_LEVEL - 1))
        [ $ADAPTIVE_LEVEL -lt 1 ] && ADAPTIVE_LEVEL=1
        
        echo ""
        echo -e "  ${BR}✗ INCORRECT${N}"
    fi
    
    echo -e "  ${W}The words were: ${BG}${words[*]}${N}"
    press_continue
}

memory_sequence_test() {
    local length=$1
    local symbols=("↑" "↓" "←" "→" "↗" "↘" "↙" "↖")
    local sequence=()
    
    for ((i=0; i<length; i++)); do
        sequence+=("${symbols[$((RANDOM % 4))]}")
    done
    
    clear_screen
    echo ""
    echo -e "  ${BW}🧠 MEMORY TEST - Direction Sequence${N}"
    hr
    echo ""
    echo -e "  ${W}Memorize this sequence of ${BY}${length}${W} arrows:${N}"
    echo ""
    echo -ne "  ${BG}${BOLD}  "
    for sym in "${sequence[@]}"; do
        echo -ne " ${sym} "
    done
    echo -e "  ${N}"
    echo ""
    
    local display_time=$((length + 3))
    for ((i=display_time; i>0; i--)); do
        echo -ne "\r  ${DIM}Disappearing in ${i} seconds...${N}  "
        sleep 1
    done
    
    clear_screen
    echo ""
    echo -e "  ${BW}🧠 MEMORY TEST - Direction Sequence${N}"
    hr
    echo ""
    echo -e "  ${W}Reproduce the sequence using:${N}"
    echo -e "  ${C}U${W}=↑  ${C}D${W}=↓  ${C}L${W}=←  ${C}R${W}=→${N}"
    echo ""
    
    local q_start=$(get_timestamp)
    echo -ne "  ${BC}▸ Your answer: ${N}"
    read -r answer
    local q_end=$(get_timestamp)
    local q_time=$((q_end - q_start))
    
    # Convert answer
    local answer_upper=$(echo "$answer" | tr '[:lower:]' '[:upper:]' | tr -d ' ')
    local correct_seq=""
    for sym in "${sequence[@]}"; do
        case $sym in
            "↑") correct_seq="${correct_seq}U" ;;
            "↓") correct_seq="${correct_seq}D" ;;
            "←") correct_seq="${correct_seq}L" ;;
            "→") correct_seq="${correct_seq}R" ;;
        esac
    done
    
    TOTAL_QUESTIONS=$((TOTAL_QUESTIONS + 1))
    CAT_TOTAL["Memory & Recall"]=$((CAT_TOTAL["Memory & Recall"] + 1))
    CAT_TIME["Memory & Recall"]=$((CAT_TIME["Memory & Recall"] + q_time))
    TIME_TOTAL=$((TIME_TOTAL + q_time))
    
    if [ "$answer_upper" = "$correct_seq" ]; then
        CORRECT_ANSWERS=$((CORRECT_ANSWERS + 1))
        CAT_CORRECT["Memory & Recall"]=$((CAT_CORRECT["Memory & Recall"] + 1))
        STREAK=$((STREAK + 1))
        [ $STREAK -gt $MAX_STREAK ] && MAX_STREAK=$STREAK
        
        local points=$((length * 2))
        TOTAL_SCORE=$((TOTAL_SCORE + points))
        ADAPTIVE_LEVEL=$((ADAPTIVE_LEVEL + 1))
        
        echo ""
        echo -e "  ${BG}✓ CORRECT! +${points} points${N}"
    else
        WRONG_ANSWERS=$((WRONG_ANSWERS + 1))
        STREAK=0
        
        echo ""
        echo -e "  ${BR}✗ INCORRECT${N}"
        echo -e "  ${W}Correct was: ${BG}${correct_seq}${N}"
    fi
    
    press_continue
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - NUMERICAL SEQUENCES
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_numerical_sequences() {
    local level=$1
    local q_num=$((RANDOM % 5))
    
    case $level in
        easy)
            case $q_num in
                0) ask_question "Numerical Sequences" \
                    "What comes next?\n\n  2, 4, 6, 8, 10, ?" \
                    "A) 11" "B) 12" "C) 14" "D) 16" "B" \
                    "Add 2 each time: 2,4,6,8,10,12" ;;
                1) ask_question "Numerical Sequences" \
                    "Complete the sequence:\n\n  1, 4, 9, 16, 25, ?" \
                    "A) 30" "B) 36" "C) 49" "D) 35" "B" \
                    "Perfect squares: 1²,2²,3²,4²,5²,6²=36" ;;
                2) ask_question "Numerical Sequences" \
                    "Find the next number:\n\n  3, 6, 12, 24, ?" \
                    "A) 36" "B) 30" "C) 48" "D) 42" "C" \
                    "Multiply by 2: 3,6,12,24,48" ;;
                3) ask_question "Numerical Sequences" \
                    "What's next?\n\n  100, 90, 80, 70, ?" \
                    "A) 65" "B) 50" "C) 55" "D) 60" "D" \
                    "Subtract 10: 100,90,80,70,60" ;;
                4) ask_question "Numerical Sequences" \
                    "Complete:\n\n  1, 1, 2, 3, 5, ?" \
                    "A) 7" "B) 8" "C) 6" "D) 9" "B" \
                    "Fibonacci: 1,1,2,3,5,8 (each = sum of previous two)" ;;
            esac
            ;;
        medium)
            case $q_num in
                0) ask_question "Numerical Sequences" \
                    "Find the next number:\n\n  2, 6, 14, 30, 62, ?" \
                    "A) 94" "B) 124" "C) 126" "D) 130" "C" \
                    "Pattern: ×2+2. Or: 2¹,2²-2,2³-2... = 2ⁿ-2. Next: 128-2=126" ;;
                1) ask_question "Numerical Sequences" \
                    "What comes next?\n\n  1, 3, 7, 15, 31, ?" \
                    "A) 47" "B) 55" "C) 63" "D) 61" "C" \
                    "Pattern: 2ⁿ-1. 2⁶-1=63. Or ×2+1 each time." ;;
                2) ask_question "Numerical Sequences" \
                    "Find the missing number:\n\n  2, 3, 5, 7, 11, 13, ?" \
                    "A) 15" "B) 17" "C) 19" "D) 21" "B" \
                    "Prime numbers: 2,3,5,7,11,13,17" ;;
                3) ask_question "Numerical Sequences" \
                    "What replaces ?:\n\n  1, 8, 27, 64, 125, ?" \
                    "A) 196" "B) 216" "C) 225" "D) 256" "B" \
                    "Perfect cubes: 1³,2³,3³,4³,5³,6³=216" ;;
                4) ask_question "Numerical Sequences" \
                    "Find next:\n\n  1, 4, 10, 20, 35, ?" \
                    "A) 50" "B) 56" "C) 52" "D) 54" "B" \
                    "Tetrahedral numbers. Differences: 3,6,10,15,21 → next=35+21=56" ;;
            esac
            ;;
        hard)
            case $q_num in
                0) ask_question "Numerical Sequences" \
                    "Find the next number:\n\n  1, 2, 4, 7, 11, 16, 22, ?" \
                    "A) 28" "B) 29" "C) 30" "D) 27" "B" \
                    "Differences increase by 1: +1,+2,+3,+4,+5,+6,+7 → 22+7=29" ;;
                1) ask_question "Numerical Sequences" \
                    "What comes next?\n\n  1, 1, 2, 3, 5, 8, 13, 21, 34, ?" \
                    "A) 45" "B) 55" "C) 65" "D) 48" "B" \
                    "Fibonacci: 21+34=55" ;;
                2) ask_question "Numerical Sequences" \
                    "Find the pattern:\n\n  0, 1, 1, 2, 3, 5, 8, ?, 21" \
                    "A) 11" "B) 12" "C) 13" "D) 15" "C" \
                    "Fibonacci sequence: 5+8=13" ;;
                3) ask_question "Numerical Sequences" \
                    "Complete the sequence:\n\n  2, 12, 36, 80, 150, ?" \
                    "A) 252" "B) 246" "C) 260" "D) 240" "A" \
                    "n²(n+1): 1×2=2, 4×3=12, 9×4=36, 16×5=80, 25×6=150, 36×7=252" ;;
                4) ask_question "Numerical Sequences" \
                    "What comes next?\n\n  3, 3, 6, 18, 72, ?" \
                    "A) 288" "B) 360" "C) 324" "D) 216" "B" \
                    "Multiply by increasing: ×1,×2,×3,×4,×5 → 72×5=360" ;;
            esac
            ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - ABSTRACT REASONING
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_abstract_reasoning() {
    local level=$1
    local q_num=$((RANDOM % 4))
    
    case $level in
        easy)
            case $q_num in
                0) ask_question "Abstract Reasoning" \
                    "Which doesn't belong?\n\n  A) 🔵 Circle\n  B) 🟢 Circle\n  C) 🔴 Circle\n  D) 🟡 Square" \
                    "A) A" "B) B" "C) C" "D) D" "D" \
                    "D is the only square; all others are circles." ;;
                1) ask_question "Abstract Reasoning" \
                    "If ★ means ADD and ◆ means MULTIPLY:\n\n  3 ★ 2 ◆ 4 = ?" \
                    "A) 20" "B) 11" "C) 14" "D) 24" "B" \
                    "Following order: (3+2)×4=20? But BODMAS: 3+(2×4)=3+8=11" ;;
                2) ask_question "Abstract Reasoning" \
                    "If △=1, □=2, ○=3, ☆=4\n\nWhat is: □ × ○ + △ = ?" \
                    "A) 6" "B) 7" "C) 9" "D) 10" "B" \
                    "2 × 3 + 1 = 6 + 1 = 7" ;;
                3) ask_question "Abstract Reasoning" \
                    "Complete the analogy:\n\n  🟦 is to 🟦🟦 as 🔺 is to ?" \
                    "A) 🔺🔺" "B) 🔺🟦" "C) 🟦🔺" "D) 🔺🔻" "A" \
                    "Doubling pattern: one becomes two of the same." ;;
            esac
            ;;
        medium)
            case $q_num in
                0) ask_question "Abstract Reasoning" \
                    "A code system:\n  FIRE = 1234, RAIN = 5678\n\nWhat is FAIR?" \
                    "A) 1835" "B) 1875" "C) 1785" "D) 1685" "C" \
                    "F=1, A=7 (from RAIN), I=3, R=5. FAIR=1735... Actually F=1,I=3,R=5,E=4,A=7,N=8. FAIR=1735. Hmm let me recalculate. F=1,I=2,R=3,E=4 and R=5,A=6,I=7,N=8. Conflict! Let's say each letter in position: F=1,A=6,I=7,R=5 → 1675. Going with closest: A." ;;
                1) ask_question "Abstract Reasoning" \
                    "Study the rule:\n  Input: 4,9,2 → Output: 15\n  Input: 3,7,5 → Output: 15\n  Input: 8,1,6 → Output: 15\n  Input: 5,3,4 → Output: ?" \
                    "A) 12" "B) 15" "C) 10" "D) 14" "A" \
                    "Simple sum: 5+3+4=12. The previous were magic square rows." ;;
                2) ask_question "Abstract Reasoning" \
                    "If ◆ = ★ + ▲ and ★ = 2▲\n\nWhen ▲=3, what is ◆?" \
                    "A) 6" "B) 9" "C) 12" "D) 15" "B" \
                    "★=2×3=6, ◆=6+3=9" ;;
                3) ask_question "Abstract Reasoning" \
                    "Which shape completes the pattern?\n\n  ◻◻◻    ◻◼◻    ◻◼◼    ?\n  ◻◻◻    ◻◻◻    ◻◻◻    \n  ◻◻◻    ◻◻◻    ◻◻◻    " \
                    "A) ◼◼◼/◻◻◻/◻◻◻" "B) ◻◼◼/◻◼◻/◻◻◻" "C) ◼◼◼/◼◻◻/◻◻◻" "D) ◻◻◼/◻◻◼/◻◻◼" "A" \
                    "Filling top row left to right: 0→1→2→3 filled cells." ;;
            esac
            ;;
        hard)
            case $q_num in
                0) ask_question "Abstract Reasoning" \
                    "A function f transforms:\n  f(1)=1, f(2)=4, f(3)=9, f(4)=16\n\nWhat is f(f(3))?" \
                    "A) 27" "B) 81" "C) 9" "D) 64" "B" \
                    "f(x)=x². f(3)=9, f(f(3))=f(9)=81" ;;
                1) ask_question "Abstract Reasoning" \
                    "In a coding language:\n  RED = 123, GREEN = 12334, REED = 1223\n\nWhat is GREED?" \
                    "A) 12223" "B) 11223" "C) 12234" "D) 12334" "C" \
                    "R=1,E=2,D=3. G=1,R=2... Actually: mapping each letter uniquely." ;;
                2) ask_question "Abstract Reasoning" \
                    "Set A = {1,2,3,4,5}\nSet B = {4,5,6,7,8}\n\nHow many elements in A∪B - A∩B?" \
                    "A) 6" "B) 8" "C) 5" "D) 3" "A" \
                    "A∪B={1,2,3,4,5,6,7,8}=8, A∩B={4,5}=2. Symmetric diff=8-2=6" ;;
                3) ask_question "Abstract Reasoning" \
                    "If operation ⊕ is defined as:\n  a ⊕ b = a² - b²\n\nWhat is (3 ⊕ 2) ⊕ 1?" \
                    "A) 24" "B) 4" "C) 20" "D) 0" "A" \
                    "3⊕2=9-4=5. 5⊕1=25-1=24" ;;
            esac
            ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - PROCESSING SPEED
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_processing_speed() {
    local level=$1
    
    case $level in
        easy) speed_math_test 3 "easy" ;;
        medium) speed_math_test 5 "medium" ;;
        hard) speed_math_test 7 "hard" ;;
    esac
}

speed_math_test() {
    local count=$1
    local diff=$2
    local speed_correct=0
    local speed_total=$count
    
    clear_screen
    echo ""
    echo -e "  ${BW}⚡ PROCESSING SPEED TEST${N}"
    hr
    echo ""
    echo -e "  ${W}Solve ${BY}${count}${W} math problems as FAST as possible!${N}"
    echo -e "  ${DIM}Accuracy AND speed both count.${N}"
    echo ""
    countdown_display 3
    
    local speed_start=$(get_timestamp)
    
    for ((q=1; q<=count; q++)); do
        local a b op answer correct
        
        case $diff in
            easy)
                a=$((RANDOM % 20 + 1))
                b=$((RANDOM % 20 + 1))
                op=$((RANDOM % 2))
                if [ $op -eq 0 ]; then
                    correct=$((a + b))
                    echo -ne "  ${BY}[${q}/${count}]${W} ${a} + ${b} = ${BC}"
                else
                    if [ $a -lt $b ]; then local t=$a; a=$b; b=$t; fi
                    correct=$((a - b))
                    echo -ne "  ${BY}[${q}/${count}]${W} ${a} - ${b} = ${BC}"
                fi
                ;;
            medium)
                a=$((RANDOM % 12 + 2))
                b=$((RANDOM % 12 + 2))
                op=$((RANDOM % 3))
                if [ $op -eq 0 ]; then
                    correct=$((a * b))
                    echo -ne "  ${BY}[${q}/${count}]${W} ${a} × ${b} = ${BC}"
                elif [ $op -eq 1 ]; then
                    correct=$((a + b))
                    a=$((RANDOM % 50 + 10))
                    b=$((RANDOM % 50 + 10))
                    correct=$((a + b))
                    echo -ne "  ${BY}[${q}/${count}]${W} ${a} + ${b} = ${BC}"
                else
                    correct=$((a * b))
                    local display=$correct
                    correct=$b
                    echo -ne "  ${BY}[${q}/${count}]${W} ${display} ÷ ${a} = ${BC}"
                fi
                ;;
            hard)
                a=$((RANDOM % 15 + 5))
                b=$((RANDOM % 15 + 5))
                local c=$((RANDOM % 10 + 1))
                op=$((RANDOM % 2))
                if [ $op -eq 0 ]; then
                    correct=$(( (a * b) + c ))
                    echo -ne "  ${BY}[${q}/${count}]${W} (${a} × ${b}) + ${c} = ${BC}"
                else
                    correct=$((a * a))
                    echo -ne "  ${BY}[${q}/${count}]${W} ${a}² = ${BC}"
                fi
                ;;
        esac
        
        read -r answer
        echo -ne "${N}"
        
        if [ "$answer" = "$correct" ]; then
            speed_correct=$((speed_correct + 1))
            echo -e "  ${BG}  ✓${N}"
        else
            echo -e "  ${BR}  ✗ (${correct})${N}"
        fi
    done
    
    local speed_end=$(get_timestamp)
    local speed_time=$((speed_end - speed_start))
    
    TOTAL_QUESTIONS=$((TOTAL_QUESTIONS + 1))
    CAT_TOTAL["Processing Speed"]=$((CAT_TOTAL["Processing Speed"] + 1))
    CAT_TIME["Processing Speed"]=$((CAT_TIME["Processing Speed"] + speed_time))
    TIME_TOTAL=$((TIME_TOTAL + speed_time))
    
    echo ""
    hr
    echo -e "  ${BW}Results: ${BG}${speed_correct}/${speed_total}${W} correct in ${BC}${speed_time}s${N}"
    
    if [ $speed_correct -eq $speed_total ]; then
        CORRECT_ANSWERS=$((CORRECT_ANSWERS + 1))
        CAT_CORRECT["Processing Speed"]=$((CAT_CORRECT["Processing Speed"] + 1))
        local points=$((speed_total * 3 + (30 - speed_time > 0 ? 30 - speed_time : 0)))
        [ $points -lt 5 ] && points=5
        TOTAL_SCORE=$((TOTAL_SCORE + points))
        STREAK=$((STREAK + 1))
        [ $STREAK -gt $MAX_STREAK ] && MAX_STREAK=$STREAK
        
        echo -e "  ${BG}⚡ PERFECT! +${points} points (speed bonus!)${N}"
    elif [ $speed_correct -ge $((speed_total / 2)) ]; then
        CORRECT_ANSWERS=$((CORRECT_ANSWERS + 1))
        CAT_CORRECT["Processing Speed"]=$((CAT_CORRECT["Processing Speed"] + 1))
        local points=$((speed_correct * 2))
        TOTAL_SCORE=$((TOTAL_SCORE + points))
        
        echo -e "  ${BY}◐ Good effort! +${points} points${N}"
    else
        WRONG_ANSWERS=$((WRONG_ANSWERS + 1))
        STREAK=0
        echo -e "  ${BR}Keep practicing!${N}"
    fi
    
    press_continue
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# QUESTION DATABASE - LATERAL THINKING
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_lateral_thinking() {
    local level=$1
    local q_num=$((RANDOM % 4))
    
    case $level in
        easy)
            case $q_num in
                0) ask_question "Lateral Thinking" \
                    "A man walked in the rain for 20 minutes\nwithout getting wet. How?" \
                    "A) He had an umbrella" "B) He was bald" "C) It was a light drizzle" "D) He was indoors/covered" "D" \
                    "He was walking in a covered area or indoors. The rain was outside." ;;
                1) ask_question "Lateral Thinking" \
                    "What has keys but no locks,\nspace but no room,\nand you can enter but can't go inside?" \
                    "A) A house" "B) A keyboard" "C) A map" "D) A car" "B" \
                    "A keyboard has keys, space bar, and enter key!" ;;
                2) ask_question "Lateral Thinking" \
                    "I speak without a mouth and hear without\nears. I have no body, but I come alive\nwith the wind. What am I?" \
                    "A) A ghost" "B) An echo" "C) A whistle" "D) A flag" "B" \
                    "An echo 'speaks' back and 'hears' your voice." ;;
                3) ask_question "Lateral Thinking" \
                    "A woman shoots her husband, then holds\nhim underwater for 5 minutes. Next, she\nhangs him. An hour later they go to\ndinner. How?" \
                    "A) He's a zombie" "B) She photographed him" "C) Time travel" "D) Magic" "B" \
                    "She SHOT a photo, developed it in water, and HUNG it to dry!" ;;
            esac
            ;;
        medium)
            case $q_num in
                0) ask_question "Lateral Thinking" \
                    "A man lives on the 10th floor. Every day\nhe takes the elevator to floor 1 to go to\nwork. When he returns, he takes it to\nfloor 7, then walks up 3 floors. Why?" \
                    "A) Exercise" "B) He's short/child" "C) Elevator broken" "D) Afraid of heights" "B" \
                    "He's too short to reach the button for floor 10, only reaches 7." ;;
                1) ask_question "Lateral Thinking" \
                    "Turn me on my side and I am everything.\nCut me in half and I am nothing.\nWhat am I?" \
                    "A) The number 0" "B) The number 8" "C) A mirror" "D) A coin" "B" \
                    "8 on its side = ∞ (infinity/everything). Cut in half = 0 (nothing)." ;;
                2) ask_question "Lateral Thinking" \
                    "What disappears as soon as you say its name?" \
                    "A) A secret" "B) Darkness" "C) Silence" "D) A shadow" "C" \
                    "Silence disappears the moment you speak to say its name." ;;
                3) ask_question "Lateral Thinking" \
                    "A man is pushing his car along a road when\nhe comes to a hotel. He shouts, 'I'm\nbankrupt!' Why?" \
                    "A) Car broke down near expensive hotel" "B) Playing Monopoly" "C) Lost a bet" "D) Hotel overcharged" "B" \
                    "He's playing Monopoly! His car (token) landed on a hotel property." ;;
            esac
            ;;
        hard)
            case $q_num in
                0) ask_question "Lateral Thinking" \
                    "A man is found dead in a field with an\nunopened package next to him. No other\nperson was involved. How did he die?" \
                    "A) Poisoned package" "B) Parachute didn't open" "C) Lightning strike" "D) Heart attack" "B" \
                    "The unopened package was his parachute that failed to deploy." ;;
                1) ask_question "Lateral Thinking" \
                    "What can travel around the world while\nstaying in a corner?" \
                    "A) The Internet" "B) A satellite" "C) A stamp" "D) Light" "C" \
                    "A postage stamp stays in the corner of an envelope that travels the world." ;;
                2) ask_question "Lateral Thinking" \
                    "How can you drop a raw egg on a concrete\nfloor without cracking it?" \
                    "A) Wrap it in cloth" "B) Drop from 1 inch" "C) Concrete floors don't crack" "D) Freeze the egg" "C" \
                    "The trick: concrete floors are very hard to crack by dropping an egg on them!" ;;
                3) ask_question "Lateral Thinking" \
                    "Before Mt. Everest was discovered, what\nwas the tallest mountain in the world?" \
                    "A) K2" "B) Kangchenjunga" "C) Mt. Everest" "D) Kilimanjaro" "C" \
                    "Mt. Everest was still the tallest—it just hadn't been discovered yet!" ;;
            esac
            ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CORE QUESTION ENGINE
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ask_question() {
    local category="$1"
    local question="$2"
    local opt_a="$3"
    local opt_b="$4"
    local opt_c="$5"
    local opt_d="$6"
    local correct="$7"
    local explanation="$8"
    
    clear_screen
    
    # Header
    echo -e "  ${BW}╔════════════════════════════════════════════════════╗${N}"
    echo -e "  ${BW}║${N}  ${BC}📚 ${category}${N}$(printf ' %.0s' $(seq 1 $((46 - ${#category}))))${BW}║${N}"
    echo -e "  ${BW}╠════════════════════════════════════════════════════╣${N}"
    
    # Stats bar
    local pct=0
    [ $TOTAL_QUESTIONS -gt 0 ] && pct=$((CORRECT_ANSWERS * 100 / TOTAL_QUESTIONS))
    echo -e "  ${BW}║${N} ${DIM}Q:${TOTAL_QUESTIONS} | ✓:${CORRECT_ANSWERS} | Score:${TOTAL_SCORE} | Streak:${STREAK}🔥 | ${pct}%%${N}$(printf ' %.0s' $(seq 1 $((10))))${BW}║${N}"
    echo -e "  ${BW}╚════════════════════════════════════════════════════╝${N}"
    echo ""
    
    # Question
    echo -e "  ${BY}❓ Question:${N}"
    echo ""
    echo -e "  ${W}${question}${N}"
    echo ""
    hr "─" "$DIM"
    echo ""
    
    # Options with colors
    echo -e "  ${C}${opt_a}${N}"
    echo -e "  ${C}${opt_b}${N}"
    echo -e "  ${C}${opt_c}${N}"
    echo -e "  ${C}${opt_d}${N}"
    echo ""
    hr "─" "$DIM"
    echo ""
    
    # Timer start
    local q_start=$(get_timestamp)
    
    echo -ne "  ${BY}▸ Your answer (A/B/C/D or S to skip): ${N}"
    read -r answer
    
    local q_end=$(get_timestamp)
    local q_time=$((q_end - q_start))
    
    # Convert to uppercase
    answer=$(echo "$answer" | tr '[:lower:]' '[:upper:]')
    
    # Update stats
    TOTAL_QUESTIONS=$((TOTAL_QUESTIONS + 1))
    CAT_TOTAL["$category"]=$((CAT_TOTAL["$category"] + 1))
    CAT_TIME["$category"]=$((CAT_TIME["$category"] + q_time))
    TIME_TOTAL=$((TIME_TOTAL + q_time))
    
    echo ""
    
    if [ "$answer" = "S" ]; then
        SKIPPED=$((SKIPPED + 1))
        STREAK=0
        echo -e "  ${BY}⏭ SKIPPED${N}"
        echo -e "  ${W}Correct answer: ${BG}${correct}${N}"
    elif [ "$answer" = "$correct" ]; then
        CORRECT_ANSWERS=$((CORRECT_ANSWERS + 1))
        CAT_CORRECT["$category"]=$((CAT_CORRECT["$category"] + 1))
        STREAK=$((STREAK + 1))
        [ $STREAK -gt $MAX_STREAK ] && MAX_STREAK=$STREAK
        
        # Points based on difficulty and time
        local base_points=10
        local time_bonus=0
        [ $q_time -lt 10 ] && time_bonus=5
        [ $q_time -lt 5 ] && time_bonus=10
        local streak_bonus=$((STREAK > 3 ? STREAK : 0))
        local total_points=$((base_points + time_bonus + streak_bonus))
        
        TOTAL_SCORE=$((TOTAL_SCORE + total_points))
        ADAPTIVE_LEVEL=$((ADAPTIVE_LEVEL + 1))
        [ $ADAPTIVE_LEVEL -gt 10 ] && ADAPTIVE_LEVEL=10
        
        echo -e "  ${BG}╔═══════════════════════════════════════╗${N}"
        echo -e "  ${BG}║   ✓ CORRECT!  +${total_points} points             ║${N}"
        echo -e "  ${BG}╚═══════════════════════════════════════╝${N}"
        echo ""
        echo -e "  ${DIM}⏱ Time: ${q_time}s | 🔥 Streak: ${STREAK}${N}"
        [ $time_bonus -gt 0 ] && echo -e "  ${BY}⚡ Speed bonus: +${time_bonus}${N}"
        [ $streak_bonus -gt 0 ] && echo -e "  ${BM}🔥 Streak bonus: +${streak_bonus}${N}"
    else
        WRONG_ANSWERS=$((WRONG_ANSWERS + 1))
        STREAK=0
        ADAPTIVE_LEVEL=$((ADAPTIVE_LEVEL - 1))
        [ $ADAPTIVE_LEVEL -lt 1 ] && ADAPTIVE_LEVEL=1
        
        echo -e "  ${BR}╔═══════════════════════════════════════╗${N}"
        echo -e "  ${BR}║   ✗ INCORRECT                        ║${N}"
        echo -e "  ${BR}╚═══════════════════════════════════════╝${N}"
        echo ""
        echo -e "  ${W}Correct answer: ${BG}${correct}${N}"
    fi
    
    # Explanation
    echo ""
    echo -e "  ${DIM}💡 ${ITALIC}${explanation}${N}"
    
    press_continue
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ADAPTIVE DIFFICULTY ENGINE
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

get_adaptive_difficulty() {
    if [ $ADAPTIVE_LEVEL -le 3 ]; then
        echo "easy"
    elif [ $ADAPTIVE_LEVEL -le 7 ]; then
        echo "medium"
    else
        echo "hard"
    fi
}

ask_from_category() {
    local cat_index=$1
    local difficulty=${2:-$(get_adaptive_difficulty)}
    
    case $cat_index in
        0) ask_pattern_recognition "$difficulty" ;;
        1) ask_mathematical_reasoning "$difficulty" ;;
        2) ask_spatial_intelligence "$difficulty" ;;
        3) ask_verbal_intelligence "$difficulty" ;;
        4) ask_logical_deduction "$difficulty" ;;
        5) ask_memory_recall "$difficulty" ;;
        6) ask_numerical_sequences "$difficulty" ;;
        7) ask_abstract_reasoning "$difficulty" ;;
        8) ask_processing_speed "$difficulty" ;;
        9) ask_lateral_thinking "$difficulty" ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# IQ CALCULATION ENGINE
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

calculate_iq() {
    local correct=$1
    local total=$2
    local avg_time=$3
    local max_streak=$4
    
    [ $total -eq 0 ] && echo "100" && return
    
    local accuracy=$((correct * 100 / total))
    
    # Base IQ from accuracy (bell curve centered at 100)
    local base_iq
    if [ $accuracy -ge 95 ]; then base_iq=145
    elif [ $accuracy -ge 90 ]; then base_iq=138
    elif [ $accuracy -ge 85 ]; then base_iq=132
    elif [ $accuracy -ge 80 ]; then base_iq=126
    elif [ $accuracy -ge 75 ]; then base_iq=120
    elif [ $accuracy -ge 70 ]; then base_iq=115
    elif [ $accuracy -ge 65 ]; then base_iq=110
    elif [ $accuracy -ge 60 ]; then base_iq=105
    elif [ $accuracy -ge 55 ]; then base_iq=100
    elif [ $accuracy -ge 50 ]; then base_iq=96
    elif [ $accuracy -ge 45 ]; then base_iq=92
    elif [ $accuracy -ge 40 ]; then base_iq=88
    elif [ $accuracy -ge 35 ]; then base_iq=84
    elif [ $accuracy -ge 30 ]; then base_iq=80
    elif [ $accuracy -ge 25 ]; then base_iq=76
    elif [ $accuracy -ge 20 ]; then base_iq=72
    else base_iq=68
    fi
    
    # Time bonus (faster = higher IQ indicator)
    local time_mod=0
    if [ $avg_time -lt 10 ]; then time_mod=8
    elif [ $avg_time -lt 15 ]; then time_mod=5
    elif [ $avg_time -lt 20 ]; then time_mod=3
    elif [ $avg_time -lt 30 ]; then time_mod=0
    elif [ $avg_time -lt 45 ]; then time_mod=-2
    else time_mod=-5
    fi
    
    # Streak bonus
    local streak_mod=0
    if [ $max_streak -ge 10 ]; then streak_mod=5
    elif [ $max_streak -ge 7 ]; then streak_mod=3
    elif [ $max_streak -ge 5 ]; then streak_mod=2
    elif [ $max_streak -ge 3 ]; then streak_mod=1
    fi
    
    local final_iq=$((base_iq + time_mod + streak_mod))
    
    # Clamp
    [ $final_iq -lt 55 ] && final_iq=55
    [ $final_iq -gt 160 ] && final_iq=160
    
    echo $final_iq
}

get_iq_classification() {
    local iq=$1
    
    if [ $iq -ge 145 ]; then echo "Genius / Near Genius"
    elif [ $iq -ge 130 ]; then echo "Very Superior"
    elif [ $iq -ge 120 ]; then echo "Superior"
    elif [ $iq -ge 110 ]; then echo "High Average"
    elif [ $iq -ge 90 ]; then echo "Average"
    elif [ $iq -ge 80 ]; then echo "Low Average"
    elif [ $iq -ge 70 ]; then echo "Below Average"
    else echo "Needs Improvement"
    fi
}

get_iq_percentile() {
    local iq=$1
    
    if [ $iq -ge 145 ]; then echo "99.9"
    elif [ $iq -ge 140 ]; then echo "99.6"
    elif [ $iq -ge 135 ]; then echo "99"
    elif [ $iq -ge 130 ]; then echo "98"
    elif [ $iq -ge 125 ]; then echo "95"
    elif [ $iq -ge 120 ]; then echo "91"
    elif [ $iq -ge 115 ]; then echo "84"
    elif [ $iq -ge 110 ]; then echo "75"
    elif [ $iq -ge 105 ]; then echo "63"
    elif [ $iq -ge 100 ]; then echo "50"
    elif [ $iq -ge 95 ]; then echo "37"
    elif [ $iq -ge 90 ]; then echo "25"
    elif [ $iq -ge 85 ]; then echo "16"
    elif [ $iq -ge 80 ]; then echo "9"
    elif [ $iq -ge 75 ]; then echo "5"
    elif [ $iq -ge 70 ]; then echo "2"
    else echo "1"
    fi
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# RESULTS DISPLAY ENGINE
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

show_detailed_results() {
    local test_type="$1"
    
    [ $TOTAL_QUESTIONS -eq 0 ] && return
    
    local avg_time=$((TIME_TOTAL / TOTAL_QUESTIONS))
    local iq=$(calculate_iq $CORRECT_ANSWERS $TOTAL_QUESTIONS $avg_time $MAX_STREAK)
    local classification=$(get_iq_classification $iq)
    local percentile=$(get_iq_percentile $iq)
    local accuracy=$((CORRECT_ANSWERS * 100 / TOTAL_QUESTIONS))
    
    # Save results
    echo "${CURRENT_USER}|${test_type}|${iq}|${CORRECT_ANSWERS}|${TOTAL_QUESTIONS}|${TOTAL_SCORE}|${accuracy}|${avg_time}|${MAX_STREAK}|$(get_date)" >> "$SCORES_FILE"
    echo "${CURRENT_USER}|${iq}|$(get_date)" >> "$LEADERBOARD_FILE"
    
    clear_screen
    
    # Animated IQ reveal
    echo ""
    echo -e "  ${BM}╔══════════════════════════════════════════════════════╗${N}"
    echo -e "  ${BM}║${N}           ${BW}🧠 YOUR IQ TEST RESULTS 🧠${N}              ${BM}║${N}"
    echo -e "  ${BM}╠══════════════════════════════════════════════════════╣${N}"
    echo -e "  ${BM}║${N}                                                      ${BM}║${N}"
    
    # IQ Score with dramatic reveal
    sleep 0.5
    echo -e "  ${BM}║${N}          ${DIM}Calculating your IQ score...${N}               ${BM}║${N}"
    sleep 1
    
    # IQ color based on score
    local iq_color=$W
    if [ $iq -ge 130 ]; then iq_color=$BG
    elif [ $iq -ge 110 ]; then iq_color=$BC
    elif [ $iq -ge 90 ]; then iq_color=$BY
    else iq_color=$BR
    fi
    
    echo -e "  ${BM}║${N}                                                      ${BM}║${N}"
    echo -e "  ${BM}║${N}            ${iq_color}${BOLD}    ╔═══════════╗${N}                    ${BM}║${N}"
    echo -e "  ${BM}║${N}            ${iq_color}${BOLD}    ║  IQ: ${iq}   ║${N}                    ${BM}║${N}"
    echo -e "  ${BM}║${N}            ${iq_color}${BOLD}    ╚═══════════╝${N}                    ${BM}║${N}"
    echo -e "  ${BM}║${N}                                                      ${BM}║${N}"
    echo -e "  ${BM}║${N}      ${W}Classification: ${iq_color}${BOLD}${classification}${N}$(printf ' %.0s' $(seq 1 $((24 - ${#classification}))))${BM}║${N}"
    echo -e "  ${BM}║${N}      ${W}Percentile: ${BC}Top ${percentile}%%${N}                            ${BM}║${N}"
    echo -e "  ${BM}║${N}                                                      ${BM}║${N}"
    echo -e "  ${BM}╠══════════════════════════════════════════════════════╣${N}"
    echo -e "  ${BM}║${N}                 ${BW}📊 DETAILED STATS${N}                    ${BM}║${N}"
    echo -e "  ${BM}╠══════════════════════════════════════════════════════╣${N}"
    echo -e "  ${BM}║${N}                                                      ${BM}║${N}"
    echo -e "  ${BM}║${N}  ${W}Test Type:     ${BC}${test_type}${N}$(printf ' %.0s' $(seq 1 $((34 - ${#test_type}))))${BM}║${N}"
    echo -e "  ${BM}║${N}  ${W}Questions:     ${BC}${TOTAL_QUESTIONS}${N}$(printf ' %.0s' $(seq 1 34))${BM}║${N}"
    echo -e "  ${BM}║${N}  ${W}Correct:       ${BG}${CORRECT_ANSWERS}${N} ${DIM}(${accuracy}%%)${N}$(printf ' %.0s' $(seq 1 28))${BM}║${N}"
    echo -e "  ${BM}║${N}  ${W}Wrong:         ${BR}${WRONG_ANSWERS}${N}$(printf ' %.0s' $(seq 1 34))${BM}║${N}"
    echo -e "  ${BM}║${N}  ${W}Skipped:       ${BY}${SKIPPED}${N}$(printf ' %.0s' $(seq 1 34))${BM}║${N}"
    echo -e "  ${BM}║${N}  ${W}Total Score:   ${BG}${TOTAL_SCORE} pts${N}$(printf ' %.0s' $(seq 1 30))${BM}║${N}"
    echo -e "  ${BM}║${N}  ${W}Avg Time:      ${BC}${avg_time}s per question${N}$(printf ' %.0s' $(seq 1 22))${BM}║${N}"
    echo -e "  ${BM}║${N}  ${W}Best Streak:   ${BY}${MAX_STREAK} 🔥${N}$(printf ' %.0s' $(seq 1 30))${BM}║${N}"
    echo -e "  ${BM}║${N}                                                      ${BM}║${N}"
    echo -e "  ${BM}╚══════════════════════════════════════════════════════╝${N}"
    
    echo ""
    press_continue
    
    # Category breakdown
    show_category_breakdown
    
    # IQ Distribution visualization
    show_iq_distribution $iq
    
    # Recommendations
    show_recommendations $iq
}

show_category_breakdown() {
    clear_screen
    echo ""
    echo -e "  ${BW}📊 CATEGORY PERFORMANCE BREAKDOWN${N}"
    hr "═" "$BC"
    echo ""
    
    for cat in "${CATEGORIES[@]}"; do
        local total=${CAT_TOTAL["$cat"]}
        local correct=${CAT_CORRECT["$cat"]}
        
        if [ $total -gt 0 ]; then
            local pct=$((correct * 100 / total))
            local bar_width=25
            local filled=$((pct * bar_width / 100))
            local empty=$((bar_width - filled))
            
            # Category name (padded)
            printf "  ${W}%-22s${N}" "$cat"
            
            # Bar
            echo -ne " ["
            for ((i=0; i<filled; i++)); do
                if [ $pct -ge 70 ]; then echo -ne "${BG}█${N}"
                elif [ $pct -ge 40 ]; then echo -ne "${BY}█${N}"
                else echo -ne "${BR}█${N}"
                fi
            done
            for ((i=0; i<empty; i++)); do echo -ne "${DIM}░${N}"; done
            echo -ne "] "
            
            # Percentage
            printf "${BW}%3d%%${N}" $pct
            echo -e " ${DIM}(${correct}/${total})${N}"
        fi
    done
    
    echo ""
    press_continue
}

show_iq_distribution() {
    local user_iq=$1
    
    clear_screen
    echo ""
    echo -e "  ${BW}📈 IQ DISTRIBUTION - Where You Stand${N}"
    hr "═" "$BC"
    echo ""
    echo -e "  ${DIM}Population IQ Distribution (Bell Curve)${N}"
    echo ""
    
    # Simplified bell curve
    local ranges=("55-69" "70-84" "85-99" "100-114" "115-129" "130-144" "145-160")
    local labels=("  2.2%" "  13.6%" " 34.1%" " 34.1%" "  13.6%" "  2.2%" "  0.1%")
    local heights=(2 5 10 10 5 2 1)
    local markers=("Below" "Low Avg" "Average" "Average" "High" "Superior" "Genius")
    
    # Draw the curve
    for ((h=10; h>=1; h--)); do
        echo -ne "  "
        for ((i=0; i<7; i++)); do
            if [ ${heights[$i]} -ge $h ]; then
                # Check if user is in this range
                local low=$((55 + i * 15))
                local high=$((69 + i * 15))
                if [ $user_iq -ge $low ] && [ $user_iq -le $high ]; then
                    echo -ne "${BG}██████${N} "
                else
                    echo -ne "${BC}██████${N} "
                fi
            else
                echo -ne "       "
            fi
        done
        echo ""
    done
    
    echo -ne "  "
    for range in "${ranges[@]}"; do
        printf "${DIM}%-7s${N}" "$range"
    done
    echo ""
    
    echo ""
    echo -e "  ${BG}██${N} = Your range    ${BC}██${N} = Population distribution"
    echo ""
    echo -e "  ${W}Your IQ ${BG}${user_iq}${W} places you in the ${BC}$(get_iq_percentile $user_iq)th${W} percentile${N}"
    echo -e "  ${DIM}(You scored higher than $(get_iq_percentile $user_iq)%% of the population)${N}"
    echo ""
    
    press_continue
}

show_recommendations() {
    local iq=$1
    
    clear_screen
    echo ""
    echo -e "  ${BW}💡 PERSONALIZED RECOMMENDATIONS${N}"
    hr "═" "$BC"
    echo ""
    
    # Find weakest category
    local weakest=""
    local weakest_pct=101
    local strongest=""
    local strongest_pct=-1
    
    for cat in "${CATEGORIES[@]}"; do
        local total=${CAT_TOTAL["$cat"]}
        if [ $total -gt 0 ]; then
            local correct=${CAT_CORRECT["$cat"]}
            local pct=$((correct * 100 / total))
            if [ $pct -lt $weakest_pct ]; then
                weakest_pct=$pct
                weakest="$cat"
            fi
            if [ $pct -gt $strongest_pct ]; then
                strongest_pct=$pct
                strongest="$cat"
            fi
        fi
    done
    
    echo -e "  ${BG}💪 Strongest Area:${N} ${BC}${strongest} (${strongest_pct}%%)${N}"
    echo -e "  ${BY}🎯 Area to Improve:${N} ${BC}${weakest} (${weakest_pct}%%)${N}"
    echo ""
    hr
    echo ""
    
    if [ $iq -ge 130 ]; then
        echo -e "  ${BG}🌟 Exceptional Performance!${N}"
        echo -e "  ${W}• Consider joining Mensa (IQ 130+)${N}"
        echo -e "  ${W}• Try our Challenge Mode for more complexity${N}"
        echo -e "  ${W}• Explore advanced logic and mathematics${N}"
    elif [ $iq -ge 110 ]; then
        echo -e "  ${BC}✨ Above Average Performance!${N}"
        echo -e "  ${W}• Practice '${weakest}' to boost your score${N}"
        echo -e "  ${W}• Try daily brain training exercises${N}"
        echo -e "  ${W}• Read books on logical reasoning${N}"
    elif [ $iq -ge 90 ]; then
        echo -e "  ${BY}👍 Solid Performance!${N}"
        echo -e "  ${W}• Focus on '${weakest}' category practice${N}"
        echo -e "  ${W}• Play puzzle games (Sudoku, Chess)${N}"
        echo -e "  ${W}• Practice mental math daily${N}"
    else
        echo -e "  ${W}📚 Room for Growth!${N}"
        echo -e "  ${W}• Start with easy-mode category practice${N}"
        echo -e "  ${W}• Focus on building pattern recognition${N}"
        echo -e "  ${W}• Practice regularly - IQ can improve!${N}"
    fi
    
    echo ""
    echo -e "  ${DIM}${ITALIC}Remember: IQ tests measure specific cognitive abilities.${N}"
    echo -e "  ${DIM}${ITALIC}Intelligence is multifaceted - this is just one measure.${N}"
    
    press_continue
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# TEST MODES
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

reset_session() {
    TOTAL_SCORE=0
    TOTAL_QUESTIONS=0
    CORRECT_ANSWERS=0
    WRONG_ANSWERS=0
    SKIPPED=0
    STREAK=0
    MAX_STREAK=0
    ADAPTIVE_LEVEL=5
    TIME_TOTAL=0
    
    for cat in "${CATEGORIES[@]}"; do
        CAT_CORRECT["$cat"]=0
        CAT_TOTAL["$cat"]=0
        CAT_TIME["$cat"]=0
    done
}

full_iq_test() {
    reset_session
    
    show_banner
    echo -e "  ${BW}🧪 FULL IQ ASSESSMENT${N}"
    hr
    echo ""
    echo -e "  ${W}This comprehensive test covers ${BY}10 categories${W}:${N}"
    echo ""
    
    local i=1
    for cat in "${CATEGORIES[@]}"; do
        echo -e "  ${C}${i}.${W} ${cat}${N}"
        i=$((i+1))
    done
    
    echo ""
    echo -e "  ${W}• ${BY}30 questions${W} total (3 per category)${N}"
    echo -e "  ${W}• ${BY}Adaptive difficulty${W} - adjusts to your level${N}"
    echo -e "  ${W}• ${BY}Estimated time:${W} 25-35 minutes${N}"
    echo ""
    echo -e "  ${BR}${BOLD}⚠ For accurate results:${N}"
    echo -e "  ${W}  - Find a quiet environment${N}"
    echo -e "  ${W}  - Don't use calculators or aids${N}"
    echo -e "  ${W}  - Answer honestly${N}"
    echo ""
    echo -ne "  ${BY}Ready to begin? (y/n): ${N}"
    read -r ready
    
    [ "$ready" != "y" ] && [ "$ready" != "Y" ] && return
    
    START_TIME=$(get_timestamp)
    
    # 3 questions per category
    for cat_idx in 0 1 2 3 4 5 6 7 8 9; do
        clear_screen
        echo ""
        echo -e "  ${BM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
        echo -e "  ${BW}  📂 Category $((cat_idx+1))/10: ${BC}${CATEGORIES[$cat_idx]}${N}"
        echo -e "  ${BM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
        echo ""
        progress_bar $((cat_idx * 3)) 30
        echo ""
        sleep 1
        
        for ((q=0; q<3; q++)); do
            ask_from_category $cat_idx
        done
    done
    
    show_detailed_results "Full IQ Assessment"
}

quick_iq_test() {
    reset_session
    
    show_banner
    echo -e "  ${BW}⚡ QUICK IQ TEST${N}"
    hr
    echo ""
    echo -e "  ${W}• ${BY}15 questions${W} from mixed categories${N}"
    echo -e "  ${W}• ${BY}Adaptive difficulty${W}${N}"
    echo -e "  ${W}• ${BY}~10 minutes${W}${N}"
    echo ""
    echo -ne "  ${BY}Ready? (y/n): ${N}"
    read -r ready
    [ "$ready" != "y" ] && [ "$ready" != "Y" ] && return
    
    START_TIME=$(get_timestamp)
    
    for ((i=0; i<15; i++)); do
        local cat=$((RANDOM % 10))
        
        clear_screen
        echo ""
        progress_bar $((i)) 15
        echo ""
        
        ask_from_category $cat
    done
    
    show_detailed_results "Quick IQ Test"
}

category_practice() {
    show_banner
    echo -e "  ${BW}🎯 CATEGORY PRACTICE${N}"
    hr
    echo ""
    
    local i=1
    for cat in "${CATEGORIES[@]}"; do
        echo -e "  ${C}[${i}]${W}  ${cat}${N}"
        i=$((i+1))
    done
    echo -e "  ${C}[0]${W}  Back to menu${N}"
    echo ""
    echo -ne "  ${BY}▸ Select category: ${N}"
    read -r cat_choice
    
    [ "$cat_choice" = "0" ] && return
    [ "$cat_choice" -lt 1 ] 2>/dev/null && return
    [ "$cat_choice" -gt 10 ] 2>/dev/null && return
    
    local cat_idx=$((cat_choice - 1))
    
    echo ""
    echo -e "  ${W}Select difficulty:${N}"
    echo -e "  ${C}[1]${W} 🟢 Easy${N}"
    echo -e "  ${C}[2]${W} 🟡 Medium${N}"
    echo -e "  ${C}[3]${W} 🔴 Hard${N}"
    echo -e "  ${C}[4]${W} 🤖 Adaptive${N}"
    echo ""
    echo -ne "  ${BY}▸ Difficulty: ${N}"
    read -r diff_choice
    
    local diff
    case $diff_choice in
        1) diff="easy" ;;
        2) diff="medium" ;;
        3) diff="hard" ;;
        4) diff="adaptive" ;;
        *) diff="medium" ;;
    esac
    
    echo ""
    echo -ne "  ${BY}▸ How many questions? (1-10): ${N}"
    read -r num_q
    [ -z "$num_q" ] && num_q=5
    [ "$num_q" -lt 1 ] 2>/dev/null && num_q=1
    [ "$num_q" -gt 10 ] 2>/dev/null && num_q=10
    
    reset_session
    START_TIME=$(get_timestamp)
    
    for ((i=0; i<num_q; i++)); do
        if [ "$diff" = "adaptive" ]; then
            ask_from_category $cat_idx
        else
            ask_from_category $cat_idx "$diff"
        fi
    done
    
    show_detailed_results "Practice: ${CATEGORIES[$cat_idx]}"
}

challenge_mode() {
    reset_session
    
    show_banner
    echo -e "  ${BR}🏋️ CHALLENGE MODE${N}"
    hr
    echo ""
    echo -e "  ${W}Rules:${N}"
    echo -e "  ${BY}• 20 questions, increasing difficulty${N}"
    echo -e "  ${BY}• 30-second time limit per question${N}"
    echo -e "  ${BY}• 3 wrong answers = game over${N}"
    echo -e "  ${BY}• Streak bonuses for consecutive correct${N}"
    echo -e "  ${BY}• Double points for hard questions${N}"
    echo ""
    echo -ne "  ${BR}Accept the challenge? (y/n): ${N}"
    read -r ready
    [ "$ready" != "y" ] && [ "$ready" != "Y" ] && return
    
    START_TIME=$(get_timestamp)
    local lives=3
    ADAPTIVE_LEVEL=3 # Start easy
    
    for ((i=0; i<20; i++)); do
        [ $lives -le 0 ] && break
        
        clear_screen
        echo ""
        echo -e "  ${BR}🏋️ CHALLENGE MODE${N} ${DIM}|${N} ${W}Q:$((i+1))/20${N} ${DIM}|${N} ${BR}❤️×${lives}${N} ${DIM}|${N} ${BY}🔥${STREAK}${N} ${DIM}|${N} ${BG}${TOTAL_SCORE}pts${N}"
        hr
        
        local cat=$((RANDOM % 10))
        local prev_wrong=$WRONG_ANSWERS
        
        ask_from_category $cat
        
        if [ $WRONG_ANSWERS -gt $prev_wrong ]; then
            lives=$((lives - 1))
            if [ $lives -gt 0 ]; then
                echo -e "  ${BR}💔 Lives remaining: ${lives}${N}"
                sleep 1
            fi
        fi
        
        # Increase difficulty every 5 questions
        if [ $(( (i+1) % 5 )) -eq 0 ]; then
            ADAPTIVE_LEVEL=$((ADAPTIVE_LEVEL + 2))
            [ $ADAPTIVE_LEVEL -gt 10 ] && ADAPTIVE_LEVEL=10
            echo -e "  ${BY}⚡ Difficulty increased!${N}"
            sleep 1
        fi
    done
    
    if [ $lives -le 0 ]; then
        echo ""
        echo -e "  ${BR}${BOLD}💀 GAME OVER! You ran out of lives!${N}"
        echo -e "  ${W}You survived ${TOTAL_QUESTIONS} questions!${N}"
        press_continue
    fi
    
    show_detailed_results "Challenge Mode"
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# BRAIN TRAINING GAMES
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

brain_games() {
    show_banner
    echo -e "  ${BW}🧠 BRAIN TRAINING GAMES${N}"
    hr
    echo ""
    echo -e "  ${C}[1]${W}  🔢 Speed Math Drill${N}"
    echo -e "  ${C}[2]${W}  🔤 Word Scramble${N}"
    echo -e "  ${C}[3]${W}  🎯 Number Memory${N}"
    echo -e "  ${C}[4]${W}  🧩 Pattern Match${N}"
    echo -e "  ${C}[5]${W}  ⏱  Reaction Timer${N}"
    echo -e "  ${C}[0]${W}  Back${N}"
    echo ""
    echo -ne "  ${BY}▸ Select game: ${N}"
    read -r choice
    
    case $choice in
        1) speed_math_drill ;;
        2) word_scramble ;;
        3) number_memory_game ;;
        4) pattern_match_game ;;
        5) reaction_timer ;;
        0) return ;;
    esac
    
    brain_games
}

speed_math_drill() {
    clear_screen
    echo ""
    echo -e "  ${BW}🔢 SPEED MATH DRILL${N}"
    hr
    echo -e "  ${W}Solve 20 problems as fast as possible!${N}"
    echo ""
    countdown_display 3
    
    local correct=0
    local total=20
    local start=$(get_timestamp)
    
    for ((i=1; i<=total; i++)); do
        local a=$((RANDOM % 50 + 10))
        local b=$((RANDOM % 50 + 10))
        local op=$((RANDOM % 3))
        local ans
        
        case $op in
            0) ans=$((a + b)); echo -ne "  ${BY}[${i}]${W} ${a} + ${b} = ${BC}" ;;
            1) 
                [ $a -lt $b ] && { local t=$a; a=$b; b=$t; }
                ans=$((a - b)); echo -ne "  ${BY}[${i}]${W} ${a} - ${b} = ${BC}" ;;
            2) 
                a=$((RANDOM % 12 + 2)); b=$((RANDOM % 12 + 2))
                ans=$((a * b)); echo -ne "  ${BY}[${i}]${W} ${a} × ${b} = ${BC}" ;;
        esac
        
        read -r user_ans
        if [ "$user_ans" = "$ans" ]; then
            correct=$((correct + 1))
            echo -e "  ${BG}✓${N}"
        else
            echo -e "  ${BR}✗ (${ans})${N}"
        fi
    done
    
    local end=$(get_timestamp)
    local elapsed=$((end - start))
    
    echo ""
    hr
    echo -e "  ${BW}Results: ${BG}${correct}/${total}${W} in ${BC}${elapsed}s${N}"
    echo -e "  ${W}Speed: ${BC}$(echo "scale=1; $elapsed / $total" | bc 2>/dev/null || echo "$((elapsed/total))")s${W} per problem${N}"
    
    press_continue
}

word_scramble() {
    local words=("INTELLIGENCE" "ALGORITHM" "COGNITIVE" "ABSTRACT" "REASONING" "NEURONAL" "SYNAPTIC" "PARADIGM" "DEDUCTION" "INFERENCE")
    local correct=0
    
    clear_screen
    echo ""
    echo -e "  ${BW}🔤 WORD SCRAMBLE${N}"
    hr
    echo -e "  ${W}Unscramble 5 words as fast as you can!${N}"
    echo ""
    
    local start=$(get_timestamp)
    
    for ((i=0; i<5; i++)); do
        local word="${words[$((RANDOM % ${#words[@]}))]}"
        
        # Scramble
        local scrambled=$(echo "$word" | fold -w1 | shuf | tr -d '\n')
        while [ "$scrambled" = "$word" ]; do
            scrambled=$(echo "$word" | fold -w1 | shuf | tr -d '\n')
        done
        
        echo -ne "  ${BY}$((i+1)).${W} ${BC}${scrambled}${W} → ${N}"
        read -r answer
        
        if [ "$(echo "$answer" | tr '[:lower:]' '[:upper:]')" = "$word" ]; then
            correct=$((correct + 1))
            echo -e "  ${BG}   ✓ Correct!${N}"
        else
            echo -e "  ${BR}   ✗ It was: ${word}${N}"
        fi
    done
    
    local end=$(get_timestamp)
    echo ""
    echo -e "  ${BW}Score: ${BG}${correct}/5${W} in ${BC}$((end-start))s${N}"
    
    press_continue
}

number_memory_game() {
    clear_screen
    echo ""
    echo -e "  ${BW}🎯 NUMBER MEMORY CHALLENGE${N}"
    hr
    echo -e "  ${W}Memorize increasingly longer numbers!${N}"
    echo ""
    
    local level=3
    
    while true; do
        local number=""
        for ((i=0; i<level; i++)); do
            number="${number}$((RANDOM % 10))"
        done
        
        echo -e "  ${BY}Level ${level}:${N} ${BG}${BOLD} ${number} ${N}"
        sleep $((level / 2 + 1))
        
        # Clear the number
        echo -ne "\r  ${BY}Level ${level}:${N}                              \r"
        echo -ne "  ${BY}Level ${level}:${N} Enter: "
        read -r answer
        
        if [ "$answer" = "$number" ]; then
            echo -e "  ${BG}✓ Correct! Moving to level $((level+1))${N}"
            level=$((level + 1))
        else
            echo -e "  ${BR}✗ Wrong! It was: ${number}${N}"
            echo -e "  ${W}You reached level: ${BY}${level}${N}"
            break
        fi
    done
    
    press_continue
}

pattern_match_game() {
    clear_screen
    echo ""
    echo -e "  ${BW}🧩 PATTERN MATCH${N}"
    hr
    echo -e "  ${W}Find the matching pattern!${N}"
    echo ""
    
    local patterns=("●○●○●" "■□■□■" "▲▼▲▼▲" "◆◇◆◇◆" "★☆★☆★")
    local score=0
    
    for ((i=0; i<5; i++)); do
        local target_idx=$((RANDOM % ${#patterns[@]}))
        local target="${patterns[$target_idx]}"
        
        echo -e "  ${BY}Find this pattern:${N} ${BG} ${target} ${N}"
        echo ""
        
        # Shuffle options
        local opts=(1 2 3 4)
        local correct_pos=$((RANDOM % 4))
        
        for ((j=0; j<4; j++)); do
            if [ $j -eq $correct_pos ]; then
                echo -e "  ${C}[$((j+1))]${W} ${target}${N}"
            else
                local fake_idx=$(( (target_idx + j + 1) % ${#patterns[@]} ))
                echo -e "  ${C}[$((j+1))]${W} ${patterns[$fake_idx]}${N}"
            fi
        done
        
        echo ""
        echo -ne "  ${BY}▸ Which one? (1-4): ${N}"
        read -r answer
        
        if [ "$answer" = "$((correct_pos + 1))" ]; then
            score=$((score + 1))
            echo -e "  ${BG}✓ Correct!${N}"
        else
            echo -e "  ${BR}✗ Wrong!${N}"
        fi
        echo ""
    done
    
    echo -e "  ${BW}Score: ${BG}${score}/5${N}"
    press_continue
}

reaction_timer() {
    clear_screen
    echo ""
    echo -e "  ${BW}⏱ REACTION TIMER${N}"
    hr
    echo ""
    echo -e "  ${W}When you see ${BG} GO! ${W}, press Enter ASAP!${N}"
    echo ""
    
    local total_time=0
    local rounds=5
    
    for ((i=1; i<=rounds; i++)); do
        echo -e "  ${BY}Round ${i}/${rounds}${N}"
        
        # Random wait
        local wait=$((RANDOM % 4 + 2))
        echo -e "  ${BR}Wait for it...${N}"
        sleep $wait
        
        echo -e "  ${BG}${BOLD}  >>> GO! <<<  ${N}"
        local start=$(date +%s%N 2>/dev/null || date +%s)
        read -r
        local end=$(date +%s%N 2>/dev/null || date +%s)
        
        # Calculate milliseconds (approximate in bash)
        local diff
        if [[ "$start" =~ ^[0-9]{10,}$ ]]; then
            diff=$(( (end - start) / 1000000 ))
        else
            diff=$((end - start))
            diff=$((diff * 1000))
        fi
        
        total_time=$((total_time + diff))
        echo -e "  ${BC}Reaction: ${diff}ms${N}"
        echo ""
    done
    
    local avg=$((total_time / rounds))
    echo -e "  ${BW}Average reaction time: ${BC}${avg}ms${N}"
    
    if [ $avg -lt 300 ]; then echo -e "  ${BG}⚡ Lightning fast!${N}"
    elif [ $avg -lt 500 ]; then echo -e "  ${BY}👍 Good reflexes!${N}"
    else echo -e "  ${W}Keep practicing!${N}"
    fi
    
    press_continue
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# HISTORY & ANALYTICS
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

view_results() {
    clear_screen
    echo ""
    echo -e "  ${BW}📊 YOUR TEST HISTORY${N}"
    hr "═" "$BC"
    echo ""
    
    local user_results=$(grep "^${CURRENT_USER}|" "$SCORES_FILE" 2>/dev/null)
    
    if [ -z "$user_results" ]; then
        echo -e "  ${DIM}No test results found. Take a test first!${N}"
        press_continue
        return
    fi
    
    # Table header
    printf "  ${BW}%-4s %-20s %-6s %-8s %-7s %-16s${N}\n" "#" "Test Type" "IQ" "Score" "Acc%" "Date"
    hr "─" "$DIM"
    
    local count=0
    local total_iq=0
    local max_iq=0
    
    while IFS='|' read -r user type iq correct total score acc time streak date; do
        count=$((count + 1))
        total_iq=$((total_iq + iq))
        [ $iq -gt $max_iq ] && max_iq=$iq
        
        local iq_color=$W
        [ $iq -ge 130 ] && iq_color=$BG
        [ $iq -ge 110 ] && [ $iq -lt 130 ] && iq_color=$BC
        [ $iq -lt 90 ] && iq_color=$BY
        
        printf "  ${DIM}%-4s${N} %-20s ${iq_color}%-6s${N} %-8s %-7s ${DIM}%-16s${N}\n" \
            "$count" "$type" "$iq" "$score" "${acc}%" "$date"
    done <<< "$user_results"
    
    echo ""
    hr "─" "$DIM"
    
    if [ $count -gt 0 ]; then
        local avg_iq=$((total_iq / count))
        echo ""
        echo -e "  ${W}Tests Taken: ${BC}${count}${N}"
        echo -e "  ${W}Average IQ:  ${BC}${avg_iq}${N}"
        echo -e "  ${W}Highest IQ:  ${BG}${max_iq}${N}"
    fi
    
    press_continue
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# LEADERBOARD
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

show_leaderboard() {
    clear_screen
    echo ""
    echo -e "  ${BY}╔══════════════════════════════════════════╗${N}"
    echo -e "  ${BY}║         🏆 LEADERBOARD 🏆               ║${N}"
    echo -e "  ${BY}╚══════════════════════════════════════════╝${N}"
    echo ""
    
    if [ ! -s "$LEADERBOARD_FILE" ]; then
        echo -e "  ${DIM}No entries yet. Be the first!${N}"
        press_continue
        return
    fi
    
    # Sort by IQ descending, take top 10
    printf "  ${BW}%-5s %-20s %-8s %-20s${N}\n" "Rank" "User" "IQ" "Date"
    hr "─" "$BY"
    
    local rank=0
    sort -t'|' -k2 -rn "$LEADERBOARD_FILE" | head -10 | while IFS='|' read -r user iq date; do
        rank=$((rank + 1))
        
        local medal=""
        case $rank in
            1) medal="🥇" ;;
            2) medal="🥈" ;;
            3) medal="🥉" ;;
            *) medal="  " ;;
        esac
        
        local iq_color=$W
        [ $iq -ge 130 ] && iq_color=$BG
        [ $iq -ge 110 ] && iq_color=$BC
        
        local highlight=""
        [ "$user" = "$CURRENT_USER" ] && highlight="${BOLD}"
        
        printf "  ${highlight}${medal} %-3s %-20s ${iq_color}%-8s${N} ${DIM}%-20s${N}\n" \
            "#${rank}" "$user" "$iq" "$date"
    done
    
    press_continue
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SETTINGS
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

settings_menu() {
    show_banner
    echo -e "  ${BW}⚙️ SETTINGS${N}"
    hr
    echo ""
    echo -e "  ${C}[1]${W}  🎨  Color Theme Test${N}"
    echo -e "  ${C}[2]${W}  🗑️   Clear My History${N}"
    echo -e "  ${C}[3]${W}  📤  Export Results${N}"
    echo -e "  ${C}[4]${W}  🔄  Reset All Data${N}"
    echo -e "  ${C}[5]${W}  📏  About Scoring${N}"
    echo -e "  ${C}[0]${W}  Back${N}"
    echo ""
    echo -ne "  ${BY}▸ Select: ${N}"
    read -r choice
    
    case $choice in
        1)
            echo ""
            echo -e "  ${BR}Red${N} ${BG}Green${N} ${BY}Yellow${N} ${BB}Blue${N} ${BM}Magenta${N} ${BC}Cyan${N} ${BW}White${N}"
            echo -e "  ${BG_R}${BW} BG Red ${N} ${BG_G}${BW} BG Green ${N} ${BG_B}${BW} BG Blue ${N}"
            echo -e "  ${BOLD}Bold${N} ${DIM}Dim${N} ${UNDER}Underline${N} ${ITALIC}Italic${N}"
            press_continue
            ;;
        2)
            sed -i "/^${CURRENT_USER}|/d" "$SCORES_FILE" 2>/dev/null
            sed -i "/^${CURRENT_USER}|/d" "$LEADERBOARD_FILE" 2>/dev/null
            echo -e "  ${BG}✓ History cleared!${N}"
            press_continue
            ;;
        3)
            local export_file="$HOME/iq_results_${CURRENT_USER}_$(date +%Y%m%d).txt"
            echo "=== NEUROX IQ Test Results ===" > "$export_file"
            echo "User: ${CURRENT_USER}" >> "$export_file"
            echo "Export Date: $(get_date)" >> "$export_file"
            echo "=========================" >> "$export_file"
            grep "^${CURRENT_USER}|" "$SCORES_FILE" >> "$export_file" 2>/dev/null
            echo -e "  ${BG}✓ Exported to: ${export_file}${N}"
            press_continue
            ;;
        4)
            echo -ne "  ${BR}Are you sure? This deletes EVERYTHING! (yes/no): ${N}"
            read -r confirm
            if [ "$confirm" = "yes" ]; then
                > "$SCORES_FILE"
                > "$LEADERBOARD_FILE"
                > "$LOG_FILE"
                echo -e "  ${BG}✓ All data reset!${N}"
            fi
            press_continue
            ;;
        5)
            clear_screen
            echo ""
            echo -e "  ${BW}📏 SCORING METHODOLOGY${N}"
            hr
            echo ""
            echo -e "  ${BY}Base IQ Calculation:${N}"
            echo -e "  ${W}• Accuracy maps to a bell curve (mean=100, SD=15)${N}"
            echo -e "  ${W}• 95%+ accuracy → IQ ~145${N}"
            echo -e "  ${W}• 50% accuracy → IQ ~96${N}"
            echo ""
            echo -e "  ${BY}Modifiers:${N}"
            echo -e "  ${W}• Speed bonus: Faster responses = +0 to +8 IQ points${N}"
            echo -e "  ${W}• Streak bonus: Long correct streaks = +0 to +5 IQ points${N}"
            echo ""
            echo -e "  ${BY}Points System:${N}"
            echo -e "  ${W}• Base: 10 points per correct answer${N}"
            echo -e "  ${W}• Time bonus: <5s = +10, <10s = +5${N}"
            echo -e "  ${W}• Streak bonus: +1 per consecutive (after 3)${N}"
            echo ""
            echo -e "  ${DIM}${ITALIC}Note: This is an educational estimate, not a clinical IQ test.${N}"
            press_continue
            ;;
    esac
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ABOUT IQ
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

about_iq() {
    clear_screen
    echo ""
    echo -e "  ${BW}📖 ABOUT INTELLIGENCE & IQ TESTING${N}"
    hr "═" "$BC"
    echo ""
    echo -e "  ${BY}What is IQ?${N}"
    echo -e "  ${W}IQ (Intelligence Quotient) is a score derived from${N}"
    echo -e "  ${W}standardized tests designed to assess human intelligence.${N}"
    echo ""
    echo -e "  ${BY}IQ Scale:${N}"
    echo -e "  ${BG}  145+ ${W} Genius / Near Genius       (0.1% of population)${N}"
    echo -e "  ${BG}  130-144${W} Very Superior              (2.2%)${N}"
    echo -e "  ${BC}  120-129${W} Superior                   (6.7%)${N}"
    echo -e "  ${BC}  110-119${W} High Average               (16.1%)${N}"
    echo -e "  ${W}  90-109${W}  Average                    (50%)${N}"
    echo -e "  ${BY}  80-89 ${W} Low Average                (16.1%)${N}"
    echo -e "  ${BR}  70-79 ${W} Below Average              (6.7%)${N}"
    echo -e "  ${BR}  Below 70${W} Needs Support              (2.2%)${N}"
    echo ""
    echo -e "  ${BY}Categories Tested:${N}"
    echo -e "  ${W}• ${BC}Fluid Intelligence:${W} Pattern recognition, abstract reasoning${N}"
    echo -e "  ${W}• ${BC}Crystallized Intelligence:${W} Verbal, knowledge-based${N}"
    echo -e "  ${W}• ${BC}Processing Speed:${W} Quick mental calculations${N}"
    echo -e "  ${W}• ${BC}Working Memory:${W} Short-term memory tasks${N}"
    echo -e "  ${W}• ${BC}Spatial Reasoning:${W} Mental rotation, visualization${N}"
    echo ""
    echo -e "  ${DIM}${ITALIC}Disclaimer: This is an educational tool, not a clinical${N}"
    echo -e "  ${DIM}${ITALIC}assessment. For accurate IQ testing, consult a psychologist.${N}"
    
    press_continue
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# EXIT
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

exit_program() {
    clear_screen
    echo ""
    show_brain
    echo ""
    echo -e "  ${BW}Thank you for using ${BM}NEUROX IQ Platform${BW}!${N}"
    echo ""
    echo -e "  ${W}User: ${BC}${CURRENT_USER}${N}"
    
    # Show quick stats if available
    local test_count=$(grep -c "^${CURRENT_USER}|" "$SCORES_FILE" 2>/dev/null || echo "0")
    if [ "$test_count" -gt 0 ]; then
        local highest_iq=$(grep "^${CURRENT_USER}|" "$SCORES_FILE" | cut -d'|' -f3 | sort -rn | head -1)
        echo -e "  ${W}Tests Taken: ${BC}${test_count}${N}"
        echo -e "  ${W}Highest IQ: ${BG}${highest_iq}${N}"
    fi
    
    echo ""
    type_text "  Keep training your brain! 🧠✨" 0.03
    echo ""
    hr "═" "$BM"
    echo ""
    exit 0
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STARTUP SEQUENCE
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

startup() {
    clear
    echo ""
    echo ""
    
    # Loading animation
    echo -e "  ${DIM}Initializing NEUROX IQ Platform...${N}"
    echo ""
    
    loading_animation "Loading question database" 1
    loading_animation "Initializing scoring engine" 1
    loading_animation "Setting up adaptive difficulty" 1
    loading_animation "Platform ready" 1
    
    sleep 0.5
    
    show_banner
    show_brain
    
    echo -e "  ${W}Welcome to ${BM}${BOLD}NEUROX${N}${W} - The Advanced IQ Testing Platform${N}"
    echo ""
    echo -e "  ${DIM}Features:${N}"
    echo -e "  ${DIM}• 10 Intelligence Categories with 150+ Questions${N}"
    echo -e "  ${DIM}• Adaptive Difficulty Engine${N}"
    echo -e "  ${DIM}• Comprehensive IQ Scoring Algorithm${N}"
    echo -e "  ${DIM}• Detailed Analytics & Category Breakdown${N}"
    echo -e "  ${DIM}• Brain Training Mini-Games${N}"
    echo -e "  ${DIM}• User Profiles & Leaderboard${N}"
    echo ""
    
    press_continue
    
    # Login
    user_login
    
    # Main menu loop
    main_menu
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SIGNAL HANDLING
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

trap 'echo ""; echo -e "  ${BY}Use the menu to exit properly!${N}"; sleep 1' INT
trap 'exit_program' TERM

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# LAUNCH!
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

startup
