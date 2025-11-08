{ config, ... }:
{
  programs.git = {
    settings.user.name = "traxys";
    settings.user.email = config.extraInfo.email;
  };

  traxys.waybar.modules."battery".enable = true;
  home.stateVersion = "21.11";
}
