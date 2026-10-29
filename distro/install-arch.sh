#!/usr/bin/env bash
# ===================================================================
# 林ux bare-metal installer — run from the Arch ISO live environment.
#
#   bash install-arch.sh
#
# What it does:
#   1. Verifies you're on the Arch ISO and online (iwctl for Wi-Fi)
#   2. Runs `archinstall --config archinstall.json` — automates locale,
#      systemd-boot, minimal profile, pipewire, network (copies the
#      ISO's working network config)
#   3. Two things are INTENTIONALLY left interactive in the TUI:
#      - Disk selection  (a wrong choice wipes data — pick deliberately)
#      - User + password (credentials don't belong in a git repo)
#   4. After reboot: clone this repo to ~/.config and run install.sh
#      (installs all 161+32 packages, fonts, iwd setup, 林ux branding)
#
# If archinstall rejects the JSON (schema changed across ISO versions),
# it falls back to the fully guided TUI — the result is the same.
# ===================================================================
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ ! -d /run/archiso ]]; then
	echo "This script is meant to run from the Arch ISO live environment."
	exit 1
fi

ping -c1 -W5 archlinux.org >/dev/null || {
	echo "No network. Connect Wi-Fi first:  iwctl station wlan0 connect <SSID>"
	exit 1
}

if archinstall --config ./archinstall.json; then
	echo
	echo "Base install done. After reboot:"
	echo "  git clone <your-repo-url> ~/.config && bash ~/.config/install.sh"
else
	echo
	echo "Config rejected — launching guided mode. Choose:"
	echo "  profile: minimal | audio: pipewire | network: copy ISO | bootloader: systemd-boot"
	exec archinstall
fi
