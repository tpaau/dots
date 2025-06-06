source ~/.config/tpaau-17DB/scripts/include/logger.sh

# Default timeout for file locks
DEFAULT_LOCK_TIMEOUT=10

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
	
	if [[ $? -eq 0 ]]; then
		log_info "Deleted $size"
	else
		log_error "Failed deleting '$to_clean'"
	fi
}

# Removes all files starting with `tmp-` under $TMP_DIR.
#
# * Takes no arguments.*
remove_leftover_tmp()
{
	local -a tmp=()
	mapfile -t tmp < <(find "$TMP_DIR" -name "tmp-*")

	if [[ ${#tmp[@]} -eq 0 ]]; then
		log_debug "No leftover tmp files found"
		return 0
	else
		log_warning "Removing leftover tmp files: ${tmp[*]}"
		rm -- "${tmp[@]}"
		return $?
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

# Finds all *.lock files in the dots root directory (TP) and removes them.
#
# Takes no arguments.
remove_locks()
{
	local locks="$(find "$TP" -name "*.lock")"
	if [[ ! -z "$locks" ]]; then
		log_info "Some lock files are still present: '$locks'"
		while IFS= read -r lock; do
			rm "$lock"
			local status=$?
			if (( $status == 0 )); then
				log_debug "Removed '$lock'"
				return $status
			else
				log_error "Failed deleting '$lock'"
				return $status
			fi
		done <<< "$locks"
	else
		log_debug "No leftover lock files found"
		return 0
	fi
}
