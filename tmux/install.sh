#!/usr/bin/env bash
# Sets up tmux: installs tmux/fzf if missing, stows the config into
# ~/.config/tmux, symlinks tmux-sessionizer onto PATH, and installs tpm +
# its plugins. Safe to re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=../lib/install-common.sh
source "$DOTFILES_DIR/lib/install-common.sh"

info "Setting up tmux..."

if command_exists tmux; then
	ok "tmux already installed ($(tmux -V))"
else
	require_brew
	info "Installing tmux..."
	brew install tmux
fi

if command_exists fzf; then
	ok "fzf already installed"
else
	require_brew
	info "Installing fzf (required by tmux-sessionizer and tmux-fzf)..."
	brew install fzf
fi

# ~/.tmux.conf takes priority over ~/.config/tmux/tmux.conf, so its mere
# presence would silently shadow the stowed config below.
if [ -L "$HOME/.tmux.conf" ]; then
	warn "Removing stray ~/.tmux.conf symlink so ~/.config/tmux/tmux.conf takes effect"
	rm "$HOME/.tmux.conf"
elif [ -e "$HOME/.tmux.conf" ]; then
	backup_if_conflict "$HOME/.tmux.conf"
fi

# Drop any pre-existing symlink at the target (e.g. a stale one from a prior,
# differently-structured setup) so stow starts from a clean slate.
if [ -L "$HOME/.config/tmux" ]; then
	rm "$HOME/.config/tmux"
elif [ -e "$HOME/.config/tmux" ]; then
	backup_if_conflict "$HOME/.config/tmux"
fi

info "Symlinking tmux config into ~/.config/tmux via stow..."
(cd "$DOTFILES_DIR" && stow --restow tmux)
ok "tmux config stowed"

mkdir -p "$HOME/.local/bin"
sessionizer_link="$HOME/.local/bin/tmux-sessionizer"
sessionizer_src="$DOTFILES_DIR/tmux/tmux/tmux-sessionizer"
if [ -L "$sessionizer_link" ] && [ "$(readlink "$sessionizer_link")" = "$sessionizer_src" ]; then
	ok "tmux-sessionizer already symlinked"
else
	backup_if_conflict "$sessionizer_link"
	ln -sf "$sessionizer_src" "$sessionizer_link"
	ok "Symlinked tmux-sessionizer -> ~/.local/bin"
fi

case ":$PATH:" in
*":$HOME/.local/bin:"*) ;;
*) warn "~/.local/bin is not on your PATH — add 'export PATH=\"\$HOME/.local/bin:\$PATH\"' to your shell rc" ;;
esac

tpm_dir="$HOME/.tmux/plugins/tpm"
if [ -d "$tpm_dir" ]; then
	ok "tpm already installed"
else
	info "Cloning tpm (tmux plugin manager)..."
	git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir"
fi

info "Installing tmux plugins..."
if "$tpm_dir/bin/install_plugins"; then
	ok "tmux plugins installed"
else
	warn "tpm reported an issue installing plugins — check the output above"
fi

ok "tmux setup complete. Start tmux and press 'prefix ?' for the cheatsheet."
