BOLD_WHITE="\033[1;37m"
BLUE="\033[34m"
YELLOW="\033[33m"
RED="\033[31m"
ESC="\033[0m"

# For every log function:
#  $1: The log message
#  $2: Escape characters added at the beginning of the log
#  $3: Args passed to echo

info()
{
	if [[ "$2" == *"\\r"* ]]; then
        echo -en "\r\033[K"
    fi
	echo -e${3} "${2}${BOLD_WHITE}[${ESC}${BLUE}i${ESC}${BOLD_WHITE}]${ESC} ${1}" >&2
}

warning()
{
	if [[ "$2" == *"\\r"* ]]; then
        echo -en "\r\033[K"
    fi
	echo -e${3} "${2}${BOLD_WHITE}[${ESC}${YELLOW}W${ESC}${BOLD_WHITE}]${ESC} ${1}" >&2
}

error()
{
	if [[ "$2" == *"\\r"* ]]; then
        echo -en "\r\033[K"
    fi
	echo -e${3} "${2}${BOLD_WHITE}[${ESC}${RED}E${ESC}${BOLD_WHITE}]${ESC} ${1}" >&2
}
