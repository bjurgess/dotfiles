#!/usr/bin/env bash
# Sets up Bazelisk: installs it if missing and stows a zshrc.d fragment that
# aliases `bazel` to `bazelisk` in interactive zsh shells. Safe to re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=../lib/install-common.sh
source "$DOTFILES_DIR/lib/install-common.sh"

info "Setting up Bazelisk..."

if command_exists bazelisk; then
	ok "bazelisk already installed ($(bazelisk version 2>&1 | head -n1))"
else
	require_brew
	info "Installing bazelisk..."
	brew install bazelisk
fi

# This package carries a zsh/zshrc.d/bazelisk.zsh fragment (aliases `bazel`
# to `bazelisk`), stowed under the same default ~/.config target — see
# zsh/.config/zsh/zshrc.d/README.md. ensure_zsh_fragment_dirs (lib/install-
# common.sh) keeps that shared dir real so stow places individual files
# instead of folding the whole tree.
ensure_zsh_fragment_dirs
info "Symlinking bazelisk zsh fragment via stow..."
(cd "$DOTFILES_DIR" && stow --restow bazelisk)
ok "bazelisk config stowed"

ok "Bazelisk setup complete."
