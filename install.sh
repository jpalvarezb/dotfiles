#!/bin/zsh

# Define a function which rename a `target` file to `target.backup` if the file
# exists and if it's a 'real' file, ie not a symlink
backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinking your new $link"
    ln -s $file $link
  fi
}

# Symlink the shell config files to ~/.$name (backing up any real file first).

for name in aliases gitconfig zprofile zshrc; do
  if [ ! -d "$name" ]; then
    target="$HOME/.$name"
    backup $target
    symlink $PWD/$name $target
  fi
done

# Install everything in the Brewfile: CLI tools, casks and taps.
# Without this, install.sh would symlink configs pointing at tools that
# are not on the machine. Regenerate with `brew bundle dump --force`.
if command -v brew > /dev/null; then
  echo "-----> Installing Homebrew packages from Brewfile (this takes a while)"
  brew bundle --file="$PWD/Brewfile"
else
  echo "-----> Homebrew not found. Install it first: https://brew.sh"
fi

# zsh plugins come from Homebrew now (see zshrc), not from oh-my-zsh custom/.

# Symlink VS Code settings and keybindings to the present `settings.json` and `keybindings.json` files
# If it's a macOS
if [[ `uname` =~ "Darwin" ]]; then
  CODE_PATH=~/Library/Application\ Support/Code/User
# Else, it's a Linux
else
  CODE_PATH=~/.config/Code/User
  # If this folder doesn't exist, it's a WSL
  if [ ! -e $CODE_PATH ]; then
    CODE_PATH=~/.vscode-server/data/Machine
  fi
fi

for name in settings.json keybindings.json; do
  target="$CODE_PATH/$name"
  backup $target
  symlink $PWD/$name $target
done

# Symlink SSH config file to the present `config` file for macOS and add SSH passphrase to the keychain
if [[ `uname` =~ "Darwin" ]]; then
  target=~/.ssh/config
  backup $target
  symlink $PWD/config $target
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
fi

# Symlink the modern terminal config: Starship prompt, Ghostty, tmux.
# These used to be created by hand — install.sh now reproduces them.
mkdir -p ~/.config ~/.config/ghostty
backup ~/.config/starship.toml   && symlink $PWD/starship.toml   ~/.config/starship.toml
backup ~/.config/ghostty/config  && symlink $PWD/ghostty/config  ~/.config/ghostty/config
backup ~/.tmux.conf              && symlink $PWD/tmux.conf       ~/.tmux.conf

# Symlink Claude Code config. Claude may rewrite ~/.claude/settings.json when
# you change a setting via /config; if that ever replaces the symlink with a
# real file, re-running this script restores it (the old file is kept as .backup).
mkdir -p ~/.claude
for name in settings.json CLAUDE.md statusline-command.sh; do
  target="$HOME/.claude/$name"
  backup $target
  symlink $PWD/claude/$name $target
done

# Install the weekly setup health check. `doctor` audits the things that have
# silently rotted before: caches growing without bound, a .venv drifting off uv,
# a removed version manager creeping back, .env files getting committed.
mkdir -p ~/Library/LaunchAgents
cp -f "$PWD/launchd/com.jpalvarez.setup-doctor.plist" ~/Library/LaunchAgents/
launchctl unload ~/Library/LaunchAgents/com.jpalvarez.setup-doctor.plist 2> /dev/null
launchctl load ~/Library/LaunchAgents/com.jpalvarez.setup-doctor.plist
echo "-----> Weekly setup doctor installed (Mondays 10:00). Run it anytime with: doctor"

# Refresh the current terminal with the newly installed configuration
exec zsh

echo "👌 Carry on with git setup!"
