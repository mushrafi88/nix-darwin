{ darwinModules, ... }:
{
  imports = [
    "${darwinModules}/common"
    "${darwinModules}/homebrew"
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 6;
}
