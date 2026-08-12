# Sourced once for login shells, before .zshrc. Typically PATH/env setup
# that only needs to happen once per login (e.g. Homebrew's shellenv).

# Source login-shell additions any tool's dotfiles package drops into
# ~/.config/zsh/zprofile.d/ (e.g. `brew shellenv`). See
# ~/.config/zsh/zprofile.d/README.md for the convention.
for _dotfiles_zprofile_frag in "$HOME/.config/zsh/zprofile.d"/*.zsh(N); do
	source "$_dotfiles_zprofile_frag"
done
unset _dotfiles_zprofile_frag
