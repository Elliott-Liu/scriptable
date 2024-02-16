#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$DIR/common.sh"

COMMANDS=(init list_scripts list_modules export_script export_module build build_and_watch open_in_scriptable)

if [[ $# -gt 0 ]] && [[ "${COMMANDS[@]}" =~ "$1" ]]; then
	$1 "${@:2}"
else
	select_command "${COMMANDS[@]}"
fi
