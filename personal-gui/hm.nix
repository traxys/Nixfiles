{ pkgs, ... }:
{
  home.packages = with pkgs; [
    plasma5Packages.kdeconnect-kde
    kdePackages.kdenlive
    glaurung
    nur.repos.xeals.cura5
    anki-bin
    rmview
    rmc
  ];

  home.sessionVariables = {
    RMVIEW_CONF = pkgs.writers.writeJSON "rmview.json" {
      ssh.auth_method = "key";
      backend = "screenshare";
      orientation = "portrait";
    };
  };
}
