
#!/usr/bin/env bash
set -euo pipefail

DATA="$HOME/.local/share/midnight-dev"
MANIFEST="$DATA/install-manifest.tsv"
BACKUPS="$DATA/backups"

if [[ ! -f "$MANIFEST" ]]; then
    echo "Error: installation manifest not found at:" >&2
    echo "  $MANIFEST" >&2
    echo "Nothing was changed."
    exit 1
fi

# Validate every manifest entry before changing anything.
entry_count=0

while IFS=$'\t' read -r action target backup extra || [[ -n "${action:-}${target:-}${backup:-}${extra:-}" ]]; do
    [[ -n "${action:-}${target:-}${backup:-}${extra:-}" ]] || continue

    if [[ -n "${extra:-}" || -z "${target:-}" || -z "${backup:-}" ]]; then
        echo "Error: malformed manifest entry." >&2
        echo "Nothing was changed."
        exit 1
    fi

    if [[ "$target" != /* ]]; then
        echo "Error: target path must be absolute: $target" >&2
        exit 1
    fi

    case "$action" in
        EXISTED)
            if [[ "$backup" != /* || ( ! -f "$backup" && ! -L "$backup" ) ]]; then
                echo "Error: missing or invalid backup for: $target" >&2
                echo "Expected backup: $backup" >&2
                echo "Nothing was changed."
                exit 1
            fi
            ;;
        CREATED)
            if [[ "$backup" != "-" ]]; then
                echo "Error: invalid CREATED entry for: $target" >&2
                exit 1
            fi
            ;;
        *)
            echo "Error: unknown manifest action: $action" >&2
            exit 1
            ;;
    esac

    if [[ -d "$target" && ! -L "$target" ]]; then
        echo "Error: target is a directory; refusing to proceed: $target" >&2
        echo "Nothing was changed."
        exit 1
    fi

    ((entry_count += 1))
done < "$MANIFEST"

if ((entry_count == 0)); then
    echo "Error: manifest contains no valid entries." >&2
    echo "Nothing was changed."
    exit 1
fi

echo "Preflight passed: $entry_count manifest entries validated."
echo "Uninstalling Midnight Dev..."

# Remove only the marked shell integration block.
if [[ -f "$HOME/.bashrc" ]]; then
    sed -i \
        '/# >>> Midnight Dev >>>/,/# <<< Midnight Dev <<</d' \
        "$HOME/.bashrc"
fi

# Restore or remove tracked files in reverse installation order.
while IFS=$'\t' read -r action target backup; do
    [[ -n "${target:-}" ]] || continue

    case "$action" in
        EXISTED)
            rm -f -- "$target"
            mkdir -p "$(dirname "$target")"
            cp -a -- "$backup" "$target"
            printf 'Restored: %s\n' "$target"
            ;;
        CREATED)
            rm -f -- "$target"
            printf 'Removed: %s\n' "$target"
            ;;
    esac
done < <(tac "$MANIFEST")

# Remove the manifest only after restoration succeeds.
rm -- "$MANIFEST"

echo
echo "Midnight Dev uninstall completed."
echo "Backups remain under: $BACKUPS"
echo "Wallpapers are intentionally retained."
echo "Review GNOME shortcuts and wallpaper settings separately if needed."
