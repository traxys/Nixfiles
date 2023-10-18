{pkgs, ...}: {
  home.packages = with pkgs; [
    bitwarden-cli
    hbw
    kabalist_cli
    nix-alien
    tokei
    xdg-ninja
    zk
    nixpkgs-fmt
    nixpkgs-review
    nix-init
    mujmap
  ];

  services.syncthing.enable = true;

  programs.ssh.enable = true;
  programs.zsh.initExtraBeforeCompInit = ''
    fpath+="$HOME/.zfunc"
  '';

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

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
