{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    nix-zsh-completions
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "wd" "rust"];
    };
    plugins = [
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = inputs.fast-syntax-highlighting;
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = inputs.zsh-nix-shell;
      }
    ];

    initExtra = ''
      export PATH="$PATH:$HOME/bin";
      source ${./p10k.zsh}
      source ${inputs.powerlevel10k}/powerlevel10k.zsh-theme
      if [ -f "$HOME/.zvars" ]; then
      	source "$HOME/.zvars"
      fi

      ${pkgs.fortune}/bin/fortune \
        | ${pkgs.cowsay}/bin/cowsay \
        | ${pkgs.dotacat}/bin/dotacat
    '';
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat -p";
      ls = "${pkgs.exa}/bin/exa --icons";
    };
  };

  home.file = {
    ".zprofile".source = ./zprofile;
  };
}
