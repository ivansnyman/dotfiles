alias ls='ls -a'

# Linux (WSL, Ubuntu, etc.)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Only source if file exists
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# Run oh-my-posh if installed (works on mac + WSL)
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh)"
fi

# zsh-autosuggestions (mac + WSL paths)
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
