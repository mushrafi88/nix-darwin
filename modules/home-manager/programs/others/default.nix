{ ... }:
{
  programs.bat = {
    enable = true;
  };
  catppuccin.bat.enable = true; 

   programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };
  catppuccin.btop.enable = true;
  programs.fastfetch.enable = true; 

}
