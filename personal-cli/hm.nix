{ pkgs, lib, ... }:
let
  bwPass = pkgs.writeShellScript "bw-pass" ''
    ${lib.getExe pkgs.bitwarden-cli} get item $@ | ${lib.getExe pkgs.jq} -r .login.password
  '';
  bwUser = pkgs.writeShellScript "bw-user" ''
    ${lib.getExe pkgs.bitwarden-cli} get item $@ | ${lib.getExe pkgs.jq} -r .login.username
  '';
in
{
  home.packages = with pkgs; [
    bitwarden-cli
    hbw
    tokei
    xdg-ninja
    zk
    nixpkgs-fmt
    nixpkgs-review
    nix-init
    mujmap
    attic-client
    nix-tree
    gh
  ];

  services.syncthing.enable = true;

  programs.ssh.enable = true;

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
        fuels = [ "Diesel" ];
        dates = false;
      };

      sort = {
        fuel = "Diesel";
      };
    };
  };

  programs.khal = {
    locale.timeformat = "%H:%M";
    enable = true;
  };
  programs.vdirsyncer.enable = true;
  services.vdirsyncer.enable = true;

  accounts.calendar = {
    basePath = ".calendar";
    accounts.personal =
      let
        bwId = "07619222-49eb-4d66-ad8c-ca7c81a9868d";
      in
      {
        primary = true;
        primaryCollection = "QC";
        remote = {
          type = "caldav";
          url = "https://nextcloud.familleboyer.net/remote.php";
          passwordCommand = [
            "${bwPass}"
            bwId
          ];
        };
        vdirsyncer = {
          enable = true;
          collections = [ "from a" ];
          userNameCommand = [
            "${bwUser}"
            bwId
          ];
          metadata = [
            "color"
            "displayname"
          ];
        };
        khal = {
          type = "discover";
          enable = true;
        };
      };
  };

  home.file = {
    bin = {
      source = ./scripts;
      recursive = true;
    };
  };
}
