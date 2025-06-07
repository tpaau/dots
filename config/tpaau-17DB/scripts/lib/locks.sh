source ~/.config/tpaau-17DB/scripts/lib/logger.sh

# Default timeout for file locks
DEFAULT_LOCK_TIMEOUT=10

# Exits with 0 if given argument is an integer and with 1 otherwise.
#
# Args:
# 	$1: The value to evaluate
is_int()
{
	local value="$1"
	if [[ -z "$value" ]] || [[ ! "$value" =~ ^-?[0-9]+$ ]]; then
		return 0
	fi
	return 1
}

# Finds all .lock files under $TP and removes them.
#
# *Takes no arguments.*
remove_locks() {
	local -a locks=()
	mapfile -t locks < <(find "$TP" -name "*.lock")

	if (( ${#locks[@]} == 0 )); then
		log_debug "No locks found"
		return 0
	else
		log_warning "Removing leftover lock files: ${locks[*]}"
		rm -- "${locks[@]}"
		return $?
	fi
}

# Waits until given file doesn't exist
#
# Args:
# 	$1: The path to the file to watch
# 	$2: The optional timeout value in seconds. When this timeout is reached,
# 	the loop breaks.
lock_db() {
    local lock_file="$1"
    local timeout="$2"
    local delta=0.01
    local i=0

	is_int "$timeout"
	if (( $? == 1 )); then
        timeout=$DEFAULT_LOCK_TIMEOUT
    fi

    while true; do
        if [[ -f "$lock_file" ]]; then
            if (( $(echo "$i == 0" | bc -l) )); then
                log_debug "Waiting for '$lock_file'..."
            elif (( $(echo "$i > $timeout" | bc -l) )); then
                log_warning "Timed out waiting for the lock file"
                log_warning "Removing the lock file"
                rm -f "$lock_file"
                return 1
            fi
            sleep "$delta"
            i=$(echo "$i + $delta" | bc)
        else
            break
        fi
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
