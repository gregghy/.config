# ~/.config

Dotfiles for my Arch + Hyprland setup (Framework 13, AMD Ryzen 7040) — OS
branded **林ux**. Warm gruvbox palette everywhere: kitty, starship, yazi,
eza, herdr, mako, GTK. System font: CommitMono Nerd Font (fetched by
bootstrap, not committed). Networking: iwd + impala (no NetworkManager).

## Install on a fresh Arch system

Bare metal: from the Arch ISO, `bash distro/install-arch.sh` runs
`archinstall --config distro/archinstall.json` (automates locale,
systemd-boot, minimal profile, pipewire; disk + user stay interactive).

After a base install (pacstrap/archinstall + user created), one line:

```sh
curl -fsSL https://raw.githubusercontent.com/gregghy/.config/main/distro/distro-bootstrap | bash
```

`distro/distro-bootstrap` self-clones this repo, installs all packages
and nerd fonts, restores configs and scripts, enables timers, applies
system config, switches networking to iwd, and brands the OS as 林ux.
It's idempotent — safe to re-run.

**Manual leftovers** (by design, nothing secret is in git):

- Wi-Fi → reconnect once via `impala` (waybar icon) — system runs on iwd
- `~/.ssh` keys → `systemctl --user restart ssh-agent`
- `gh auth login` + `git config --global user.name/user.email`
- devin CLI, opencode (own installers), flutter SDK → `~/progetti/flutter-sdk`
- secret aliases (e.g. `trr` Transmission password) — re-add to `~/.bashrc`

## What's inside

| Path | What |
|---|---|
| `hypr/` | Hyprland (`hyprland.lua` is the *active* config), hyprpaper, hyprlock, wallpapers |
| `kitty/` `starship.toml` | Terminal (CommitMono Nerd Font) + minimal gruvbox prompt |
| `eza/` | `theme.yml` (generated — do not edit), `generate-theme.py` |
| `yazi/` | File manager + `gruvbox-dark` flavor |
| `herdr/` | Persistent terminal workspaces config |
| `mako/` `waybar/` `wofi/` `viewnior/` | Notifications, bar, launcher, image viewer — waybar clicks: Wi-Fi → `impala` (floating kitty), volume → `wiremix` |
| `nvim/` | LazyVim |
| `gtk-2.0/` `gtk-3.0/` `QtProject.conf` | GTK/Qt theming |
| `systemd/user/` | User units + `.wants` enable-symlinks (auto-enabled on restore) |
| `distro/` | Maintenance + bootstrap scripts, `install-arch.sh` + `archinstall.json` (bare-metal) |
| `fastfetch/` | 林 ASCII logo + config |
| `pkglist.txt` `pkglist-aur.txt` | Package snapshots (161 official + 32 AUR) |
| `.bashrc_copy` | Tracked `~/.bashrc` copy — secrets stripped |
| `environment.d/` `mimeapps.list` `user-dirs.*` `dconf/` `pavucontrol.ini` `pulse/` | XDG/desktop defaults |

## Daily use

**Hyprland** (`mainMod = Alt`):

| Keys | Action |
|---|---|
| `Alt+Q` / `Alt+F` | kitty / wofi launcher |
| `Alt+H` | herdr (persistent terminal) |
| `Alt+M` | nchat (telegram/signal/whatsapp TUI) |
| `Alt+E` | yazi |
| `Alt+T` | toggle waybar · `Alt+C` kill window |
| `Alt+arrows` / `Alt+1..9` | focus window / workspace |
| `Alt+Ctrl+num` / `Alt+scroll` | move window to workspace / cycle workspaces |
| `Alt+L` | lock |
| `Alt+S` / `Alt+N,B` | screenshot region / brightness |
| `Alt+D` / `Ctrl+Alt+D` | screen record region / full output (toggle → `~/Videos`) |

