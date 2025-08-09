{ pkgs, ... }:
{
  home.packages = with pkgs; [
    plasma5Packages.kdeconnect-kde
    kdePackages.kdenlive
    glaurung
    cura-appimage
    orca-slicer
    anki-bin
    rmview
    sieve-editor-gui
    rmc
    rawtherapee
    darktable
    audacity
  ];

  home.sessionVariables = {
    RMVIEW_CONF = pkgs.writers.writeJSON "rmview.json" {
      ssh.auth_method = "key";
      backend = "screenshare";
      orientation = "portrait";
    };
  };

  services.gpg-agent.pinentry.package = pkgs.pinentry-rofi.override {rofi = pkgs.rofi-wayland;};
}
