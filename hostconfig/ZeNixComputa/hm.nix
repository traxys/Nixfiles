{ config, pkgs, ... }:
{
  home.username = "${config.extraInfo.username}";
  home.homeDirectory = "/home/${config.extraInfo.username}";

  programs.git = {
    userName = "traxys";
    userEmail = config.extraInfo.email;
  };

  services.mako.output = "DP-2";

  xdg.desktopEntries.teams = {
    name = "teams";
    exec = "${pkgs.chromium}/bin/chromium --app=https://teams.microsoft.com";
  };

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
