LOGGER_SOURCED=1

if (( PATHS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/paths.sh ; fi
source ~/.config/tpaau-17DB/scripts/tunables/logger.sh

BOLD_WHITE="\033[1;37m"
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
ESC="\033[0m"

# Prints a debug message to `stderr`, and puts it in a log file
# `FILE_LOGGING_ENABLED` is set to `true`.
#
# Args:
# 	$1: The log message
# 	$2: Escape characters added at the beginning of the log (optional)
# 	$3: Args passed to echo (optional)
log_debug()
{
	if [[ $LOGGING_ENABLED == true ]]; then
		local message="${2}${BOLD_WHITE}[${ESC}${BLUE}debug${ESC}${BOLD_WHITE}]${ESC} $(date +%H:%M:%S:%3N) $$ $(basename "$0"): ${1}"

		if [[ "$2" == *"\\r"* ]]; then
			echo -en "\r\033[K"
		fi
		if [[ $FILE_LOGGING_ENABLED == true ]]; then
			echo -e${3} "$message" | tee -a "$LOG_FILE" >&2
		else
			echo -e${3} "$message" >&2
		fi
	fi
}

# Prints an informative message to `stderr`, and puts it in a log file
# `FILE_LOGGING_ENABLED` is set to `true`.
#
# Args:
# 	$1: The log message
# 	$2: Escape characters added at the beginning of the log (optional)
# 	$3: Args passed to echo (optional)
log_info()
{
	if [[ $LOGGING_ENABLED == true ]]; then
		local message="${2}${BOLD_WHITE}[${ESC}${GREEN}info${ESC}${BOLD_WHITE}]${ESC} $(date +%H:%M:%S:%3N) $$ $(basename "$0"): ${1}"

		if [[ "$2" == *"\\r"* ]]; then
			echo -en "\r\033[K"
		fi
		if [[ $FILE_LOGGING_ENABLED == true ]]; then
			echo -e${3} "$message" | tee -a "$LOG_FILE" >&2
		else
			echo -e${3} "$message" >&2
		fi
	fi
}

# Prints a warning message to `stderr`, and puts it in a log file
# `FILE_LOGGING_ENABLED` is set to `true`.
#
# Args:
# 	$1: The log message
# 	$2: Escape characters added at the beginning of the log (optional)
# 	$3: Args passed to echo (optional)
log_warning()
{
	if [[ $LOGGING_ENABLED == true ]]; then
	local message="${2}${BOLD_WHITE}[${ESC}${YELLOW}warning${ESC}${BOLD_WHITE}]${ESC} $(date +%H:%M:%S:%3N) $$ $(basename "$0"): ${1}"

		if [[ "$2" == *"\\r"* ]]; then
			echo -en "\r\033[K"
		fi
		if [[ $FILE_LOGGING_ENABLED == true ]]; then
			echo -e${3} "$message" | tee -a "$LOG_FILE" >&2
		else
			echo -e${3} "$message" >&2
		fi
	fi
}

# Prints an error message to `stderr`, and puts it in a log file
# `FILE_LOGGING_ENABLED` is set to `true`.
#
# Args:
# 	$1: The log message
# 	$2: Escape characters added at the beginning of the log (optional)
# 	$3: Args passed to echo (optional)
log_error()
{
	if [[ $LOGGING_ENABLED == true ]]; then
	local message="${2}${BOLD_WHITE}[${ESC}${RED}ERROR${ESC}${BOLD_WHITE}]${ESC} $(date +%H:%M:%S:%3N) $$ $(basename "$0"): ${1}"

		if [[ "$2" == *"\\r"* ]]; then
			echo -en "\r\033[K"
		fi
		if [[ $FILE_LOGGING_ENABLED == true ]]; then
			echo -e${3} "$message" | tee -a "$LOG_FILE" >&2
		else
			echo -e${3} "$message" >&2
		fi
	fi
}
