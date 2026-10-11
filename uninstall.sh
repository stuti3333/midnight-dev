#!/usr/bin/env bash
set -euo pipefail

DATA="$HOME/.local/share/midnight-dev"
BIN="$HOME/.local/bin"

if [[ -f "$HOME/.bashrc" ]] && grep -qF '# >>> Midnight Dev >>>' "$HOME/.bashrc"; then
    sed -i '/# >>> Midnight Dev >>>/,/# <<< Midnight Dev <<</d' "$HOME/.bashrc"
fi

rm -f "$BIN/midnight-status.sh" "$BIN/configure-workspaces.sh"
rm -f "$DATA/midnight-aliases.sh" "$DATA/midnight-prompt.sh"

# Restore the most recent saved versions of installed configuration files.
if [[ -f "$DATA/backups.log" ]]; then
    tac "$DATA/backups.log" | while IFS=$'\t' read -r target backup; do
        [[ -n "$target" && -n "$backup" ]] || continue
        if [[ -e "$backup" || -L "$backup" ]]; then
            mkdir -p "$(dirname "$target")"
            cp -a "$backup" "$target"
        fi
    done
fi

echo "Midnight Dev shell integration and scripts removed."
echo "Backup files remain in: $DATA/backups"
echo "Review Kitty/Fastfetch configs and wallpapers if you want to remove them."
