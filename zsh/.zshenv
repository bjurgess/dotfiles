# Sourced for every zsh invocation (interactive, non-interactive, scripts).
# Keep this fast and side-effect-light — env vars and PATH only.

# Source env additions any tool's dotfiles package drops into
# ~/.config/zsh/zshenv.d/ (e.g. PATH entries, exported env vars). See
# ~/.config/zsh/zshenv.d/README.md for the convention.
for _dotfiles_zshenv_frag in "$HOME/.config/zsh/zshenv.d"/*.zsh(N); do
	source "$_dotfiles_zshenv_frag"
done
unset _dotfiles_zshenv_frag
