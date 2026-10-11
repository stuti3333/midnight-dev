# Midnight Dev

A customized, keyboard-driven developer workstation built on Fedora Linux and GNOME.

## Features
- Unified dark violet and cyan theme
- Developer terminal configuration
- Keyboard-driven workflow
- CPU, RAM and battery monitoring
- Wayland screenshots
- Portable dotfiles and setup scripts

## Tech Stack
- Fedora Linux
- GNOME / Wayland
- Kitty
- Fastfetch
- Bash
- Git and GNU Stow

## Screenshots
See the `screenshots/` directory.

## Installation
Installation instructions will be added as the setup is completed.

## Keyboard Shortcuts
Documented as shortcuts are configured.

## GNOME Workspace Shortcuts

Run `./scripts/configure-workspaces.sh` to configure four workspaces.

| Shortcut | Action |
|---|---|
| Super + 1–4 | Switch to workspace 1–4 |
| Super + Shift + 1–4 | Move the active window to workspace 1–4 |

Suggested workspace roles:

- Workspace 1: Coding
- Workspace 2: Terminal and development servers
- Workspace 3: Research and documentation
- Workspace 4: Monitoring and debugging

The script uses GNOME's `gsettings` and is intended for GNOME desktop sessions.
