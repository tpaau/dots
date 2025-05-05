check_dependencies()
{
	source ~/.config/tpaau-17DB/scripts/include/paths.sh
	source $LIB_DIR/logger.sh

	log_info "Checking dependencies..." "" "n"
	local status=0

	for cmd in "$@"; do
        if ! command -v "$cmd" >/dev/null; then
			if [ $status -eq 0 ]; then
				log_error "\nmissing: $cmd"
			else
				log_error "missing: $cmd"
			fi
            status=1
        fi
    done

	if [ $status -eq 0 ]; then
		echo " ok"
		return 0
	else
		notify_err "Some dependency checks have failed, the script will most likely fail!"
		exit 1
	fi
}
