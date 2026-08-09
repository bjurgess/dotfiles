# tmux cheatsheet

Prefix key is `C-a` (Ctrl+a), remapped from the default `C-b`.
Below, `prefix` always means "press Ctrl+a, release, then press the next key."

## Sessions

| Command                          | Action                                  |
|-----------------------------------|------------------------------------------|
| `tmux`                            | start a new session                     |
| `tmux new -s NAME`                | start a new named session               |
| `tmux ls`                         | list sessions                           |
| `tmux attach -t NAME`             | attach to a session                     |
| `tmux kill-session -t NAME`       | kill a session                          |
| `prefix f`                        | fuzzy-find a project dir and jump to a session for it (tmux-sessionizer) |
| `prefix d`                        | detach from session                     |
| `prefix S`                        | list/switch sessions interactively (capital S — lowercase s is the stacked-split binding) |
| `prefix $`                        | rename current session                  |
| `prefix F`                        | tmux-fzf launcher: sessions/windows/panes/commands from one fuzzy menu |

## Windows (tabs)

| Command       | Action                        |
|---------------|--------------------------------|
| `prefix c`    | new window (opens in current pane's path) |
| `prefix ,`    | rename current window          |
| `prefix &`    | kill current window (confirm)  |
| `prefix n`    | next window                    |
| `prefix p`    | previous window                |
| `prefix 0-9`  | jump to window by number       |
| `prefix w`    | list windows interactively     |

## Panes (splits)

| Command        | Action                                          |
|----------------|--------------------------------------------------|
| `prefix v`     | split pane vertically (side by side)             |
| `prefix s`     | split pane stacked (top/bottom)                  |
| `prefix h/j/k/l` | move to pane left/down/up/right (vim-style)    |
| `prefix H/J/K/L` | resize pane left/down/up/right (repeatable)    |
| `prefix z`     | zoom/unzoom current pane (fullscreen toggle)     |
| `prefix x`     | kill current pane (confirm)                      |
| `prefix {` / `}` | swap pane with previous/next                  |
| `prefix q`     | briefly show pane numbers                        |
| mouse click    | switch pane                                      |
| mouse drag border | resize pane                                   |
| mouse scroll   | scroll pane history / enter copy mode            |

With **vim-tmux-navigator** installed, `C-h/j/k/l` (no prefix) move between tmux panes *and* vim splits seamlessly — the plugin figures out whether you're at a pane edge and needs tmux, or should stay inside vim.

Each pane's border shows its index and the currently running command, and the active pane's border is highlighted green.

## Copy mode (scrollback / clipboard)

| Command          | Action                              |
|-------------------|--------------------------------------|
| `prefix [`        | enter copy mode (scroll with arrows/mouse) |
| `q`                | exit copy mode                      |
| `space`            | start selection (in copy mode)      |
| `enter` / `y`      | copy selection to the **macOS system clipboard** (tmux-yank) and exit |
| `prefix ]`         | paste last copied text              |
| `g` / `G`          | jump to top / bottom of scrollback (vi-style, in copy mode) |
| `/` then text      | search forward in scrollback        |
| `o` (on a selected URL/path) | open it (browser or `$EDITOR`) — tmux-open |
| `S` (on a selected string) | search it in the browser — tmux-open |

## Config

| Command      | Action                                          |
|--------------|---------------------------------------------------|
| `prefix r`   | reload `~/.config/tmux/tmux.conf` without restarting |

## Plugins (TPM)

Plugin manager lives at `~/.tmux/plugins/tpm`, configured in `~/.config/tmux/tmux.conf`.

| Command      | Action                                  |
|--------------|-------------------------------------------|
| `prefix I`   | (capital i) install new plugins listed in `tmux.conf` |
| `prefix U`   | update installed plugins                |
| `prefix alt+u` | uninstall plugins removed from config |

Installed plugins:
- **tmux-sensible** — sane baseline defaults
- **tmux-resurrect** — save/restore pane contents and layout (`prefix C-s` save, `prefix C-r` restore)
- **tmux-continuum** — auto-saves session state every few minutes and auto-restores tmux-resurrect state on tmux start
- **vim-tmux-navigator** — unified `C-h/j/k/l` pane navigation between tmux and vim
- **tmux-yank** — copy-mode selections go to the real macOS clipboard, not just tmux's internal buffer
- **tmux-fzf** — fzf popup (`prefix F`) for sessions/windows/panes/layouts/plugins
- **tmux-open** — open (`o`) or search (`S`) a selected URL/path from copy mode
- **catppuccin/tmux** — status bar theme, right side shows date/time

## tmux-sessionizer

Script: `~/dotfiles/tmux/tmux-sessionizer` (symlinked to `~/.local/bin/tmux-sessionizer`), bound to `prefix f`.

Opens an fzf picker over directories 2 levels deep under `~/workspace` and `~`. Selecting one creates (or switches to, if it already exists) a tmux session named after that directory. Fast way to jump between projects without manually naming/creating sessions.

## Quick reference: most-used

- `prefix f` — jump to a project
- `prefix F` — fzf launcher (sessions/windows/panes)
- `prefix v` / `prefix s` — split pane (v = side by side, s = stacked)
- `prefix h/j/k/l` — move between panes
- `prefix z` — zoom pane
- `prefix c` — new window
- `prefix d` — detach
- `prefix r` — reload config
- `prefix ?` — this cheatsheet
