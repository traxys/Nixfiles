{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "Quentin Boyer";
    userEmail = config.extraInfo.email;
    delta = {
      enable = true;
      options = {
        line-numbers = true;
        syntax-theme = "Dracula";
        plus-style = "auto \"#121bce\"";
        plus-emph-style = "auto \"#6083eb\"";
      };
    };
    extraConfig = {
      diff = {
        algorithm = "histogram";
      };
      core = {
        excludesfile = "${config.home.homeDirectory}/.gitignore";
      };
    };
  };

  home.file = {
    ".gitignore".source = ./gitignore;
  };
}
