# zshrc.d

Any `*.zsh` file dropped here is sourced by `~/.zshrc`, in filename order,
after oh-my-zsh and its plugins load. Use this for **interactive-shell**
additions: aliases, completions, prompt tweaks, anything that depends on
oh-my-zsh already being set up.

For env vars and `PATH` entries that also need to reach non-interactive/
script shells, use `../zshenv.d/` instead.

## Adding a fragment from another tool's package

A tool's own dotfiles package can contribute a fragment here without
touching the `zsh/` package, by adding a file at:

```
dotfiles/<tool>/zsh/zshrc.d/<tool>.zsh
```

Stow's default target is `~/.config` (see `.stowrc`), so
`<tool>/zsh/zshrc.d/<tool>.zsh` lands at `~/.config/zsh/zshrc.d/<tool>.zsh`
once that tool's `install.sh` stows its package — no `--target` override
needed. See `tmux/zsh/zshenv.d/tmux.zsh` for a working example (env-side,
same idea).
