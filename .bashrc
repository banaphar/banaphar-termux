# ===== BANAPHAR Galaxy Terminal v7 =====
# Fixed: default output colors (no all-green) | green input | word-wrap | Termux
# Created for Termux by Vivek Banaphar ⚔️

# --- Clear screen and set dark background ---
clear
echo -e "\033]11;#000000\007"   # Background black
echo -e "\033]12;#00FFFF\007"   # Neon cyan cursor

COLUMNS=$(tput cols 2>/dev/null || echo 100)

# --- Galaxy gradient options ---
gradients=(
    "-F 0.05 -S 150"
    "-F 0.02 -S 300"
    "-F 0.07 -S 120"
    "-F 0.1 -S 250"
    "-a -d 1 -F 0.2 -S 180"
)

# --- Function: Create nano-star galaxy row ---
make_star_row() {
    row=""
    for ((j=0; j<COLUMNS; j++)); do
        case $(( RANDOM % 15 )) in
            0|1) row+="." ;;
            2) row+="·" ;;
            *) row+=" " ;;
        esac
    done
    echo "$row"
}

# --- Function: Render BANAPHAR banner with galaxy effect ---
banaphar_banner() {
    RANDOM_GRADIENT=${gradients[$RANDOM % ${#gradients[@]}]}
    make_star_row | lolcat $RANDOM_GRADIENT

    BANNER_TEXT="BANAPHAR"
    BANNER_FONT="smblock"
    BANNER_TMP=$(mktemp -t banaphar.XXXX)

    if command -v toilet >/dev/null 2>&1; then
        toilet -f "$BANNER_FONT" "$BANNER_TEXT" > "$BANNER_TMP"
    else
        figlet -f "$BANNER_FONT" "$BANNER_TEXT" > "$BANNER_TMP"
    fi

    BANNER_WIDTH=$(awk '{ if (length > max) max = length } END { print max }' "$BANNER_TMP")

    while IFS= read -r line; do
        left_space=$(( (COLUMNS - BANNER_WIDTH) / 2 ))
        right_space=$(( COLUMNS - left_space - BANNER_WIDTH ))

        left_stars=""
        for ((i=0; i<left_space; i++)); do
            case $(( RANDOM % 20 )) in
                0|1) left_stars+="." ;;
                2) left_stars+="·" ;;
                *) left_stars+=" " ;;
            esac
        done

        right_stars=""
        for ((i=0; i<right_space; i++)); do
            case $(( RANDOM % 20 )) in
                0|1) right_stars+="." ;;
                2) right_stars+="·" ;;
                *) right_stars+=" " ;;
            esac
        done

        echo "$left_stars$line$right_stars" | lolcat $RANDOM_GRADIENT
    done < "$BANNER_TMP"

    rm -f "$BANNER_TMP"
    make_star_row | lolcat $RANDOM_GRADIENT

    # Leave terminal text green for user input (no reset here)
    printf "\033[1;32m"
}

# --- Display galaxy before each prompt ---
PROMPT_COMMAND=banaphar_banner

# --- Colors (for PS1, not for forcing outputs) ---
GREEN='\e[1;32m'
CYAN='\e[1;96m'
YELLOW='\e[1;33m'
RESET='\e[0m'

# --- Futuristic Prompt (PS1) ---
# Use \[ \] around non-printing sequences so readline sizing works right
PS1="\[\e[1;96m\]∞\[\e[0m\]\[\e[1;33m\] ➤ \[\e[1;32m\]"

# ------------------------------------------------------------------
# Critical: Ensure outputs use terminal/default colors (NOT forced green)
# ------------------------------------------------------------------

# 1) Reset terminal attributes BEFORE each command runs (keeps outputs default).
#    DEBUG trap runs just before the command, so we reset color/attributes here.
trap 'printf "\033[0m"' DEBUG

# 2) Unset or override env variables that sometimes force uniform colors.
#    This avoids situations where external config makes everything green.
unset CLICOLOR
unset LSCOLORS
unset GREP_OPTIONS
unset GREP_COLORS

# 3) Provide a sane LS_COLORS fallback so `ls` shows different colors per filetype.
#    If dircolors exists, use it; otherwise set a common default mapping.
if command -v dircolors >/dev/null 2>&1; then
    # try system dircolors; if it fails, fall through to default below
    eval "$(dircolors -b 2>/dev/null || true)"
fi

# If LS_COLORS is still empty, set a sensible default (covers common types).
# This mapping gives: directories blue, symlinks cyan, executables green, images magenta, archives red, etc.
: "${LS_COLORS:=rs=0:di=01;34:ln=01;36:so=01;35:pi=40;33:ex=01;32:bd=40;33;01:cd=40;33;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogg=01;35:*.aac=00;*.au=00:*.flac=00:*.mp3=00:*.wav=00:*.oga=00:*.mid=00:*.midi=00:*.m4a=00:*.ra=00:*.ape=00}" 
export LS_COLORS

# ------------------------------------------------------------------
# Keep prompt simple and minimal; do NOT force output color via aliases
# ------------------------------------------------------------------

# NOTE: Do NOT alias ls or grep to --color=always — we want default behavior so that
# piping/redirecting behaves correctly and so that colors reflect file types.
# If you previously added aliases for ls/grep remove/comment them.

# --- Error highlight: show red X on failure (but do not force terminal color) ---
trap 'ret=$?; if [ $ret -ne 0 ]; then printf "\n\033[1;31m✖ Command failed (%s)\033[0m\n" "$ret"; fi' ERR

# --- Enable line wrap globally and in nano ---
shopt -s checkwinsize
export LESS="-R"
export COLUMNS=$(tput cols)
export WRAP=1

# Soft-wrap in nano config
if [ ! -d ~/.config/nano ]; then mkdir -p ~/.config/nano; fi
echo "set softwrap" > ~/.config/nano/nanorc

# ===== End of BANAPHAR Terminal v7 =====
