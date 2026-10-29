#!/bin/bash
# Print the active Hyprland workspace id; refresh on workspace events.
ws() { hyprctl activeworkspace -j | jq -r '.id'; }

ws
sock="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
socat -u "UNIX-CONNECT:$sock" - | while read -r line; do
    case "$line" in
        workspace\>\>* | activespecial\>\>* | focusedmon\>\>*) ws ;;
    esac
done
