#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN="$HOME/.local/bin"
DATA="$HOME/.local/share/midnight-dev"
CONFIG="$HOME/.config"
BACKUP="$DATA/backups/$(date +%Y%m%d-%H%M%S)"

if [[ ! -d "$ROOT/scripts" || ! -d "$ROOT/configs" ]]; then
    echo "Error: run this installer from the Midnight Dev project package."
    exit 1
fi

mkdir -p "$BIN" "$DATA" "$CONFIG" "$BACKUP"
touch "$DATA/backups.log"

backup_file() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP$(dirname "$target")"
        cp -a "$target" "$BACKUP$target"
        printf '%s\t%s\n' "$target" "$BACKUP$target" >> "$DATA/backups.log"
    fi
}

install_config() {
    local source="$1" target="$2"
    mkdir -p "$(dirname "$target")"
    backup_file "$target"
    cp -a "$source" "$target"
}

echo "Installing Midnight Dev for your user..."

install_config "$ROOT/configs/kitty/kitty.conf" \
    "$CONFIG/kitty/kitty.conf"
install_config "$ROOT/configs/fastfetch/config.jsonc" \
    "$CONFIG/fastfetch/config.jsonc"

for script in midnight-status.sh configure-workspaces.sh; do
    install -m 755 "$ROOT/scripts/$script" "$BIN/$script"
done

cat > "$DATA/midnight-aliases.sh" <<'ALIASES'
alias gs='git status'
alias gl='git log --oneline --graph --decorate -10'
alias sysinfo='midnight-status.sh'
alias update='sudo dnf upgrade --refresh'
alias ports='ss -tuln'
alias cls='clear'
alias croot='cd "$HOME"'
if command -v btop >/dev/null 2>&1; then
    alias monitor='btop'
fi
ALIASES

install -m 644 "$ROOT/scripts/midnight-prompt.sh" \
    "$DATA/midnight-prompt.sh"

if ! grep -qF '# >>> Midnight Dev >>>' "$HOME/.bashrc" 2>/dev/null; then
    touch "$HOME/.bashrc"
    backup_file "$HOME/.bashrc"
    cat >> "$HOME/.bashrc" <<'BASHRC'

# >>> Midnight Dev >>>
if [[ $- == *i* ]]; then
    [[ -f "$HOME/.local/share/midnight-dev/midnight-aliases.sh" ]] &&
        source "$HOME/.local/share/midnight-dev/midnight-aliases.sh"
    [[ -f "$HOME/.local/share/midnight-dev/midnight-prompt.sh" ]] &&
        source "$HOME/.local/share/midnight-dev/midnight-prompt.sh"
fi
# <<< Midnight Dev <<<
BASHRC
fi

mkdir -p "$HOME/Pictures/Wallpapers/Midnight-Dev"
cp -n "$ROOT"/wallpapers/* "$HOME/Pictures/Wallpapers/Midnight-Dev/" 2>/dev/null || true

echo
echo "Midnight Dev installed."
echo "Scripts: $BIN"
echo "Kitty/Fastfetch configs installed."
echo "Wallpapers: $HOME/Pictures/Wallpapers/Midnight-Dev"
echo
echo "Open a new terminal or run: source ~/.bashrc"
echo "GNOME workspace shortcuts are optional:"
echo "  $BIN/configure-workspaces.sh"
echo "Uninstall: $ROOT/uninstall.sh"
