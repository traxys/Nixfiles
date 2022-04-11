#!/usr/bin/env bash


id=$(pw-dump | jq '
	map(
		select(
        	.info.props."application.name" == "spotify" and 
        	.type == "PipeWire:Interface:Node")
	)[-1].id'
)
current_volume=$(pw-dump | jq "
	.[] | 
	select(.id == $id) | 
	.info.params.Props[0].volume"
)

new_volume=current_volume

case $1 in
	*+)
		if [ "$(bc <<< "$current_volume < 1")" -eq 1 ]; then
			new_volume=$(bc <<< "$current_volume + ${1%+}")
		fi
	;;
	*-)
		if [ "$(bc <<< "$current_volume > 0")" -eq 1 ]; then
			new_volume=$(bc <<< "$current_volume - ${1%-}")
		fi
	;;
	*)
		new_volume=$1
	;;
esac

pw-cli set-param "$id" Props "{volume: $new_volume}"
