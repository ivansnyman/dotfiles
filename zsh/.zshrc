alias ls='ls -a'

# Linux (WSL, Ubuntu, etc.)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  export PATH="$HOME/.local/bin:$PATH"

  # bun
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/ivan/.bun/_bun" ] && source "/Users/ivan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ivan/.lmstudio/bin"
# End of LM Studio CLI section

echo 'export PATH="$HOME/.docker/bin:$PATH"'

# Added by Antigravity CLI installer
export PATH="/Users/ivan/.local/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/ivan/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions

# Azure DevOps MCP server (PAT stored in macOS Keychain, service "azure-devops-pat")
export PERSONAL_ACCESS_TOKEN="$(printf '%s' "ivan.snyman@pepla.co.za:$(security find-generic-password -a "$USER" -s azure-devops-pat -w 2>/dev/null)" | base64)"

# .NET global tools (dotnet-ef, easydotnet, roslyn-language-server)
export PATH="$PATH:$HOME/.dotnet/tools"

# Pepla Voice .NET apps on macOS: use the local, git-excluded nlog.mac.config.
# Only set inside ~/work/pepla/voice so other .NET repos are not affected.
if [[ "$OSTYPE" == "darwin"* ]]; then
  _pepla_voice_env() {
    if [[ "$PWD" == "$HOME/work/pepla/voice"* ]]; then
      export NLog__ConfigurationFileName="nlog.mac.config"
      export NLogExt__InternalLogFile="$HOME/Logs/PeplaVoice/nlog-internal.log"
      # No local APM server; otherwise the agent logs a warning every few seconds.
      export ELASTIC_APM_ENABLED=false
      # Never run EF migrations against the shared dev DB from this machine.
      export DatabaseSettings__AutoMigrate=false
    else
      unset NLog__ConfigurationFileName NLogExt__InternalLogFile ELASTIC_APM_ENABLED DatabaseSettings__AutoMigrate
    fi
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _pepla_voice_env
  _pepla_voice_env
fi

# PostgreSQL 15 (Homebrew keg-only): psql/initdb/postgres on PATH.
# testing.postgresql in Python test suites needs initdb + postgres here.
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
fi

# Claude Code: work subscription uses its own config dir (personal = plain `claude`)
alias claude-work='CLAUDE_CONFIG_DIR="$HOME/.claude-work" claude'
