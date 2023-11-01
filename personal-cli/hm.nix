{pkgs, ...}: {
  home.packages = with pkgs; [
    bitwarden-cli
    hbw
    kabalist_cli
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

  programs.fioul = {
    enable = true;

    settings = {
      default = {
        nominatim = "https://nom.familleboyer.net";
        server = "https://fioul.familleboyer.net";
        cache_duration = "6months";
      };

      display = {
        fuels = ["Diesel"];
        dates = false;
      };

      sort = {
        fuel = "Diesel";
      };
    };
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
