{ config, ... }:
{
  programs.git = {
    userName = "traxys";
    userEmail = config.extraInfo.email;
  };

  traxys.waybar.modules."battery".enable = true;
  home.stateVersion = "21.11";
}
