# dotfiles

Personal macOS dotfiles and tool configuration. Goal: a new machine goes from
`git clone` to a fully configured terminal environment with one command, and
every machine stays identical.

## Install (new machine)

```sh
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh
```

Homebrew doesn't need to be preinstalled — `install.sh` installs it
automatically if it's missing.

`install.sh` is safe to re-run any time — every step checks what's already in
place before touching anything (installed packages are skipped, existing
correct symlinks are left alone, and any real pre-existing config it would
overwrite gets backed up to `<path>.bak.<timestamp>` first, never deleted
outright).

It:
1. Installs Homebrew (`lib/install-common.sh`'s `require_brew`) if missing.
2. Installs every CLI tool + cask declared in `Brewfile` (`brew bundle`).
3. Installs `stow` if missing.
4. Runs `tmux/install.sh`.
5. Runs `ghostty/install.sh`.
6. Runs `nvim/install.sh`.
7. Runs `zsh/install.sh`.

Each tool's script can also be run standalone (`./tmux/install.sh`,
`./ghostty/install.sh`, `./nvim/install.sh`, `./zsh/install.sh`) if you only
need to (re)set up that one thing.

## Layout

```
dotfiles/
├── install.sh          # top-level installer, calls the two below
├── lib/
│   └── install-common.sh   # shared shell helpers (logging, backup-on-conflict)
├── Brewfile             # all CLI tools + casks, installed via `brew bundle`
├── tmux/
│   ├── install.sh        # tmux-specific setup (not stowed)
│   ├── .stow-local-ignore # excludes install.sh from being stowed
│   └── tmux/              # stowed as a whole -> ~/.config/tmux
│       ├── tmux.conf
│       ├── cheatsheet.md
│       └── tmux-sessionizer
├── ghostty/
│   ├── install.sh
│   ├── .stow-local-ignore
│   └── ghostty/            # stowed as a whole -> ~/.config/ghostty
│       ├── config
│       └── themes/
└── zsh/
    ├── install.sh
    ├── .stow-local-ignore
    ├── .zshrc                # -> ~/.zshrc (stow --target="$HOME")
    └── .p10k.zsh             # -> ~/.p10k.zsh
```

`zsh/`, like `nvim/`, overrides stow's default target: `.zshrc` and
`.p10k.zsh` belong directly at `$HOME`, not `~/.config`, so its files sit
flat in the package directory (no nested `zsh/zsh/`) and its `install.sh`
runs `stow --target="$HOME"`.

Packages are managed with [GNU Stow](https://www.gnu.org/software/stow/).
`.stowrc` sets the default target to `~/.config`. Stow mirrors a package
directory's contents directly under the target — it does **not** nest by
package name — so each package contains a subdirectory matching its own name
(`tmux/tmux/`, `ghostty/ghostty/`) to land at `~/.config/tmux/`,
`~/.config/ghostty/`. `install.sh` sits one level up, outside that nested
dir, and `.stow-local-ignore` excludes it explicitly so stow never tries to
symlink it into `~/.config`.

`~/.tmux.conf` must **not** exist on the machine — tmux only falls back to
`~/.config/tmux/tmux.conf` (the stowed file) when there's no `~/.tmux.conf`
in the way. `tmux/install.sh` removes a stray one if it finds it.

## tmux

- Prefix is `C-a`.
- Full keybinding reference: [`tmux/tmux/cheatsheet.md`](tmux/tmux/cheatsheet.md),
  or press `prefix ?` inside any tmux session to pop it up without leaving
  the terminal.
- `tmux-sessionizer` (bound to `prefix f`) is an fzf-driven picker that jumps
  between project directories as tmux sessions, creating one if it doesn't
  exist yet. `tmux/install.sh` symlinks it into `~/.local/bin`.
- Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm), declared
  at the bottom of `tmux.conf`, and installed to `~/.config/tmux/plugins/`
  (gitignored — reproducible via `tmux/install.sh`, not committed).
  `prefix I` installs new ones, `prefix U` updates.

## Ghostty

- `config` — font size, window behavior, keybinds.
- `themes/catppuccin-mocha.conf` — color theme, referenced from `config`.

## Zsh

- Shell framework is [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh), themed
  with [Powerlevel10k](https://github.com/romkatv/powerlevel10k).
- Enabled plugins: `git`, `fzf`, `macos`.
- `~/.oh-my-zsh` and the Powerlevel10k theme are cloned by `zsh/install.sh`
  (gitignored — reproducible, not committed), the same way TPM is handled
  for tmux.
- After the first install, run `p10k configure` in a new shell to tune the
  prompt interactively; it regenerates `~/.p10k.zsh`. Copy that back into
  `zsh/.p10k.zsh` and commit it if you want the tuned prompt to follow you
  across machines.
- Icons need a Nerd Font — `zsh/install.sh` reminds you to install the
  `font-meslo-lg-nerd-font` cask (declared in `Brewfile`) and set it as your
  terminal's font.

## Brewfile

Every CLI tool this setup depends on (`fzf`, `bat`, `git-delta`, `fd`,
`ctags`, `tmux`, `stow`, etc.), the `ghostty` cask, and the
`font-meslo-lg-nerd-font` cask are declared in `Brewfile`. Add new tools
there rather than installing ad hoc — `install.sh` runs `brew bundle` on
every invocation, so anything listed there is guaranteed present on any
machine that runs the installer.

## Adding a new tool's config

1. Create `dotfiles/<tool>/<tool>/` containing exactly what should appear
   under `~/.config/<tool>/`.
2. Add an `install.sh` next to it (see `tmux/install.sh` for the pattern:
   source `lib/install-common.sh`, install the package if missing, stow the
   nested config dir) and a matching `.stow-local-ignore` excluding it.
3. Add any CLI dependency to `Brewfile`.
4. Call the new script from the top-level `install.sh`.
5. Document non-obvious keybindings or setup steps in a cheatsheet alongside
   the config, the way `tmux/tmux/cheatsheet.md` does.
