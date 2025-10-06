#!/usr/bin/env bash

main()
{
	(
		pkill qs
		qs
	) &

	(
		pkill wofi
	) &
}

main
