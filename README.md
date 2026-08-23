# dotfiles

Config for a macOS terminal setup, symlinked into place from this repo.

Clone to `~/.dotfiles` and run `./install.sh`. It backs up any real file
it is about to replace (as `<file>.backup`) and skips anything already
symlinked, so it is safe to re-run — which is also how you repair a
symlink that some tool replaced with a real file.

## What it manages

| File | Symlinked to |
|---|---|
| `zshrc`, `zprofile`, `aliases` | `~/.zshrc`, `~/.zprofile`, `~/.aliases` |
| `gitconfig` | `~/.gitconfig` |
| `starship.toml` | `~/.config/starship.toml` |
| `ghostty/config` | `~/.config/ghostty/config` |
| `tmux.conf` | `~/.tmux.conf` |
| `config` | `~/.ssh/config` |
| `claude/` | `~/.claude/` (settings, CLAUDE.md, statusline) |
| `settings.json`, `keybindings.json` | VS Code's `User/` directory |

## Toolset

- **Shell:** plain zsh — no framework. Plugins (`zsh-syntax-highlighting`,
  `zsh-history-substring-search`) come from Homebrew.
- **Prompt:** [Starship](https://starship.rs)
- **Terminal:** [Ghostty](https://ghostty.org)
- **Multiplexer:** tmux — `ccgrid` opens a 4-pane grid for parallel
  Claude Code sessions
- **Python:** [uv](https://docs.astral.sh/uv/) only. No pyenv; uv manages
  its own interpreters.
- **CLI:** zoxide, eza, bat, fd, ripgrep, fzf, delta

Note that `find` and `grep` are aliased to `fd` and `rg`, whose flags are
not POSIX-compatible. Prefix with `\` to reach the originals.

## Requirements

```sh
brew install starship tmux zoxide eza bat fd ripgrep fzf git-delta \
             zsh-syntax-highlighting zsh-history-substring-search direnv
```

Originally forked from [lewagon/dotfiles](https://github.com/lewagon/dotfiles);
none of the bootcamp scaffolding remains.