**herdr** (`Alt+Shift` namespace — no prefix, no clash with Hyprland's Alt):

| Keys | Action |
|---|---|
| `Alt+Shift+arrows` | focus pane · `Ctrl+Alt+Shift+arrows` resize |
| `Alt+Shift+Q` / `Alt+Shift+Enter` | split v · `Alt+Enter` split h |
| `Alt+Shift+C`/`Alt+Esc` | close pane · `Alt+Shift+Z` zoom · `Tab` cycle |
| `Alt+Shift+N`/`T` / `1..9` / `[`/`]` | new tab / switch / move tab |
| `Alt+Shift+R` `K` / `Ctrl+P`/`N` | rename·close tab / cycle tabs |
| `Alt+Shift+M` `W` / `Ctrl+W` `1..9` `R` `K` | new·cycle workspace / back·switch·rename·close |
| `Alt+Shift+D` `Ctrl+Q` `/` `` ` `` | detach / reload / help / copy mode |
| `Ctrl+Space`+`q` / `Shift+arrows` | smart split (auto dir) / swap pane — commands need prefix (0.9.5) |

`Alt+Shift` is fully free for herdr — Hyprland binds nothing on it.
us/it layout toggle is `Super+Space` (was `Alt+Shift` — that space belongs to herdr).

**Workspaces** (named, apps auto-route — see `hl.window_rule`/`hl.workspace_rule` in `hyprland.lua`):

| 1 `term` | 2 `web` | 3 `herdr` | 4 `files` | 5 `chat` | 6 `notes` |
|---|---|---|---|---|---|
| kitty (default) | zen · firefox | `kitty --class herdr` | `kitty --class yazi` | telegram · `kitty --class nchat` | obsidian |

Launching a routed app pulls you to its workspace. `Alt+H`/`Alt+E` launch
with dedicated kitty `--class` so the rules can match them.

**Shell** (bash): `ls`/`ll`/`lt` → eza with yazi's icons+colors ·
`cat` → bat (gruvbox-dark) · `Ctrl+R`/`Ctrl+T` fzf · `z <dir>` zoxide ·
`❯` turns red on failed commands

## Maintenance

Scripts in `distro/` are the canonical copies, symlinked to `~/.local/bin`
(+ `distro-clean-root` in `/usr/local/bin` for sudo):

| Script | What |
|---|---|
| `distro-bootstrap` | Fresh-install setup (above) |
| `distro-clean` | User caches + status report — **runs weekly** via user timer |
| `sudo distro-clean-root` | Orphans, pacman cache→2 versions, journal vacuum, coredumps |
| `sudo distro-power-setup` | zram + power-profiles-daemon (idempotent) |

Automatic: weekly `distro-clean` timer, `paccache` (`-k2`), `reflector`,
tmpfiles, journald 500M cap. Check runs: `journalctl --user -u distro-clean`.
Battery: `powerprofilesctl`, `sudo powertop`.

## House rules

- **Nothing secret in git.** `gh/`, `.wrangler/`, `devin/`, `opencode/`,
  editor dirs are gitignored — check `git status` before `git add -A`.
- **`hypr/hyprland.lua` is the live Hyprland config** — the old `.conf`
  was a dead duplicate and is gone.
- **Networking is iwd**, not NetworkManager — use `impala`/`iwctl` to join
  Wi-Fi. NM stays installed-but-disabled as rollback (`distro-bootstrap`
  §9 reapplies the switch if needed).
- Regenerate package lists after installing new things:

  ```sh
  pacman -Qneq > ~/.config/pkglist.txt
  pacman -Qmq | grep -vE '^(yay|yay-bin|yay-bin-debug)$' > ~/.config/pkglist-aur.txt
  ```

- Regenerate the eza theme if yazi updates its icons:
  `python3 ~/.config/eza/generate-theme.py`
- Sync bashrc changes to the tracked copy (strip secrets first):
  `grep -v 'transmission-remote.*-n ' ~/.bashrc > ~/.config/.bashrc_copy`

### System-level files the scripts touch

| Change | Where | By |
|---|---|---|
| zram = RAM/2, zstd | `/etc/systemd/zram-generator.conf` | `distro-power-setup` |
| `vm.swappiness=180` | `/etc/sysctl.d/99-zram-swappiness.conf` | `distro-power-setup` |
| Power profiles (auto power-saver on battery) | `power-profiles-daemon.service` | `distro-power-setup` |
| Journal cap 500M | `/etc/systemd/journald.conf.d/50-maxsize.conf` | `distro-clean-root` |
| Pacman cache `-k2` | `/etc/conf.d/pacman-contrib` | `distro-clean-root` |
| iwd self-DHCP + resolved DNS | `/etc/iwd/main.conf` | `distro-bootstrap` |
| Wired-ethernet DHCP | `/etc/systemd/network/20-wired.network` | `distro-bootstrap` |
| iwd/resolved/networkd on, NM off; resolv.conf → resolved stub | systemctl + `/etc/resolv.conf` | `distro-bootstrap` |
| OS name 林ux, pretty hostname | `/etc/os-release`, `hostnamectl --pretty` | `distro-bootstrap` |
| Nerd fonts (Maple Mono, CommitMono) | `~/.local/share/fonts/` | `distro-bootstrap` |
| GTK font → CommitMono 11 | `gsettings` | `distro-bootstrap` |
