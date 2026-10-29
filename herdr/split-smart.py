#!/usr/bin/env python3
"""Smart split for herdr — picks direction like hyprland's dwindle does for
new windows: split along the longer visual axis. Terminal cells are ~2:1,
so a pane with width > 2*height is 'wide' and splits right; else down."""
import json
import subprocess

H = "/home/gregghy/.local/bin/herdr"

out = subprocess.run([H, "pane", "layout"], capture_output=True, text=True).stdout
layout = json.loads(out)["result"]["layout"]
panes = layout["panes"]
focused = layout.get("focused_pane_id")
pane = next((p for p in panes if p["pane_id"] == focused), panes[0])

rect = pane["rect"]
direction = "right" if rect["width"] > rect["height"] * 2 else "down"
subprocess.run([H, "pane", "split", "--current", "--direction", direction])
