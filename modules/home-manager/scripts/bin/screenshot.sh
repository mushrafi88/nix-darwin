#!/bin/bash
# You pick your folder for saving
SAVE_DIR="$HOME/Pictures/Screenshots"   # or whatever folder you like
# Make sure folder exists
mkdir -p "$SAVE_DIR"
# Create a timestamped filename
FN="screenshot-$(date +'%Y-%m-%d-%H%M%S').png"

# Interactive area select with screencapture
screencapture -i "$SAVE_DIR/$FN"

# If file was created, copy it to clipboard
if [ -f "$SAVE_DIR/$FN" ]; then
  # copy png file into clipboard
  osascript -e "set the clipboard to (read (POSIX file \"$SAVE_DIR/$FN\") as «class PNGf»)"
fi

