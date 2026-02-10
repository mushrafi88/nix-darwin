{ config
, lib
, pkgs
, inputs
, userConfig
, ...
}:

{
  # Install & manage Homebrew the Nix way (zhaofengli/nix-homebrew)
  # This creates /opt/homebrew (on Apple Silicon) owned by your user and
  # pins taps to the flake inputs you added in flake.nix.
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    user = userConfig.name;
    autoMigrate = true;

    # Pin taps to your flake inputs so updates are reproducible
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
  };

  homebrew = {
    enable = true;

    # Optional: control behavior on activation
    onActivation = {
      autoUpdate = true;   # run `brew update` first
      upgrade = true;      # run `brew upgrade` for brews/casks
      cleanup = "zap";     # remove unlisted items (use "uninstall" if you prefer)
    };

    # Dynamic taps in addition to the pinned ones
    taps = [
      "homebrew/core"
      "homebrew/cask"
      "FelixKratz/formulae"
      "dimentium/autoraise"
    ];

    # Command-line apps 
    brews = [
      "mas"     
      "sketchybar"
      "rsync" 
      "pinentry-mac"
      "sevenzip"
      "switchaudio-osx"
      "nowplaying-cli"
    ];

    # GUI apps (casks)
    casks = [
      "raycast"
      "visual-studio-code"
      "zoom"
      "discord"
      "telegram"
      "microsoft-excel"
      "microsoft-word"
      "microsoft-outlook"
      "microsoft-powerpoint"
      "microsoft-onenote"
      "onedrive" 
      "whatsapp"
      "messenger"
      "autoraiseapp"
      "font-hack-nerd-font"
      "font-sketchybar-app-font"
      "font-meslo-lg-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-caskaydia-cove-nerd-font"
      "font-iosevka-term-nerd-font"
      "font-fira-mono-nerd-font"
      "font-roboto"
      "font-roboto-slab"
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"
      "iina"
    ];

    # Mac App Store apps (need `mas` and to be signed in once)
    #masApps = {
    #  Xcode = 497799835;
    #  Magnet = 441258766;
    #};
  };
}

