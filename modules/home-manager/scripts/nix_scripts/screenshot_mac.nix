# scripts/nix_scripts/screenshot_mac.nix
{ config, lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  screenshot_mac = pkgs.writeShellScriptBin "screenshot_mac" ''
    #!/usr/bin/env bash
    SAVE_DIR="$HOME/Pictures/Screenshots"
    mkdir -p "$SAVE_DIR"
    FN="screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
    screencapture -i "$SAVE_DIR/$FN"
    if [ -f "$SAVE_DIR/$FN" ]; then
      osascript -e "set the clipboard to (read (POSIX file \"$SAVE_DIR/$FN\") as «class PNGf»)"
    fi
  '';
in {
  # Only *apply* on macOS; module can be imported everywhere safely
  config = lib.mkIf isDarwin {
    home.packages = [ screenshot_mac ];
  };
}

