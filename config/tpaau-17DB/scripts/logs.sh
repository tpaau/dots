#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/lib/logger.sh
source ~/.config/tpaau-17DB/scripts/lib/utils.sh

log_info "Tailing log file '$LOG_FILE'"
view_logs "$LOG_FILE"
exit $?
