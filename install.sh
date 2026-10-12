#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN="$HOME/.local/bin"
DATA="$HOME/.local/share/midnight-dev"
MANIFEST="$DATA/install-manifest.tsv"
BACKUPS="$DATA/backups"

[[ -d "$ROOT/configs" && -d "$ROOT/scripts" && -d "$ROOT/wallpapers" ]] || {
    echo "Error: incomplete Midnight Dev project."
    exit 1
}

mkdir -p "$BIN" "$DATA" "$BACKUPS"
touch "$MANIFEST"

track_target() {
    local target="$1"
    local backup

    if awk -F '\t' -v p="$target" '$2 == p { found=1 } END { exit !found }' "$MANIFEST"; then
        return
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        backup="$BACKUPS/$(date +%Y%m%d-%H%M%S)-$$-$(basename "$target")"
        cp -a "$target" "$backup"
        printf 'EXISTED\t%s\t%s\n' "$target" "$backup" >> "$MANIFEST"
    else
        printf 'CREATED\t%s\t-\n' "$target" >> "$MANIFEST"
    fi
}

install_file() {
    local source="$1" target="$2"
    track_target "$target"
    mkdir -p "$(dirname "$target")"
    cp "$source" "$target"
}

echo "Installing Midnight Dev..."

install_file "$ROOT/configs/kitty/kitty.conf" \
    "$HOME/.config/kitty/kitty.conf"

install_file "$ROOT/configs/fastfetch/config.jsonc" \
    "$HOME/.config/fastfetch/config.jsonc"

install_file "$ROOT/configs/kitty/midnight-space.conf" "$DATA/midnight-space.conf"
install_file "$ROOT/configs/kitty/midnight-violet.conf" "$DATA/midnight-violet.conf"
install_file "$ROOT/configs/kitty/midnight-green.conf" "$DATA/midnight-green.conf"
install_file "$ROOT/configs/kitty/midnight-space.conf" "$DATA/current-theme.conf"

install_file "$ROOT/scripts/midnight-theme.sh" "$BIN/midnight-theme"
chmod 755 "$BIN/midnight-theme"

for script in midnight-status.sh configure-workspaces.sh; do
    install_file "$ROOT/scripts/$script" "$BIN/$script"
    chmod 755 "$BIN/$script"
done

install_file "$ROOT/scripts/midnight-prompt.sh" \
    "$DATA/midnight-prompt.sh"

ALIASES="$DATA/midnight-aliases.sh"
track_target "$ALIASES"
cat > "$ALIASES" <<'ALIASES_EOF'
alias croot='cd "$HOME/Projects/midnight-dev"'
alias gs='git status'
alias gl='git log --oneline --graph --decorate -10'
alias sysinfo='midnight-status.sh'
alias update='sudo dnf upgrade --refresh'
alias ports='ss -tuln'
alias cls='clear'
if command -v btop >/dev/null 2>&1; then
    alias monitor='btop'
fi
ALIASES_EOF

touch "$HOME/.bashrc"
if ! grep -qF '# >>> Midnight Dev >>>' "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" <<'BASHRC_EOF'

# >>> Midnight Dev >>>
if [[ $- == *i* ]]; then
    [[ -f "$HOME/.local/share/midnight-dev/midnight-aliases.sh" ]] &&
        source "$HOME/.local/share/midnight-dev/midnight-aliases.sh"
    [[ -f "$HOME/.local/share/midnight-dev/midnight-prompt.sh" ]] &&
        source "$HOME/.local/share/midnight-dev/midnight-prompt.sh"
fi
# <<< Midnight Dev <<<
BASHRC_EOF
fi

mkdir -p "$HOME/Pictures/Wallpapers/Midnight-Dev"
cp -n "$ROOT"/wallpapers/* "$HOME/Pictures/Wallpapers/Midnight-Dev/" 2>/dev/null || true

echo
echo "Midnight Dev installed."
echo "Open a new Bash terminal or run: source ~/.bashrc"
echo "System status: midnight-status.sh"
echo "Optional GNOME workspace setup: $BIN/configure-workspaces.sh"
echo "Existing files are backed up under: $BACKUPS"
echo "Uninstall with: $ROOT/uninstall.sh"
echo "Note: wallpapers are intentionally retained after uninstall."
