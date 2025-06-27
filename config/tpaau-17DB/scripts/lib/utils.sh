source ~/.config/tpaau-17DB/scripts/lib/logger.sh

# Exits with 0 if given argument is an integer and with 1 otherwise.
#
# Args:
# 	$1: The value to evaluate
is_int()
{
	local value="$1"
	if [[ -z "$value" ]] || [[ ! "$value" =~ ^-?[0-9]+$ ]]; then
		echo 0
		return $?
	fi
	echo 1
	return $?
}

# Used to clean cache and temporary files as well as directories.
#
# Args:
# 	$1: The file or directory to remove
clean_items()
{
	to_clean="$1"

	if [[ ! -e "$to_clean" ]]; then
		log_error "File or directory '$to_clean' does not exist!"
		return 1
	fi

	local size="$(du -sh "$to_clean" | awk '{print $1}')"

	rm -r "$to_clean"
	
	if (( $? == 0 )); then
		log_info "Deleted $size"
	else
		log_error "Failed deleting '$to_clean'"
	fi
}

# Make the text shorter so it can fit on the screen
shorten_text() 
{
    local text="$1"
	local max_len=$2

	if (( max_len == 0 )); then
		echo "$text"
		return 0
	fi

	if (( ${#text} > max_len )); then
		text="${text:0:$((max_len-1))}"
		text=$(echo "$text" | sed 's/[[:space:]]*$//')
        echo "$text…"
	else
		echo "$text"
    fi
}

# Views logs from the given file in real time.
#
# Gives an error if given file does not exist.
#
# Args:
# 	$1: The path to the log file
view_logs()
{
	local log_file="$1"

	if [[ ! -e "$log_file" ]]; then
		log_warning "Log file doesn't exist: '$log_file'"
	elif [[ ! -f "$log_file" ]]; then
		log_error "Cannot view logs, '$log_file' is not a file"
		return 1
	fi

	tail -n +1 -f "$log_file"
	return $?
}

# Used to remove escape characters from a string.
#
# Args:
# 	$1: The string to sanitize
sanitize_string()
{
	local string="$1"
	string="${string//_/}" && \
	string="${string// /_}" && \
	string="${string//[^a-zA-Z0-9]/}" && \
	string="${string,,}"
	echo "$string"
}

# Runs given command. If the command exists with a non-zero code, global
# `status` variable is set to 1.
#
# Args:
# 	$1: The command to run
run_step()
{
    "$@" || status=1
}
