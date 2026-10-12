# Midnight Dev 🌌

**A personalized Fedora Linux desktop designed for developers who love a dark aesthetic, keyboard-driven workflows, and a terminal-first environment.**

Midnight Dev brings together three coordinated color themes, a customized Kitty terminal, Fastfetch system information, GNOME workspace shortcuts, and lightweight system-monitoring scripts. It also includes installation and rollback scripts to make setup and recovery easier.

The goal is simple: create a developer desktop that looks cohesive, feels comfortable to work in, and keeps useful tools close at hand.

## ✨ Features

- **Three visual themes:** Midnight Space, Midnight Violet, and Midnight Green.
- **Customized terminal:** Kitty configuration with coordinated theme palettes.
- **System information:** Fastfetch configuration for a personalized terminal welcome.
- **System monitoring:** A script that reports uptime, CPU load, memory usage, and battery information when available.
- **Keyboard-driven workflow:** GNOME workspace shortcuts for switching workspaces and moving windows.
- **Theme switching:** Change the wallpaper and terminal palette with a single command.
- **Developer shortcuts:** Convenient aliases for Git, project navigation, system information, and common terminal tasks.
- **Installation and rollback:** Scripts that back up tracked configuration files and restore previous versions during uninstall.
- **Custom wallpapers:** Matching wallpapers for all three themes.

## 🎨 Themes

Midnight Dev includes three color palettes, each with its own matching wallpaper.

| Theme | Style | Palette file |
|---|---|---|
| Midnight Space | Deep, cool tones inspired by the night sky | `midnight-space.conf` |
| Midnight Violet | A purple-accented developer aesthetic | `midnight-violet.conf` |
| Midnight Green | Dark tones with green accents | `midnight-green.conf` |

The themes coordinate the Kitty terminal palette with the desktop wallpaper. The current theme is stored in `~/.local/share/midnight-dev/current-theme.conf`.

### Theme previews

#### Midnight Green

![Midnight Green desktop](screenshots/midnight-green-desktop.png)

#### Desktop overview

![Midnight Dev desktop overview](screenshots/desktop.png)

*The screenshots above show the captured desktop configurations. Not every theme currently has a dedicated screenshot.*

## 🖥️ Desktop environment

Midnight Dev is designed for a Fedora Linux desktop using GNOME.

| Component | Purpose |
|---|---|
| Fedora Linux | Operating system |
| GNOME | Desktop environment and workspace management |
| Kitty | Terminal emulator |
| Fastfetch | System information display |
| Bash | Shell aliases and prompt integration |
| Bash scripts | Theme switching, status monitoring, setup, and rollback |

The visual experience also depends on the installed GNOME theme, extensions, wallpaper, and personal desktop settings. Those settings may need separate configuration on another machine.

## 📸 More screenshots

### System status

![Midnight Dev system status](screenshots/system-status.png)

### Terminal and Fastfetch

![Kitty terminal and Fastfetch](screenshots/terminal-fastfetch.png)

## ⌨️ Keyboard shortcuts

Midnight Dev uses GNOME keyboard shortcuts to make workspace navigation quicker.

| Shortcut | Action |
|---|---|
| `Super + 1` | Switch to workspace 1 |
| `Super + 2` | Switch to workspace 2 |
| `Super + 3` | Switch to workspace 3 |
| `Super + 4` | Switch to workspace 4 |
| `Super + Shift + 1` | Move the active window to workspace 1 |
| `Super + Shift + 2` | Move the active window to workspace 2 |
| `Super + Shift + 3` | Move the active window to workspace 3 |
| `Super + Shift + 4` | Move the active window to workspace 4 |

`Super` is usually the Windows key on a standard PC keyboard.

The workspace configuration script can be run separately:

```bash
~/.local/bin/configure-workspaces.sh
```

Check GNOME Settings → Keyboard if you need to inspect or change the assigned shortcuts.

## 🚀 Installation

### Requirements

- Fedora Linux with GNOME
- Bash
- Kitty
- Fastfetch
- Git, to clone the repository

Install Kitty and Fastfetch if needed:

```bash
sudo dnf install kitty fastfetch git
```

### 1. Clone the repository

```bash
git clone https://github.com/stuti3333/midnight-dev.git
cd midnight-dev
```

### 2. Run the installer

```bash
./install.sh
```

The installer checks for required applications, installs the project's configuration and scripts, backs up tracked files before replacing them, adds the Bash integration block if it is not already present, and copies wallpapers without overwriting existing wallpaper files.

