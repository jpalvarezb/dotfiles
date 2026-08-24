# ─────────────────────────────────────────────────────────────
#  History
#  These used to come from oh-my-zsh. Set explicitly now.
# ─────────────────────────────────────────────────────────────
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY          # sync history across running shells
setopt HIST_IGNORE_ALL_DUPS   # drop older duplicates
setopt HIST_IGNORE_SPACE      # a leading space keeps a command out of history
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY       # record timestamps
setopt INTERACTIVE_COMMENTS   # allow # comments at the prompt

# ─────────────────────────────────────────────────────────────
#  Completion
# ─────────────────────────────────────────────────────────────
autoload -Uz compinit
# Regenerate the dump at most once a day; otherwise reuse it (faster startup).
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' menu select

# ─────────────────────────────────────────────────────────────
#  Environment
# ─────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="code --wait"
export BUNDLER_EDITOR="code --wait"
export HOMEBREW_NO_ANALYTICS=1
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.gcp/credentials.json"
export OLLAMA_ORIGINS="*"
export PYTHONBREAKPOINT=ipdb.set_trace  # needs ipdb in the project's .venv
# Claude Code uses /login + Claude Pro (no API keys stored here).

# ─────────────────────────────────────────────────────────────
#  Python — uv only. uv downloads and manages its own interpreters
#  under ~/.local/share/uv/python, so there is no version manager to
#  init here. pyenv was removed once every project .venv ran on uv.
#  Project tools go through `uv run <cmd>`; global ones via `uv tool`.
# ─────────────────────────────────────────────────────────────
. "$HOME/.local/bin/env"   # uv, uvx and other user-local binaries

# ─────────────────────────────────────────────────────────────
#  Node
# ─────────────────────────────────────────────────────────────
export PNPM_HOME="$HOME/Library/pnpm"
path=("$PNPM_HOME" $path)

# ─────────────────────────────────────────────────────────────
#  Google Cloud SDK
# ─────────────────────────────────────────────────────────────
[ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ] && . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'
[ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ] && . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'

# ─────────────────────────────────────────────────────────────
#  PATH — append sbin, then dedupe (typeset -U keeps first occurrence).
#
#  `./bin` and `./node_modules/.bin` are deliberately absent: relative
#  entries execute binaries out of whatever directory you stand in.
# ─────────────────────────────────────────────────────────────
path+=(/usr/local/sbin)
typeset -U path PATH

# ─────────────────────────────────────────────────────────────
#  Tools
# ─────────────────────────────────────────────────────────────
# Guarded so a missing tool degrades quietly instead of erroring at every prompt.
command -v direnv > /dev/null && eval "$(direnv hook zsh)"   # per-directory env
command -v zoxide > /dev/null && eval "$(zoxide init zsh)"   # `z <part>` jumps by frecency
command -v fzf    > /dev/null && source <(fzf --zsh)         # Ctrl-R history, Ctrl-T files

# ─────────────────────────────────────────────────────────────
#  Aliases — the rest live in dotfiles/aliases
# ─────────────────────────────────────────────────────────────
alias gc='git commit --verbose'   # the one oh-my-zsh alias actually used (202x)

# Modern replacements. The real binaries stay reachable as \ls, \cat, …
if command -v eza > /dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --group-directories-first --git'
  alias la='eza -la --group-directories-first --git'
  alias lt='eza --tree --level=2'
fi
command -v bat > /dev/null && alias cat='bat --paging=never'
command -v fd  > /dev/null && alias find='fd'
command -v rg  > /dev/null && alias grep='rg'

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# ─────────────────────────────────────────────────────────────
#  Prompt — config at ~/.config/starship.toml
# ─────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ─────────────────────────────────────────────────────────────
#  Zsh plugins. Order matters: syntax-highlighting must be sourced
#  near the end, and history-substring-search after it.
# ─────────────────────────────────────────────────────────────
for _p in zsh-syntax-highlighting zsh-history-substring-search; do
  [ -f "/opt/homebrew/share/$_p/$_p.zsh" ] && source "/opt/homebrew/share/$_p/$_p.zsh"
done
unset _p
bindkey '^[[A' history-substring-search-up      # ↑ searches by what you typed
bindkey '^[[B' history-substring-search-down    # ↓
