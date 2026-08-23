# ─────────────────────────────────────────────────────────────
#  Oh My Zsh
#  ZSH_THEME is empty on purpose: Starship (bottom of this file)
#  renders the prompt. Loading a theme here would just be overridden.
# ─────────────────────────────────────────────────────────────
ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search direnv)
ZSH_DISABLE_COMPFIX=true

source "${ZSH}/oh-my-zsh.sh"
unalias rm  # no interactive rm by default (comes from plugins/common-aliases)
unalias lt  # we need `lt` for https://github.com/localtunnel/localtunnel

# ─────────────────────────────────────────────────────────────
#  Environment
# ─────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=code
export BUNDLER_EDITOR=code
export HOMEBREW_NO_ANALYTICS=1
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.gcp/credentials.json"
export OLLAMA_ORIGINS="*"
export PYTHONBREAKPOINT=ipdb.set_trace  # needs ipdb in the project's .venv
# Claude Code uses /login + Claude Pro (no API keys stored here).

# ─────────────────────────────────────────────────────────────
#  Python — uv only. uv downloads and manages its own interpreters
#  (~/.local/share/uv/python), so there is no version manager to init
#  here. pyenv was removed once every project .venv was rebuilt on it.
# ─────────────────────────────────────────────────────────────
# uv, uvx, poetry and other user-local binaries
. "$HOME/.local/bin/env"

# ─────────────────────────────────────────────────────────────
#  Node
# ─────────────────────────────────────────────────────────────
export PNPM_HOME="$HOME/Library/pnpm"
path=("$PNPM_HOME" $path)

# ─────────────────────────────────────────────────────────────
#  Google Cloud SDK (path + completion)
# ─────────────────────────────────────────────────────────────
[ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ] && . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'
[ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ] && . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'

# ─────────────────────────────────────────────────────────────
#  PATH — append sbin, then dedupe (typeset -U keeps first occurrence).
#
#  NOTE: `./bin` and `./node_modules/.bin` were removed on purpose.
#  Relative entries in PATH execute binaries from whatever directory
#  you happen to be standing in. Use `npx` / `bin/rails` explicitly.
# ─────────────────────────────────────────────────────────────
path+=(/usr/local/sbin)
typeset -U path PATH

# ─────────────────────────────────────────────────────────────
#  Aliases — real file lives in dotfiles/aliases
# ─────────────────────────────────────────────────────────────
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# ─────────────────────────────────────────────────────────────
#  Starship prompt — config at ~/.config/starship.toml
# ─────────────────────────────────────────────────────────────
eval "$(starship init zsh)"
