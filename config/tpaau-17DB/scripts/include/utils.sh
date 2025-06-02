source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh

check_dependencies tail

# Default timeout for file locks
DEFAULT_LOCK_TIMEOUT=10

# Returns true when given value is a number and false otherwise.
#
# Args:
# 	$1: The value to evaluate
is_number()
{
	local value="$1"

	if [[ -z "$value" ]] || [[ ! "$value" =~ ^-?[0-9]+$ ]]; then
		echo true
	else
		echo false
	fi
}

# Waits until given file doesn't exist
#
# Args:
# 	$1: The path to the file to watch
# 	$2: The optional timeout value in seconds. When this timeout is reached,
# 	the loop breaks.
wait_for_lock()
{
	local lock_file="$1"
	local timeout="$2"
	local delta=0.01

	if [[ ! $(is_number "$timeout") ]]; then
		timeout=$DEFAULT_LOCK_TIMEOUT
	fi

	local i=0
	while true; do
		if [[ -f $lock_file ]]; then
			if [[ $(echo "$i == 0" | bc -l) -eq 1 ]]; then
				log_info "Waiting for '$lock_file'..."
			elif [[ $(echo "$i > $DEFAULT_LOCK_TIMEOUT" | bc -l) ]]; then
				log_warning "Timed out waiting for the lock file"
				log_warning "Removing the lock file"
				rm "$lock_file"
				return 1
			fi
			sleep $delta
			i=$(echo "$i + $delta" | bc)
		else
			break
		fi
	done
}

# Waits until given file doesn't exist, then touches that file.
#
# Args:
# 	$1: The path to the file to watch
# 	$2: The optional timeout value in seconds
lock_db()
{
	local lock_file="$1"
	wait_for_lock "$lock_file"
	log_info "Locked '$lock_file'"
	touch "$lock_file"
}

# Removes given lock file
# 
# Args:
# 	$1: The lock file to remove
unlock_db()
{
	local lock_file="$1"
	if [[ ! -f "$lock_file" ]]; then
		log_error "Requested the deletion of '$lock_file', but the file does not exist!"
		return 1
	fi
	rm "$lock_file"
	local status=$?
	if [[ $status -eq 0 ]]; then
		log_info "Unlocked '$lock_file'"
	else
		log_error "Failed unlocking '$lock_file'"
	fi
	return $status
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
	
	if [[ $? -eq 0 ]]; then
		log_info "Deleted $size"
	else
		log_error "Failed deleting '$to_clean'"
	fi
}

view_logs()
{
	local log_file="$1"
	tail -n +1 -f "$log_file"
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
