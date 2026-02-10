{
  outputs,
  userConfig,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../programs/aerospace 
   # ../programs/brave
   # ../programs/firefox 
    ../programs/fzf
    ../programs/git
    ../programs/gpg
    ../programs/kitty 
    ../programs/neovim 
    ../programs/others
    ../programs/sketchybar
    ../programs/yazi
    ../programs/zen
    ../programs/zathura 
    ../programs/zsh
    ../scripts
    ../services/flatpak
    ../services/jankyborders
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${userConfig.name}" else "/home/${userConfig.name}";
  };

  # Ensure common packages are installed
  home.packages =
    with pkgs;
    [
      anki-bin
      awscli2
      dig
      dust
      eza
      fd
      jq
      kubectl
      lazydocker
      nh
      openconnect
      pipenv
      python3
      lua 
      ripgrep
      terraform
      autojump
      zoxide
      git-lfs  
      aria2 
      micromamba
      direnv
      pass
      ghostscript 
    ]
    ++ lib.optionals stdenv.isDarwin [
      colima
      docker
      hidden-bar
      mos
      raycast
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      tesseract
      unzip
      wl-clipboard
    ];

  # Catpuccin flavor and accent
  catppuccin = {
    flavor = "frappe";
    accent = "sapphire";
  };
}
