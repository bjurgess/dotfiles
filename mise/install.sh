#!/usr/bin/env bash
# Sets up mise: installs it if missing and stows a zshrc.d fragment that
# activates it (shims + auto-switching) in interactive zsh shells. Safe to
# re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=../lib/install-common.sh
source "$DOTFILES_DIR/lib/install-common.sh"

info "Setting up mise..."

if command_exists mise; then
	ok "mise already installed ($(mise --version))"
else
	require_brew
	info "Installing mise..."
	brew install mise
fi

# This package carries a zsh/zshrc.d/mise.zsh fragment (activates mise into
# interactive shells), stowed under the same default ~/.config target — see
# zsh/.config/zsh/zshrc.d/README.md. ensure_zsh_fragment_dirs (lib/install-
# common.sh) keeps that shared dir real so stow places individual files
# instead of folding the whole tree.
ensure_zsh_fragment_dirs
info "Symlinking mise zsh fragment via stow..."
(cd "$DOTFILES_DIR" && stow --restow mise)
ok "mise config stowed"

ok "mise setup complete."
