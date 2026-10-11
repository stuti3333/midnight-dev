#!/usr/bin/env bash
set -e

# Midnight Dev: GNOME workspace configuration
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

for i in 1 2 3 4; do
    gsettings set org.gnome.desktop.wm.keybindings \
        "switch-to-workspace-$i" "['<Super>$i']"

    gsettings set org.gnome.desktop.wm.keybindings \
        "move-to-workspace-$i" "['<Super><Shift>$i']"
done

echo "Midnight Dev workspace shortcuts configured."
