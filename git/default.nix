{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "traxys";
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
    aliases = {
      ri = "rebase -i";
	  amend = "commit --amend";
    };
  };

  home.file = {
    ".gitignore".source = ./gitignore;
  };
}
