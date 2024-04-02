#!/usr/bin/env bash

REMOTE=root@192.168.1.65
CONFIG=minus

nixos-rebuild switch \
	--verbose \
	--fast \
	--use-remote-sudo \
	--flake .#${CONFIG} \
	--target-host $REMOTE "$@"

