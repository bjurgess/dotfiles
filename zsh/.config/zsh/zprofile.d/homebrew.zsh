# Puts Homebrew (and everything it installs) on PATH for login shells.
# Mirrors the Apple Silicon / Intel detection in require_brew
# (lib/install-common.sh).
if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi
