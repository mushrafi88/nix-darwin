{
  pkgs,
  lib,
  ...
}:
{
  # Install gpg via home-manager module
  programs.gpg = {
    enable = true; 
  };


  services.gpg-agent = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    enableSshSupport = true;
    pinentry.package = lib.mkDefault pkgs.pinentry-gnome3;
  };
}
