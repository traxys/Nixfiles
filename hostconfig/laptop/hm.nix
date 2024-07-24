{ config, ... }:
{
  programs.git = {
    userName = "Quentin Boyer";
    userEmail = config.extraInfo.email;
  };

  traxys.waybar.modules.battery.enable = true;
  home.stateVersion = "24.11";
}
