# Midnight Developer Desktop shortcuts

alias croot='cd ~/Projects/midnight-dev'
alias gs='git status'
alias gl='git log --oneline --graph --decorate -10'
alias sysinfo='~/Projects/midnight-dev/scripts/midnight-status.sh'
alias update='sudo dnf upgrade --refresh'
alias ports='ss -tuln'
alias cls='clear'

if command -v btop >/dev/null 2>&1; then
    alias monitor='btop'
fi
