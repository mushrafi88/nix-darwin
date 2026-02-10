#!/usr/bin/env bash
# @raycast.schemaVersion 1
# @raycast.title Area Screenshot → Clipboard + File
# @raycast.mode silent
# @raycast.package Utilities
# @raycast.icon 📸

# Use absolute path so GUI env works:
CMD="${HOME}/.nix-profile/bin/screenshot_mac"
[ -x "$CMD" ] || CMD="/etc/profiles/per-user/$USER/bin/screenshot_mac"
exec "$CMD"

