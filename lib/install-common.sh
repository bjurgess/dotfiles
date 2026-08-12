# Shared helpers for dotfiles install scripts. Meant to be sourced, not run.

c_reset=$'\033[0m'
c_blue=$'\033[34m'
c_green=$'\033[32m'
c_yellow=$'\033[33m'
c_red=$'\033[31m'

info() { printf '%s[dotfiles]%s %s\n' "$c_blue" "$c_reset" "$1"; }
ok()   { printf '%s[dotfiles]%s %s\n' "$c_green" "$c_reset" "$1"; }
warn() { printf '%s[dotfiles]%s %s\n' "$c_yellow" "$c_reset" "$1" >&2; }
err()  { printf '%s[dotfiles]%s %s\n' "$c_red" "$c_reset" "$1" >&2; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

# require_brew
# Installs Homebrew via its official installer if missing, then makes sure
# `brew` is on PATH for the rest of this script's execution (the installer
# doesn't update PATH for an already-running shell).
require_brew() {
	if command_exists brew; then
		return
	fi

	info "Homebrew not found. Installing..."
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	local brew_bin=""
	if [ -x /opt/homebrew/bin/brew ]; then
		brew_bin="/opt/homebrew/bin/brew" # Apple Silicon
	elif [ -x /usr/local/bin/brew ]; then
		brew_bin="/usr/local/bin/brew" # Intel
	fi

	if [ -n "$brew_bin" ]; then
		eval "$("$brew_bin" shellenv)"
	fi

	if ! command_exists brew; then
		err "Homebrew install did not complete. Install it manually from https://brew.sh, then re-run this script."
		exit 1
	fi
	ok "Homebrew installed"
}

# backup_if_conflict <path>
# If <path> exists and is a real file/dir (not already a symlink), move it
# aside so stow (or a plain ln) can safely create its symlink in its place.
backup_if_conflict() {
	local target="$1"
	if [ -e "$target" ] && [ ! -L "$target" ]; then
		local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
		warn "Existing $target is not a symlink — backing up to $backup"
		mv "$target" "$backup"
	fi
}
