{ userConfig, ... }:
{
  # Install git via home-manager module
  programs.git = {
    enable = true;
    signing = {
    signByDefault = true;
      }; 
    settings = {
      pull.rebase = "true";
      user.name = userConfig.fullName;
      user.email = userConfig.email;
    };
  };

  programs.delta = {
     enable = true;
     enableGitIntegration = true;
      options = {
      keep-plus-minus-markers = true;
      light = false;
      line-numbers = true;
      navigate = true;
      width = 280;
     };
  };

  # Enable catppuccin theming for git delta
  catppuccin.delta.enable = true;
}
