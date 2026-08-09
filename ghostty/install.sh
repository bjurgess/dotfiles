#!/usr/bin/env bash
# Sets up Ghostty: installs it if missing and stows the config into
# ~/.config/ghostty. Safe to re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=../lib/install-common.sh
source "$DOTFILES_DIR/lib/install-common.sh"

info "Setting up Ghostty..."

if [ -d "/Applications/Ghostty.app" ] || command_exists ghostty; then
	ok "Ghostty already installed"
else
	require_brew
	info "Installing Ghostty..."
	brew install --cask ghostty
fi

# Drop any pre-existing symlink at the target (e.g. a stale one from a prior,
# differently-structured setup) so stow starts from a clean slate.
if [ -L "$HOME/.config/ghostty" ]; then
	rm "$HOME/.config/ghostty"
elif [ -e "$HOME/.config/ghostty" ]; then
	backup_if_conflict "$HOME/.config/ghostty"
fi

info "Symlinking Ghostty config into ~/.config/ghostty via stow..."
(cd "$DOTFILES_DIR" && stow --restow ghostty)
ok "Ghostty config stowed"

ok "Ghostty setup complete. Restart Ghostty (or open a new window) to pick up the config."
