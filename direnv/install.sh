#!/usr/bin/env bash
# Sets up direnv: installs it if missing and stows a zshrc.d fragment that
# hooks it into interactive zsh shells. Safe to re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=../lib/install-common.sh
source "$DOTFILES_DIR/lib/install-common.sh"

info "Setting up direnv..."

if command_exists direnv; then
	ok "direnv already installed ($(direnv version))"
else
	require_brew
	info "Installing direnv..."
	brew install direnv
fi

# This package carries a zsh/zshrc.d/direnv.zsh fragment (hooks direnv into
# interactive shells), stowed under the same default ~/.config target — see
# zsh/.config/zsh/zshrc.d/README.md. ensure_zsh_fragment_dirs (lib/install-
# common.sh) keeps that shared dir real so stow places individual files
# instead of folding the whole tree.
ensure_zsh_fragment_dirs
info "Symlinking direnv zsh fragment via stow..."
(cd "$DOTFILES_DIR" && stow --restow direnv)
ok "direnv config stowed"

ok "direnv setup complete."
