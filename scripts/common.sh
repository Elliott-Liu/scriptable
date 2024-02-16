#!/bin/bash

SRC=src
DIST=dist
BUILD=build
MODULES=modules

ICLOUD_PATH="$HOME/Library/Mobile Documents/iCloud~dk~simonbs~Scriptable/Documents/"

DIST_PATH="$(pwd)/$DIST/"
BUILD_PATH="$(pwd)/$BUILD/"
MODULE_PATH="$(pwd)/$MODULES/"

check_link() {
	local path="$1"
	local relative_path=$(convert_path_to_relative "$path")

	if path_exists "$path"; then
		if is_symbolic_link "$path"; then
			log "\"$relative_path\" is already a symbolic link."
		else
			log_error "\"$relative_path\" is not a symbolic link."
		fi
	else
		return 0
	fi
}

check_path_exists() {
	local path="$1"
	local relative_path=$(convert_path_to_relative "$path")
	if path_exists "$path"; then
		log_success "\"$relative_path\" exists."
	else
		log_error "\"$relative_path\" does not exist."
	fi
}

path_exists() {
	local path="$1"
	[ -e "$path" ]
}

is_symbolic_link() {
	local path="$1"
	[ "$(readlink -f "$path")" != "$path" ]
}

get_link_options() {
	local soft_flag="$1"
	if [ "$soft_flag" = "-s" ]; then
		echo "-s"
	else
		echo ""
	fi
}

create_link() {
	local source_path="$1"
	local destination_path="$2"
	local options="$3"

	ln $options "$source_path" "$destination_path"
}

create_symbolic_link() {
	local source_path="$1"
	local destination_path="$2"
	local soft_flag="$3"

	local options=$(get_link_options "$soft_flag")
	create_link "$source_path" "$destination_path" "$options"
}

check_directory_exists() {
	local path="$1"
	if directory_exists "$path"; then
		log_success "\"$(dirname "$path")\" exists."
	else
		log_error "\"$(dirname "$path")\" does not exist."
	fi
}

directory_exists() {
	local path="$1"
	[ -d "$(dirname "$path")" ]
}

convert_path_to_relative() {
	local path="$1"
	local cwd=$(pwd)
	echo "${path/#$cwd/~}"
}

function select_command() {
	local commands=("$@")
	log "Available commands:\n" "📝"
	PS3=$'\n👉 Please select a command (enter a number): '
	select command in "${commands[@]}"; do
		if [[ -n "$command" ]]; then
			log_success "Running selected command \"$command\"...\n" "🚀"
			$command
			break
		else
			log_error "Invalid selection. Please try again." "🚫"
		fi
	done
}

function log() {
	local message="$1"
	local emoji="${2:-✨}"
	local exit_code="$3"
	echo -e "$emoji $message"
	if [[ -n "$exit_code" ]]; then
		return $exit_code
	fi
	return $?
}

function log_success() {
	local message="$1"
	local emoji="${2:-✅}"
	log "$message" "$emoji" 0
	return $?
}

function log_error() {
	local message="$1"
	local emoji="${2:-❌}"
	log "$message" "$emoji" 1
	return $?
}

function exit_script() {
	local exit_code="$1"
	if [[ $exit_code -ne 0 ]]; then
		log "Exiting script..." "🚪" 1
	else
		log "Done!" "🚀" 0
	fi
	exit $exit_code
}
