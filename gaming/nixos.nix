{ pkgs, lib, ... }:
{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  hardware.steam-hardware.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
}
