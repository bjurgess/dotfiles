#!/usr/bin/env bash
# Sets up zsh: clones oh-my-zsh and the Powerlevel10k theme if missing, stows
# .zshrc/.p10k.zsh into $HOME. Safe to re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=../lib/install-common.sh
source "$DOTFILES_DIR/lib/install-common.sh"

info "Setting up zsh..."

omz_dir="$HOME/.oh-my-zsh"
if [ -d "$omz_dir" ]; then
	ok "oh-my-zsh already installed"
else
	info "Cloning oh-my-zsh..."
	git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir"
fi

p10k_dir="$omz_dir/custom/themes/powerlevel10k"
if [ -d "$p10k_dir" ]; then
	ok "Powerlevel10k already installed"
else
	info "Cloning Powerlevel10k theme..."
	git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
fi

# Drop any pre-existing symlink at the targets (e.g. stale from a prior,
# differently-structured setup) so stow starts from a clean slate; back up
# any real pre-existing file instead of clobbering it.
for f in "$HOME/.zshrc" "$HOME/.p10k.zsh"; do
	if [ -L "$f" ]; then
		rm "$f"
	elif [ -e "$f" ]; then
		backup_if_conflict "$f"
	fi
done

# This package's files (.zshrc, .p10k.zsh) belong directly at $HOME, unlike
# the ~/.config-relative layout the other packages use — so it needs its own
# --target, overriding the repo-wide default in .stowrc.
info "Symlinking zsh config into \$HOME via stow..."
(cd "$DOTFILES_DIR" && stow --target="$HOME" --restow zsh)
ok "zsh config stowed"

ok "zsh setup complete. Restart your terminal, then run 'p10k configure' to tune the prompt."
warn "Powerlevel10k needs a Nerd Font for icons to render — install the font-meslo-lg-nerd-font cask (via Brewfile) and set it as your terminal's font."
