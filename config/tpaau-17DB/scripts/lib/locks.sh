source ~/.config/tpaau-17DB/scripts/lib/utils.sh

# Default timeout for file locks
DEFAULT_LOCK_TIMEOUT=10

# Waits until given file doesn't exist
#
# Args:
# 	$1: The path to the file to watch
# 	$2: The optional timeout value in seconds. When this timeout is reached,
# 	the loop breaks.
lock_db() {
    local lock_file="$1"
    local timeout="${2:-$DEFAULT_LOCK_TIMEOUT}"
    local start_time elapsed

	if [[ $(is_int "$timeout") -eq 1 ]]; then
		timeout=$DEFAULT_LOCK_TIMEOUT
	fi
    start_time=$SECONDS

    while [[ -f "$lock_file" ]]; do
        elapsed=$(( SECONDS - start_time ))

        if (( elapsed == 0 )); then
            log_debug "Waiting for '$lock_file'..."
        elif (( elapsed > timeout )); then
            log_warning "Timed out waiting for the lock file"
            log_info "Removing the lock file"
            rm -f "$lock_file"
            return 1
        fi

        sleep 0.1
    done

    touch "$lock_file"
    log_debug "Locked '$lock_file'"
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
	if (( $status == 0 )); then
		log_debug "Unlocked '$lock_file'"
	else
		log_error "Failed unlocking '$lock_file'"
	fi
	return $status
}
