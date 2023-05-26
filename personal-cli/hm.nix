{pkgs, ...}: {
  home.packages = with pkgs; [
    bitwarden-cli
    hbw
    kabalist_cli
    nix-alien
    nvfetcher
    tokei
    xdg-ninja
    zk
  ];

  services.syncthing.enable = true;

  programs.ssh.enable = true;
  programs.zsh.initExtraBeforeCompInit = ''
    fpath+="$HOME/.zfunc"
  '';

  home.file = {
    bin = {
      source = ./scripts;
      recursive = true;
    };
    ".zfunc" = {
      source = ./zfunc;
      recursive = true;
    };
  };
}
