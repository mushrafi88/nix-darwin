{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  services.jankyborders = {
    enable = true;
    package = pkgs.jankyborders;
    settings = {
      width = 0.5;
      style = "square";
      active_color = "0xff494d64";
      inactive_color = "0xff494d64";
      hidpi = true;
      ax_focus = true;
    };
  };
}

