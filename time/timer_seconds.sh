#!/bin/bash
# ************************************ #
# Timer in seconds
# Usage:
#	timer_seconds.sh [time in seconds]
# Example, Possible usage to call a script after 10 seconds:
#	timer_seconds.sh 10; echo "I'm done"
# ************************************ #

function timer_seconds {
	if [ $1 = 0 ]; then
		printf "%d:%02d\n" 0 0
		return 0
	elif [ $1 -lt 0 ]; then
		echo 'Error: negative time'
		return 1
	fi
	first_time=1
	function showTimeLeft {
		# Add a new line to keep cursor below, only the first time ran
		if [[ $first_time = 1 ]]; then
			printf "\n"
			first_time=0
		fi
		time_sec_now=$(date +%s)
		left_minutes=$(( ($time_sec_init + $seconds_to_break - $time_sec_now) / 60 ))
		left_seconds=$(( ($time_sec_init + $seconds_to_break - $time_sec_now) % 60 ))
		tput cuu1 # Up one line
		tput el # Delete to end of line
		printf "%d:%02d\n" $left_minutes $left_seconds
	}

	time_sec_init=$(date +%s)
	seconds_to_break=$1
	# Next line to emulate do-while
	showTimeLeft
	while sleep 1; do
		showTimeLeft
		# When timer done, To change timer 0:00 for another message use next line, comment the other one
		# [[ $(($time_sec_init + $seconds_to_break - $time_sec_now)) = 0 ]] && tput cuu1 && tput el && echo "Time elapsed: $1 seconds!" && break
		[[ $(($time_sec_init + $seconds_to_break - $time_sec_now)) -le 0 ]] && break
	done
}

timer_seconds $1
