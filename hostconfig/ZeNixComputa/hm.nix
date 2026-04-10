{ config, pkgs, ... }:
{
  home.username = "${config.extraInfo.username}";
  home.homeDirectory = "/home/${config.extraInfo.username}";

  programs.git = {
    settings.user.name = "traxys";
    settings.user.email = config.extraInfo.email;
  };

  home.packages = with pkgs; [
    vintagestory
    teams-for-linux
  ];

  services.mako.settings.output = "DP-2";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
