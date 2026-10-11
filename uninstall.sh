#!/usr/bin/env bash
set -euo pipefail

DATA="$HOME/.local/share/midnight-dev"
BIN="$HOME/.local/bin"
MANIFEST="$DATA/install-manifest.tsv"

if [[ -f "$HOME/.bashrc" ]]; then
    sed -i \
        '/# >>> Midnight Dev >>>/,/# <<< Midnight Dev <<</d' \
        "$HOME/.bashrc"
fi

if [[ -f "$MANIFEST" ]]; then
    while IFS=$'\t' read -r action target backup; do
        [[ -n "${target:-}" ]] || continue

        case "$action" in
            EXISTED)
                if [[ -e "$backup" || -L "$backup" ]]; then
                    rm -f -- "$target"
                    mkdir -p "$(dirname "$target")"
                    cp -a "$backup" "$target"
                    printf 'Restored: %s\n' "$target"
                else
                    echo "Warning: backup missing for $target" >&2
                fi
                ;;
            CREATED)
                rm -f -- "$target"
                printf 'Removed: %s\n' "$target"
                ;;
        esac
    done < <(tac "$MANIFEST")
    rm -f "$MANIFEST"
fi

rm -f "$DATA/midnight-aliases.sh" "$DATA/midnight-prompt.sh"
rmdir "$DATA" 2>/dev/null || true

echo
echo "Midnight Dev shell integration and tracked files removed."
echo "Backups, if any, remain under: $DATA/backups"
echo "Wallpapers are intentionally retained."
echo "Review your GNOME shortcuts and wallpaper separately if desired."
