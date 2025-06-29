#!/usr/bin/env bash

if (( UTILS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/utils.sh; fi
if (( LOGGER_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/logger.sh; fi
if (( PATHS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/paths.sh; fi

log_info "Tailing log file '$LOG_FILE'"
view_logs "$LOG_FILE"
exit $?
