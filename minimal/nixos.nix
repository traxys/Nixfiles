{extraInfo}: {
  config,
  pkgs,
  ...
}: {
  imports = [extraInfo];

  boot.kernelPackages = pkgs.linuxPackages;

  programs.nix-ld.enable = true;

  users.users."${config.extraInfo.username}" = {
    isNormalUser = true;
    home = "/home/${config.extraInfo.username}";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak-programmer";
  };

  environment.pathsToLink = ["/share/zsh"];
  fonts.enableDefaultFonts = true;
  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override {fonts = ["Hack"];})
      dejavu_fonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = ["DejaVu"];
        sansSerif = ["DejaVu Sans"];
        monospace = ["Hack"];
      };
    };
  };

  nix = {
    package = pkgs.nixUnstable;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
