# zshenv.d

Any `*.zsh` file dropped here is sourced by `~/.zshenv`, in filename order,
for **every** zsh invocation — interactive, non-interactive, and scripts.
Keep fragments fast and side-effect-light: `PATH` entries and exported env
vars only. For aliases, completions, or anything that depends on
oh-my-zsh/plugins, use `../zshrc.d/` instead.

## Adding a fragment from another tool's package

A tool's own dotfiles package can contribute a fragment here without
touching the `zsh/` package, by adding a file at:

```
dotfiles/<tool>/zsh/zshenv.d/<tool>.zsh
```

Stow's default target is `~/.config` (see `.stowrc`), so
`<tool>/zsh/zshenv.d/<tool>.zsh` lands at `~/.config/zsh/zshenv.d/<tool>.zsh`
once that tool's `install.sh` stows its package — no `--target` override
needed. See `tmux/zsh/zshenv.d/tmux.zsh` for a working example.
