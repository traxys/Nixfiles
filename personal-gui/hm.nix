{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    glaurung
    cura-appimage
    orca-slicer
    anki-bin
    rmview
    #sieve-editor-gui
    rmc
    rawtherapee
    darktable
    audacity
    android-tools

    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    ricty
  ];

  home.sessionVariables = {
    RMVIEW_CONF = pkgs.writers.writeJSON "rmview.json" {
      ssh.auth_method = "key";
      backend = "screenshare";
      orientation = "portrait";
    };
  };

  services.gpg-agent.pinentry.package = pkgs.pinentry-rofi;

  fonts.fontconfig.defaultFonts =
    let
      langs = [
        "JP"
        "KR"
        "TC"
        "TK"
        "SC"
      ];
      mkLangs = s: lib.map (l: lib.replaceString "{}" l s) langs;
    in
    {
      sansSerif = lib.mkAfter (mkLangs "Noto Sans CJK {}");
      serif = lib.mkAfter (mkLangs "Noto Serif CJK {}");
      monospace = lib.mkAfter [ "ricty" ];
    };
}
