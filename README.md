
# Midnight Dev

**A keyboard-driven, visually consistent Linux developer workstation built on Fedora, GNOME, and Kitty.**

Midnight Dev brings terminal customization, desktop theming, workspace shortcuts, system monitoring, and reusable setup scripts into one project.

## Features

- Three coordinated themes: Midnight Space, Midnight Violet, and Midnight Green
- Dynamic wallpaper and Kitty terminal palette switching
- Customized Kitty terminal and Fastfetch configuration
- Bash prompt and developer aliases
- CPU load, RAM usage, uptime, and battery monitoring
- Four-workspace GNOME workflow
- Installation backups and an uninstall script
- Desktop screenshots and reusable configuration files

## Screenshots

### Midnight Green Desktop

![Midnight Green desktop](screenshots/midnight-green-desktop.png)

### Desktop Overview

![Midnight Dev desktop](screenshots/desktop.png)

### System Status

![System status](screenshots/system-status.png)

### Terminal and Fastfetch

![Kitty terminal with Fastfetch](screenshots/terminal-fastfetch.png)

## Tech Stack

- Fedora Linux
- GNOME on Wayland
- Kitty terminal
- Fastfetch
- Bash
- Git

## Requirements

- Fedora Linux with a GNOME desktop session
- Bash and Git
- Kitty terminal
- Fastfetch for the system information display
- GNOME `gsettings` for wallpaper and desktop settings

## Installation

Clone the repository:

    git clone https://github.com/stuti3333/midnight-dev.git
    cd midnight-dev

Install Kitty and Fastfetch if they are not already installed:

    sudo dnf install kitty fastfetch

Run the installer:

    chmod +x install.sh
    ./install.sh

Open a new Bash terminal or reload your shell configuration:

    source ~/.bashrc

The installer backs up existing tracked configuration files under:

    ~/.local/share/midnight-dev/backups/

Configure the GNOME workspace shortcuts when desired:

    ~/.local/bin/configure-workspaces.sh

## Dynamic Theme Switcher

Change your wallpaper and Kitty color palette using one command.

| Theme | Command |
|---|---|
| Midnight Space | `midnight-theme space` |
| Midnight Violet | `midnight-theme violet` |
| Midnight Green | `midnight-theme green` |

Open a new Kitty window after switching to apply the new terminal palette.

## Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| Super + Enter | Open Kitty terminal, if configured |
| Super | Open GNOME Overview and search for applications |
| Alt + Tab | Switch between open windows |
| PrtSc | Open GNOME screenshot controls |
| Super + 1–4 | Switch to workspace 1–4 |
| Super + Shift + 1–4 | Move the active window to workspace 1–4 |

The terminal shortcut may need to be configured separately. Verify custom bindings in GNOME Settings before relying on them.

## System Status

Run:

    midnight-status.sh

The script displays:

- System uptime
- CPU load averages over 1, 5, and 15 minutes
- RAM usage in GiB and as a percentage
- Battery level and charging status, when available

This is a refreshable command-line status report, not a continuously updating status bar.

## Project Structure

    configs/
      fastfetch/
      kitty/
    scripts/
      configure-workspaces.sh
      midnight-aliases.sh
      midnight-prompt.sh
      midnight-status.sh
      midnight-theme.sh
    wallpapers/
    screenshots/
    install.sh
    uninstall.sh
    README.md

## Uninstallation

Run the uninstall script from the cloned repository:

    ./uninstall.sh

Review the script and its backup behavior before running it. Wallpapers are intentionally retained, and desktop settings may need to be restored separately.

## Design Goals

- Consistent dark visual styling
- Keyboard-first navigation
- Lightweight Bash utilities
- Reusable dotfiles and setup scripts
- Clear installation and recovery instructions

## Author

Created as a customized developer desktop project for Linux.
