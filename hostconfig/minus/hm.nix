{config, ...}: {
  home.username = "${config.extraInfo.username}";
  home.homeDirectory = "/home/${config.extraInfo.username}";

  home.stateVersion = "23.11";
}
