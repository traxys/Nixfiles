{pkgs, ...}: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  hardware.steam-hardware.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  security.wrappers = {
    gamescope = {
      owner = "root";
      group = "root";
      source = "${pkgs.gamescope}/bin/gamescope";
      capabilities = "cap_sys_nice+ep";
    };
  };
}
