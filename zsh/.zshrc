alias ls='ls -a'
. "$HOME/.local/bin/env"

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
eval "$(oh-my-posh init zsh)"
fi
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
