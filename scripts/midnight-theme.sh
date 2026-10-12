
#!/usr/bin/env bash
set -euo pipefail

THEME="${1:-}"
DATA="$HOME/.local/share/midnight-dev"
WALLPAPERS="$HOME/Pictures/Wallpapers/Midnight-Dev"
KITTY="$HOME/.config/kitty/kitty.conf"

case "$THEME" in
  space)
    WALLPAPER="$WALLPAPERS/midnight-space.png"
    PALETTE="$DATA/midnight-space.conf"
    ;;
  violet)
    WALLPAPER="$WALLPAPERS/midnight-violet.png"
    PALETTE="$DATA/midnight-violet.conf"
    ;;
  green)
    WALLPAPER="$WALLPAPERS/midnight-green.png"
    PALETTE="$DATA/midnight-green.conf"
    ;;
  *)
    echo "Usage: midnight-theme {space|violet|green}"
    exit 2
    ;;
esac

if [[ ! -f "$WALLPAPER" || ! -f "$PALETTE" ]]; then
  echo "Theme files are missing. Check the wallpaper and palette paths."
  exit 1
fi

mkdir -p "$DATA" "$(dirname "$KITTY")"
cp "$PALETTE" "$DATA/current-theme.conf"

if ! grep -qF 'include ~/.local/share/midnight-dev/current-theme.conf' "$KITTY"; then
  printf '\n# Midnight Dev dynamic theme\ninclude ~/.local/share/midnight-dev/current-theme.conf\n' >> "$KITTY"
fi

URI="file://$WALLPAPER"
gsettings set org.gnome.desktop.background picture-uri "$URI"

if gsettings list-keys org.gnome.desktop.background | grep -qx picture-uri-dark; then
  gsettings set org.gnome.desktop.background picture-uri-dark "$URI"
fi

gsettings set org.gnome.desktop.interface color-scheme prefer-dark

echo "Midnight Dev theme changed to: $THEME"
echo "Open a new Kitty window to apply the terminal colors."

