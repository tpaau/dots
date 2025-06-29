CHECK_DEPENDENCIES_SOURCED=1

if (( PATHS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/paths.sh; fi
if ((LOGGER_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/logger.sh; fi
if ((NOTIFICATIONS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/notifications.sh; fi

# Directory containing depcheck files, used for reducing the frequency of
# dependency checks
DEPCHECKS_DIR="$CACHE_DIR/depchecks"
mkdir -p "$DEPCHECKS_DIR/"

# Temporary file containing all the missing dependencies
MISSING_FILE="$DEPCHECKS_DIR/missing"

# Runs dependency checks for all the scripts.
run_all_depchecks()
{
	log_debug "Running dependency checks"

	local status=0

	run_depcheck logs.sh date || status=1
	run_depcheck media-fetcher.sh eww playerctl || status=1
	run_depcheck regenerate-symlinks.sh ln || status=1
	run_depcheck restart.sh pkill waybar mako hyprpaper eww hyprctl || status=1
	run_depcheck run-wlogout.sh pidof wlogout || status=1
	run_depcheck run-wofi.sh pgrep pkill wofi || status=1
	run_depcheck smenu-utils.sh brightnessctl bc eww || status=1
	run_depcheck take-screenshot.sh pkill hyprshot || status=1
	run_depcheck waybar/toggle-widget.sh eww grep || status=1
	run_depcheck lib/apply-colors.sh sed || status=1
	run_depcheck lib/check-dependencies.sh uniq || status=1
	run_depcheck lib/covers.sh playerctl date magick head awk cut ffmpeg || status=1
	run_depcheck lib/locks.sh touch || status=1
	run_depcheck lib/logger.sh date chmod basename || status=1
	run_depcheck lib/notifications.sh notify-send || status=1
	run_depcheck lib/paths.sh date || status=1
	run_depcheck lib/utils.sh du awk tail find || status=1

	verify_missing || status=1

	log_info "Finished dependency checks, exit status $status"

	return $status
}

# Verifies if all the programs listed in MISSING_FILE are missing, removes ones
# that are already installed.
#
# Takes no arguments.
verify_missing()
{
	log_debug "Verifying missing software"

	if [[ -f "$MISSING_FILE" ]]; then
		echo -n > "$MISSING_FILE.tmp"
		while read cmd; do
			if ! command -v "$cmd" >/dev/null; then
				echo "$cmd" >> "$MISSING_FILE.tmp"
			else
				log_info "Removing '$cmd' from '$MISSING_FILE'"
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

# The first argument is the name of the program that requires the specified
# dependencies.
#
# The following arguments are a list of programs to check. The function returns:
# - 0 if all programs are installed.
# - 1 if any programs are missing.
#
# Missing programs are logged and their names are appended to MISSING_FILE.
run_depcheck()
{
	local status=0	
	local name="$1"
	shift

	if [[ -z "$@" ]]; then
		log_error "No programs to check provided"
		return 1
	fi

	for cmd in "$@"; do
		if ! command -v "$cmd" >/dev/null; then
			log_error "Missing program: $cmd"
			status=1
			echo "$cmd" >> "$MISSING_FILE"
			uniq "$MISSING_FILE" > "$MISSING_FILE.tmp"
			mv "$MISSING_FILE.tmp" "$MISSING_FILE"
		fi
	done

	if (( $status == 0 )); then
		log_debug "$name... ok"
	else
		log_error "$name... failed"
		return $status
	fi
}
