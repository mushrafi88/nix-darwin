{ config, lib, pkgs, ... }:

let
  # --- Pick a wallpaper subfolder (macOS dialog) and restart the process ---
  wallpaper_folder = pkgs.writeShellScriptBin "wallpaper_folder" ''
    set -euo pipefail

    # Options you maintain under ~/Pictures/wallpapers/<option> (plus "ALL")
    OPTIONS=("dark" "bright" "mild" "ALL")

    # Use AppleScript choose-from-list (works outside terminal)
    CHOICE=$(/usr/bin/osascript <<'APPLESCRIPT'
      set theOptions to {"dark", "bright", "mild", "ALL"}
      try
        set theChoice to choose from list theOptions with prompt "Choose a wallpaper folder:" default items {"dark"} OK button name "Use"
        if theChoice is false then
          return ""
        else
          return item 1 of theChoice
        end if
      on error
        return ""
      end try
APPLESCRIPT
    )

    if [[ -z "''${CHOICE}" ]]; then
      echo "No selection made. Nothing changed."
      exit 0
    fi

    echo "''${CHOICE}" > "$HOME/selected_folder.txt"

    # Restart the wallpaper process cleanly
    lock_file="/tmp/wallpaper_process.lock"
    if [[ -e "''${lock_file}" ]]; then
      # Ask the process to reload folder via SIGHUP if it's our script
      if ps -p "$(cat "''${lock_file}")" -o comm= | grep -q wallpaper_process; then
        kill -HUP "$(cat "''${lock_file}")" || true
        exit 0
      fi
    fi

    # If no running instance, start one
    nohup wallpaper_process >/dev/null 2>&1 &
  '';

  # --- Start with a default after a small delay (useful at login) ---
  wallpaper_start = pkgs.writeShellScriptBin "wallpaper_start" ''
    set -euo pipefail
    sleep 10
    echo dark > "$HOME/selected_folder.txt"

    lock_file="/tmp/wallpaper_process.lock"
    if [[ -e "''${lock_file}" ]]; then
      if ps -p "$(cat "''${lock_file}")" -o comm= | grep -q wallpaper_process; then
        kill -HUP "$(cat "''${lock_file}")" || true
        exit 0
      fi
    fi

    nohup wallpaper_process >/dev/null 2>&1 &
  '';

  # --- Next / Prev just signal the running process ---
  wallpaper_next = pkgs.writeShellScriptBin "wallpaper_next" ''
    set -euo pipefail
    lock_file="/tmp/wallpaper_process.lock"
    if [[ -e "''${lock_file}" ]]; then
      kill -USR1 "$(cat "''${lock_file}")" || true
    else
      echo "wallpaper_process is not running."
    fi
  '';

  wallpaper_prev = pkgs.writeShellScriptBin "wallpaper_prev" ''
    set -euo pipefail
    lock_file="/tmp/wallpaper_process.lock"
    if [[ -e "''${lock_file}" ]]; then
      kill -USR2 "$(cat "''${lock_file}")" || true
    else
      echo "wallpaper_process is not running."
    fi
  '';

  # --- Main loop: builds a shuffled list and sets macOS desktop wallpaper ---
  wallpaper_process = pkgs.writeShellScriptBin "wallpaper_process" ''
    #!/usr/bin/env bash
    set -euo pipefail

    lock_file="/tmp/wallpaper_process.lock"

    # ensure single instance
    if [[ -e "''${lock_file}" ]]; then
      if ps -p "$(cat "''${lock_file}")" -o comm= | grep -q wallpaper_process; then
        echo "wallpaper_process is already running."
        exit 0
      fi
    fi
    echo $$ > "''${lock_file}"
    cleanup() { rm -f "''${lock_file}"; }
    trap cleanup EXIT

    WALL_BASE="$HOME/Pictures/wallpapers"
    SELECT_FILE="$HOME/selected_folder.txt"
    INTERVAL_SEC=$((30*60))  # 30 minutes

    current_index=1
    direction=1
    shuffled_wallpapers=""

    set_wallpaper_macos() {
      local img="$1"
      # Set the wallpaper for all Spaces on all displays
      /usr/bin/osascript <<APPLESCRIPT
tell application "System Events"
  repeat with d in desktops
    set picture of d to POSIX file "$img"
  end repeat
end tell
APPLESCRIPT
    }

    # Fisher–Yates shuffle for portability (no gshuf needed)
    build_shuffled_list() {
      local folder="$1"
      mapfile -t files < <(find "$folder" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | LC_ALL=C sort)
      if (( ''${#files[@]} == 0 )); then
        shuffled_wallpapers=""
        return
      fi
      for ((i=''${#files[@]}-1; i>0; i--)); do
        j=$((RANDOM % (i+1)))
        tmp="''${files[i]}"
        files[i]="''${files[j]}"
        files[j]="''${tmp}"
      done
      shuffled_wallpapers=$(printf "%s\n" "''${files[@]}")
    }

    load_selected_folder() {
      local selected="ALL"
      if [[ -f "''${SELECT_FILE}" ]]; then
        selected=$(cat "''${SELECT_FILE}" || echo "ALL")
      fi
      echo "selected from txt: ''${selected}"

      local dir
      if [[ "''${selected}" == "ALL" ]]; then
        dir="''${WALL_BASE}"
      else
        dir="''${WALL_BASE}/''${selected}"
      fi

      echo "using folder: ''${dir}"
      build_shuffled_list "''${dir}"
      current_index=1
    }

    move_next() { direction=1; current_index=$((current_index + direction)); }
    move_previous() { direction=-1; current_index=$((current_index + direction)); }

    trap 'move_next' USR1
    trap 'move_previous' USR2
    trap 'load_selected_folder' HUP

    load_selected_folder

    while true; do
      total=$(printf "%s" "''${shuffled_wallpapers}" | wc -l | tr -d ' ')
      if (( total == 0 )); then
        echo "No images found; sleeping."
        sleep "''${INTERVAL_SEC}"
        continue
      fi

      # wrap indices
      if (( current_index < 1 )); then current_index=$total; fi
      if (( current_index > total )); then current_index=1; fi

      wallpaper=$(printf "%s\n" "''${shuffled_wallpapers}" | awk -v idx="''${current_index}" 'NR==idx')
      echo "setting: ''${wallpaper}"

      if [[ -f "''${wallpaper}" ]]; then
        set_wallpaper_macos "''${wallpaper}"
      else
        echo "missing file, skipping"
      fi

      sleep "''${INTERVAL_SEC}" &
      wait $!
      current_index=$((current_index + direction))
    done
  '';
in
{
  home.packages = with pkgs; [
    wallpaper_process
    wallpaper_next
    wallpaper_prev
    wallpaper_folder
    wallpaper_start
  ];
}

