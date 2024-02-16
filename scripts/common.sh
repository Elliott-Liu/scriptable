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
