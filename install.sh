#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN="$HOME/.local/bin"
DATA="$HOME/.local/share/midnight-dev"
MANIFEST="$DATA/install-manifest.tsv"
BACKUPS="$DATA/backups"

# Verify project directories.
if [[ ! -d "$ROOT/configs" || ! -d "$ROOT/scripts" || ! -d "$ROOT/wallpapers" ]]; then
    echo "Error: incomplete Midnight Dev project." >&2
    exit 1
fi

# Check required applications.
missing=()

for app in kitty fastfetch; do
    if ! command -v "$app" >/dev/null 2>&1; then
        missing+=("$app")
    fi
done

if ((${#missing[@]} > 0)); then
    echo "Error: missing required applications: ${missing[*]}" >&2
    echo "On Fedora, install them with:"
    echo "  sudo dnf install ${missing[*]}"
    exit 1
fi

mkdir -p "$BIN" "$DATA" "$BACKUPS"
touch "$MANIFEST"

# Track each target once and back up existing files.
track_target() {
    local target="$1"
    local backup

    if awk -F '\t' -v p="$target" '$2 == p { found=1 } END { exit !found }' "$MANIFEST"; then
        return
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        backup="$BACKUPS/$(date +%Y%m%d-%H%M%S)-$$-$(basename "$target")"
        cp -a -- "$target" "$backup"
        printf 'EXISTED\t%s\t%s\n' "$target" "$backup" >> "$MANIFEST"
    else
        printf 'CREATED\t%s\t-\n' "$target" >> "$MANIFEST"
    fi
}

# Install a file.
install_file() {
    local source="$1"
    local target="$2"

    if [[ ! -f "$source" ]]; then
        echo "Error: source file not found: $source" >&2
        return 1
    fi

    track_target "$target"
    mkdir -p "$(dirname "$target")"
    cp -- "$source" "$target"
}

echo "Installing Midnight Dev..."

install_file "$ROOT/configs/kitty/kitty.conf" \
    "$HOME/.config/kitty/kitty.conf"

install_file "$ROOT/configs/fastfetch/config.jsonc" \
    "$HOME/.config/fastfetch/config.jsonc"

install_file "$ROOT/configs/kitty/midnight-space.conf" \
    "$DATA/midnight-space.conf"

install_file "$ROOT/configs/kitty/midnight-violet.conf" \
    "$DATA/midnight-violet.conf"

install_file "$ROOT/configs/kitty/midnight-green.conf" \
    "$DATA/midnight-green.conf"

install_file "$ROOT/configs/kitty/midnight-space.conf" \
    "$DATA/current-theme.conf"

install_file "$ROOT/scripts/midnight-theme.sh" \
    "$BIN/midnight-theme"
chmod 755 "$BIN/midnight-theme"

for script in midnight-status.sh configure-workspaces.sh; do
    install_file "$ROOT/scripts/$script" "$BIN/$script"
    chmod 755 "$BIN/$script"
done

install_file "$ROOT/scripts/midnight-prompt.sh" \
    "$DATA/midnight-prompt.sh"

# Create the shell aliases file.
ALIASES="$DATA/midnight-aliases.sh"
track_target "$ALIASES"

cat > "$ALIASES" <<'ALIASES_EOF'
alias croot='cd "$(git rev-parse --show-toplevel 2>/dev/null || printf "%s" "$HOME")"'
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

# Add shell integration only once.
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

# Copy wallpapers without overwriting existing files.
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/Midnight-Dev"
mkdir -p "$WALLPAPER_DIR"

if compgen -G "$ROOT/wallpapers/*" >/dev/null; then
    cp -n -- "$ROOT"/wallpapers/* "$WALLPAPER_DIR/"
else
    echo "Warning: no wallpapers found in $ROOT/wallpapers" >&2
fi

echo
echo "Midnight Dev installation completed."
echo "Open a new Bash terminal or run: source ~/.bashrc"
echo "System status: midnight-status.sh"
echo "Optional GNOME workspace setup: $BIN/configure-workspaces.sh"
echo "Existing files are backed up under: $BACKUPS"
echo "Uninstall script: $ROOT/uninstall.sh"
echo "Note: wallpapers are intentionally retained after uninstall."
