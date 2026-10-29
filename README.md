# ~/.config

Dotfiles repo for my Arch + Hyprland setup (Framework 13, AMD Ryzen 7040).

Only curated config is tracked — app dirs holding secrets or disposable
state are `.gitignore`d. Before `git add -A`, always check `git status`
first; token-bearing dirs (`gh/`, `.wrangler/`, `devin/`, `opencode/`,
editor config) must never be committed.

Some tracked configs belong to apps not currently installed — they are
kept on purpose so a reinstall gets old settings back.

## Layout

| Path | Purpose |
|---|---|
| `hypr/` | Hyprland, hyprpaper, hyprlock + wallpapers |
| `kitty/`, `starship.toml` | Terminal + prompt |
| `nvim/` | Neovim (LazyVim) |
| `waybar/`, `wofi/` | Bar + launcher |
| `systemd/user/` | User units: ssh-agent, tunnels, timers (see below) |
| `distro/` | System maintenance toolkit (see below) |
| `gtk-3.0/`, `gtk-4.0/` | GTK theming |
| `mimeapps.list`, `user-dirs.*` | XDG defaults |

## distro/ — maintenance toolkit

Scripts live here as the canonical copy, symlinked into `~/.local/bin`:

| Script | Run as | What it does |
|---|---|---|
| `distro-clean` | user | Clears user caches (yay AUR builds, pip, npm, pre-commit) and prints a status report: disk / journal / orphan packages / coredumps |
| `distro-clean-root` | sudo | Removes orphan packages, prunes pacman cache to last 2 versions, vacuums the journal, clears coredumps, enables `loginctl` linger |
| `distro-power-setup` | sudo | One-time setup: zram swap + `power-profiles-daemon` (see system changes below) |

### Automation

- `systemd/user/distro-clean.timer` — runs `distro-clean` **weekly**
  (`OnCalendar=weekly`, `Persistent=true`). Enabled via
  `timers.target.wants/`, so it survives a reinstall automatically.
- Check runs: `journalctl --user -u distro-clean`
- System timers already present on Arch: `paccache` (weekly pacman
  cache prune), `reflector` (mirror refresh), `systemd-tmpfiles-clean`.

### System-level changes the scripts make

| Change | File / mechanism | Set by |
|---|---|---|
| zram swap = RAM/2, zstd | `/etc/systemd/zram-generator.conf` | `distro-power-setup` |
| `vm.swappiness=180` | `/etc/sysctl.d/99-zram-swappiness.conf` | `distro-power-setup` |
| Auto power-saver on battery | `power-profiles-daemon.service` | `distro-power-setup` |
| Journal capped at 500M | `/etc/systemd/journald.conf.d/50-maxsize.conf` | `distro-clean-root` |
| Pacman cache keeps 2 versions | `PACCACHE_ARGS=-k2` in `/etc/conf.d/pacman-contrib` | `distro-clean-root` |

## Fresh Arch install — restore steps

```sh
# 1. clone this repo to ~/.config, then symlink the scripts
for s in distro-clean distro-clean-root distro-power-setup; do
    ln -sf ~/.config/distro/$s ~/.local/bin/$s
done

# 2. (optional) put the root script in sudo's path
sudo install -m755 ~/.config/distro/distro-clean-root /usr/local/bin/

# 3. enable the weekly cleanup timer
systemctl --user daemon-reload
systemctl --user enable --now distro-clean.timer

# 4. apply system-level setup
sudo ~/.config/distro/distro-power-setup
sudo ~/.config/distro/distro-clean-root
```

## Maintenance routine

- **Automatic:** weekly `distro-clean` timer, `paccache` (2 versions),
  `reflector`, tmpfiles cleaning, journald 500M cap.
- **When `distro-clean` reports orphans:** `sudo distro-clean-root`
- **Battery:** `powerprofilesctl` shows the active profile;
  `sudo powertop` for drain analysis.
