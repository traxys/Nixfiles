{ extraInfo }:
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ extraInfo ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;

  programs.nix-ld.enable = true;

  users.users."${config.extraInfo.username}" = {
    isNormalUser = true;
    home = "/home/${config.extraInfo.username}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  programs.zsh.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak-programmer";
  };

  environment.pathsToLink = [ "/share/zsh" ];
  fonts.enableDefaultPackages = true;
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
      dejavu_fonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "DejaVu" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "Hack" ];
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  nix = {
    package = pkgs.nixVersions.latest;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      trusted-users = [ config.extraInfo.username ];
      auto-optimise-store = true;
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };
  };
  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
}
