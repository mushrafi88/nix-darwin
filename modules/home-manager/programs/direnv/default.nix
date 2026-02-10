{ config, pkgs, ...}:
{
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;  
    };

    bash.enable = true; # see note on other shells below
  };
}
