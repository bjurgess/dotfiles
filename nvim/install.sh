#!/usr/bin/env bash
# Sets up Neovim: installs it (and its LSP/formatter toolchain deps) if
# missing, stows the config into ~/.config/nvim, then syncs plugins and
# Mason-managed LSPs/formatters/linters/DAP adapters headlessly. Safe to
# re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=../lib/install-common.sh
source "$DOTFILES_DIR/lib/install-common.sh"

info "Setting up Neovim..."

if command_exists nvim; then
	ok "Neovim already installed ($(nvim --version | head -n1))"
else
	require_brew
	info "Installing Neovim..."
	brew install neovim
fi

# ripgrep/fd power Telescope's live_grep/find_files pickers; a C compiler is
# needed to build telescope-fzf-native's native sorter.
for dep in ripgrep fd; do
	if command_exists "$dep"; then
		ok "$dep already installed"
	else
		require_brew
		info "Installing $dep..."
		brew install "$dep"
	fi
done

# This package's layout (nvim/.config/nvim/...) mirrors $HOME directly,
# unlike the flat ~/.config-relative layout the other packages use — so it
# needs its own --target, overriding the repo-wide default in .stowrc.
if [ -L "$HOME/.config/nvim" ]; then
	rm "$HOME/.config/nvim"
elif [ -e "$HOME/.config/nvim" ]; then
	backup_if_conflict "$HOME/.config/nvim"
fi

info "Symlinking Neovim config into ~/.config/nvim via stow..."
(cd "$DOTFILES_DIR" && stow --target="$HOME" --restow nvim)
ok "Neovim config stowed"

info "Syncing plugins (lazy.nvim)..."
if nvim --headless "+Lazy! sync" +qa; then
	ok "Plugins synced"
else
	warn "Lazy sync reported an issue — check the output above"
fi

info "Installing LSPs/formatters/linters/DAP adapters (mason-tool-installer)..."
if nvim --headless "+MasonToolsInstallSync" +qa; then
	ok "Mason tools installed"
else
	warn "Mason tool install reported an issue — check the output above"
fi

ok "Neovim setup complete. Launch nvim and run :checkhealth to verify."
