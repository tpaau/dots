source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/notifications.sh

# Directory containing depcheck files, used for reducing the frequency of
# dependency checks
DEPCHECKS_DIR="$TMP_DIR/depchecks"
mkdir -p "$DEPCHECKS_DIR/"

# Temporary file containing all the missing dependencies
MISSING_FILE="$DEPCHECKS_DIR/missing"

# Verifies if all the programs listed in MISSING_FILE are missing, removes ones
# that are already installed.
#
# Takes no arguments.
verify_missing()
{
	if [[ -f "$MISSING_FILE" ]]; then
		echo -n > "$MISSING_FILE.tmp"
		while read cmd; do
			if ! command -v "$cmd" >/dev/null; then
				echo "$cmd" >> "$MISSING_FILE.tmp"
			fi
		done < "$MISSING_FILE"

		if [[ -z $(cat "$MISSING_FILE.tmp") ]]; then
			rm "$MISSING_FILE.tmp"
			if [[ -f "$MISSING_FILE" ]]; then
				rm "$MISSING_FILE"
			fi
		else
			mv "$MISSING_FILE.tmp" "$MISSING_FILE"
		fi
	fi
}

# Takes a list of programs as arguments, returns 0 if all these programs are
# installed, 1 if not. It also notifies user in case the checks have failed.
#
# The status of dependency check is saved in a file alongside with the day
# of the month the check was performed. This is just to reduce redundant
# dependency checks when a script is executed frequently.
#
# If some programs are missing, their names are saved to "$MISSING_FILE",
# declared in `include/paths.sh`.
check_dependencies()
{
	local depcheck_file="$DEPCHECKS_DIR/$(basename "$0")"

	local last_day=""
	local last_status=""

	if [[ -f "$depcheck_file" ]]; then
		read -r last_day < "$depcheck_file"
		read -r last_status < <(sed -n '2p' "$depcheck_file")
	else
		log_warning "Depcheck file doesn't exist, maybe the script is run for the first time?"
	fi

	local status=0
	if [[ "$last_day" != $(date +%d) ]] || [[ $last_status -ne 0 ]]; then
		log_debug "Checking dependencies..."
		for cmd in "$@"; do
			if ! command -v "$cmd" >/dev/null; then
				if [ $status -eq 0 ]; then
					log_error "Missing program: $cmd" "\n" ""
				else
					log_error "Missing program: $cmd"
				fi
				echo "$cmd" >> "$MISSING_FILE"
				uniq "$MISSING_FILE" > "$MISSING_FILE.tmp"
				mv "$MISSING_FILE.tmp" "$MISSING_FILE"
				status=1
			fi
		done
		echo $(date +%d) > "$depcheck_file"
		echo "$status" >> "$depcheck_file"
	else
		# log_debug "Skipping dependency checks."
		return 0
	fi

	verify_missing

	if [ $status -eq 0 ]; then
		return 0
	else
		notify_err "Some dependency checks for '$0' have failed, the script will most likely fail! Missing program names have been written to '$MISSING_FILE'."
		log_info "Missing program names have been written to '$MISSING_FILE'"
		exit 1
	fi
}