Open a new Bash terminal, or reload your current shell configuration:

```bash
source ~/.bashrc
```

### 3. Optional: configure workspace shortcuts

```bash
~/.local/bin/configure-workspaces.sh
```

Review the resulting shortcuts in GNOME Settings before using them.

## 🎨 Switching themes

After installation, use the `midnight-theme` command followed by the desired theme name.

**Midnight Space**

```bash
midnight-theme space
```

**Midnight Violet**

```bash
midnight-theme violet
```

**Midnight Green**

```bash
midnight-theme green
```

The theme script updates the current Kitty palette and sets the matching desktop wallpaper. It also enables the GNOME dark color preference.

## 📊 System monitoring

Run the system status script from a terminal:

```bash
midnight-status.sh
```

The script displays available system information, including:

- System uptime
- CPU load averages
- RAM usage and percentage
- Battery status when battery information is available

For a screenshot of the output, see [System Status](screenshots/system-status.png).

## 🧰 Developer aliases

Midnight Dev adds optional Bash aliases to make frequent commands easier to remember.

| Alias | Purpose |
|---|---|
| `croot` | Navigate to the current Git repository root, or fall back to the home directory |
| `gs` | Run `git status` |
| `gl` | Display a compact, decorated Git commit graph |
| `sysinfo` | Run the system status script |
| `update` | Refresh Fedora packages and install available updates |
| `ports` | Display listening and open TCP/UDP sockets |
| `cls` | Clear the terminal |
| `monitor` | Launch `btop` if it is installed |

The `update` alias runs `sudo dnf upgrade --refresh`, so it may ask for your password and update installed packages.

The `monitor` alias is available only when `btop` is installed.

## 📁 Project structure

```text
midnight-dev/
├── configs/
│   ├── kitty/
│   │   ├── kitty.conf
│   │   ├── midnight-space.conf
│   │   ├── midnight-violet.conf
│   │   └── midnight-green.conf
│   └── fastfetch/
│       └── config.jsonc
├── scripts/
│   ├── midnight-theme.sh
│   ├── midnight-status.sh
│   ├── midnight-prompt.sh
│   ├── midnight-aliases.sh
│   └── configure-workspaces.sh
├── wallpapers/
│   ├── midnight-space.png
│   ├── midnight-violet.png
│   └── midnight-green.png
├── screenshots/
├── install.sh
├── uninstall.sh
└── README.md
```

## ♻️ Uninstallation

To restore tracked configuration files or remove files created by the installer, run the uninstaller from the cloned repository:

```bash
./uninstall.sh
```

The uninstaller validates the installation manifest and checks the required backups before proceeding. It then restores backed-up files and removes tracked files that were created by the installer.

**Important notes:**

- Run the uninstaller from the project directory where `uninstall.sh` is located.
- Keep the installation manifest and backup files until you are sure you no longer need to roll back.
- Wallpapers are intentionally retained after uninstall.
- GNOME wallpaper settings, keyboard shortcuts, and other desktop changes may need to be reviewed or reverted separately.
- Review the script before running it if you have manually modified installed files since installation.

## 🔒 Backup and recovery

Before replacing tracked configuration files, the installer stores backups and records the changes in a manifest under:

```text
~/.local/share/midnight-dev/
```

This directory contains the installation manifest and backup files used by the uninstaller. Preserve it while you may still need to restore your previous configuration.

## 🛠️ Customization

You can extend Midnight Dev by:

- Editing the Kitty configuration and theme palette files under `configs/kitty/`.
- Customizing the Fastfetch configuration under `configs/fastfetch/`.
- Replacing the images under `wallpapers/` with your own matching wallpapers.
- Modifying the scripts under `scripts/` to add workflow shortcuts or system information.
- Adding screenshots that demonstrate new themes or features.

If you change a theme palette, test it in Kitty before using the theme switcher.

## 🎯 Project goals

Midnight Dev explores how a Linux desktop can be customized into a consistent developer workspace using configuration files, shell scripting, terminal tools, and GNOME shortcuts.

It is intended as a personal desktop customization project and a starting point for developers who want to adapt their own environment.

## 📄 License

Add a `LICENSE` file if you want others to reuse, modify, and distribute this project. Until a license is included, don't assume that the repository grants permission to reuse its contents.

---

**Built on Fedora Linux, customized for focused development.**
