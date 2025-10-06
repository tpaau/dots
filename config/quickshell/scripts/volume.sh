#!/usr/bin/env bash

main()
{
	if (( $# != 1 )); then
		return 1
	fi

	local volume
	volume="$(pactl get-sink-volume @DEFAULT_SINK@ \
		| grep -Po '\d+%' \
		| head -n1 \
		| tr -d '%'
		)"

	volume=$(( (volume + 5) / 10 * 10 ))

	if [[ "$1" == "+" ]]; then
		if (( volume > 90 )); then
			volume=90
		fi
		pactl set-sink-volume @DEFAULT_SINK@ $((volume + 10))%
	elif [[ "$1" == "-" ]]; then
		pactl set-sink-volume @DEFAULT_SINK@ $((volume - 10))%
	else
		return 1
	fi
}

main "$@"
exit $?
