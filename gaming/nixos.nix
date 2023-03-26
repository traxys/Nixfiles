{pkgs, ...}: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  security.wrappers = {
    gamescope = {
      owner = "root";
      group = "root";
      source = "${pkgs.gamescope}/bin/gamescope";
      capabilities = "cap_sys_nice+ep";
    };
  };
}
