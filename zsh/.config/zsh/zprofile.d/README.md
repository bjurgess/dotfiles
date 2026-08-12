# zprofile.d

Any `*.zsh` file dropped here is sourced by `~/.zprofile`, in filename
order, once per login shell (before `~/.zshrc`). Use this for setup that
only needs to run once per login — most commonly `eval "$(brew shellenv)"`
and similar PATH/env bootstrapping. For per-shell `PATH`/env vars (including
non-interactive and scripts), use `../zshenv.d/` instead; for interactive
tweaks (aliases, completions), use `../zshrc.d/`.

## Adding a fragment from another tool's package

A tool's own dotfiles package can contribute a fragment here without
touching the `zsh/` package, by adding a file at:

```
dotfiles/<tool>/zsh/zprofile.d/<tool>.zsh
```

Stow's default target is `~/.config` (see `.stowrc`), so
`<tool>/zsh/zprofile.d/<tool>.zsh` lands at
`~/.config/zsh/zprofile.d/<tool>.zsh` once that tool's `install.sh` stows
its package — no `--target` override needed. `zprofile.d/homebrew.zsh`
(shipped by the `zsh` package itself, since Homebrew is a base dependency
rather than its own tool package) is a working example.
