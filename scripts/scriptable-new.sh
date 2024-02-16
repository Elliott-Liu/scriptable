#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$DIR/common.sh"

COMMANDS=(init list_scripts list_modules export_script export_module build build_and_watch open_in_scriptable)

function init() {
	local source_path=$ICLOUD_PATH
	local destination_path=$BUILD_PATH

	check_directory_exists "$source_path"
	if [ $? -ne 0 ]; then
		exit_script $?
	fi

	check_directory_exists "$destination_path"
	if [ $? -ne 0 ]; then
		exit_script $?
	fi

	# create_symbolic_link "${source_path}" "${destination_path}" -s
	# local create_symbolic_link_exit_status=$?
	# if [ $create_symbolic_link_exit_status -ne 0 ]; then
	# 	check_path_exists $source_path
	# fi

	# check_link "$destination_path"
	# if [ $? -ne 0 ]; then
	# 	echo $?
	# fi

	# if [ "$?" == 1 ]; then
	# 	exit_script
	# fi

	# if [ "$?" == 0 ]; then
	# 	log_success "Successfully created $link_type link: \"$friendly_source_path\" to \"$friendly_destination_path\""
	# else
	# 	log_error "Failed to create $link_type link: \"$friendly_source_path\" to \"$friendly_destination_path\""
	# fi

	# exit_script $?
}

if [[ $# -gt 0 ]] && [[ "${COMMANDS[@]}" =~ "$1" ]]; then
	$1 "${@:2}"
else
	select_command "${COMMANDS[@]}"
fi
