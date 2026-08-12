#!/usr/bin/env bash
# Bootstraps this dotfiles repo on a macOS machine: installs Homebrew
# packages from Brewfile, then runs each tool's own install script.
# Safe to re-run — every step checks for what's already in place first.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/install-common.sh
source "$DOTFILES_DIR/lib/install-common.sh"

info "Installing dotfiles from $DOTFILES_DIR"

require_brew

info "Installing Homebrew packages from Brewfile (skips anything already installed)..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

if command_exists stow; then
	ok "stow already installed"
else
	info "Installing GNU Stow..."
	brew install stow
fi

info "Running tmux setup..."
bash "$DOTFILES_DIR/tmux/install.sh"

info "Running Ghostty setup..."
bash "$DOTFILES_DIR/ghostty/install.sh"

info "Running Neovim setup..."
bash "$DOTFILES_DIR/nvim/install.sh"

info "Running zsh setup..."
bash "$DOTFILES_DIR/zsh/install.sh"

ok "Dotfiles install complete."
info "Restart your terminal (or open a new Ghostty window) and start tmux to see everything in effect."
