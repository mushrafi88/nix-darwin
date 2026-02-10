{ lib, pkgs, ... }:
{
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    home.file.".config/sketchybar" = {
      source = ./sketchybar;   # your repo folder
      recursive = true;        # needed because it's a directory
    };
  };
}

