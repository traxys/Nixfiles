{
  pkgs,
  config,
  lib,
  ...
}:
let
in
{
  imports = [ ./work.nix ];

  home.packages = with pkgs; [
    teams-for-linux
    bear
    clang-analyzer
    clang-tools
    gcc
    meson
    ninja
    # Broken (27 feb 2024)
    # python3Packages.clustershell
    shellcheck
    shfmt
    tigervnc
    xhost
    xauth
    xinit
    xclip
  ];

  programs.git = {
    settings.user.name = "Quentin Boyer";
    settings.user.email = config.workAddr;
    includes = [
      {
        condition = "gitdir:~/Perso/";
        contents = {
          user = {
            email = "quentin@familleboyer.net";
            name = "traxys";
          };
        };
      }
    ];
  };

  home.sessionVariables = {
    OPENSC_SO = "${pkgs.opensc}";
  };

  home.file = {
    "libs/opensc-pkcs11.so".source = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    "libs/libpcsclite.so.1".source = "${pkgs.pcsclite}/lib/libpcsclite.so.1";
  };

  terminal.font.size = 10.5;

  traxys.waybar.modules."disk#root".enable = false;
  traxys.waybar.modules."battery".enable = true;

  home.homeDirectory = "/home/boyerq";
  home.username = "boyerq";
  home.stateVersion = "26.05";

  programs.alacritty = {
    enable = true;

    theme = "tokyo_night";

    settings = {
      env.WAYLAND_DISPLAY = "";
    };
  };

  programs.i3status-rust.enable = true;

  xsession.windowManager.i3 = {
    enable = true;

    config =
      let
        mod = "Mod4";
        terminal = "alacritty";
        menu = "rofi -show drun";
        fonts = {
          names = [ "Hack Nerd Font" ];
          size = 11.0;
        };
      in
      {
        inherit terminal menu fonts;

        modifier = mod;

        bars = [
          {
            inherit fonts;
            statusCommand = "i3status-rs /home/boyerq/.config/i3status-rust/config-default.toml";
          }
        ];

        keybindings = {
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+q" = "kill";
          "${mod}+e" = "exec ${menu}";

          "${mod}+Left" = "focus left";
          "${mod}+Right" = "focus right";
          "${mod}+Up" = "focus up";
          "${mod}+Down" = "focus down";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Right" = "move right";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Down" = "move down";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+EuroSign" = "move container to workspace number 1";
          "${mod}+Shift+guillemotleft" = "move container to workspace number 2";
          "${mod}+Shift+guillemotright" = "move container to workspace number 3";
          "${mod}+Shift+dollar" = "move container to workspace number 4";
          "${mod}+Shift+percent" = "move container to workspace number 5";
          "${mod}+Shift+asciicircum" = "move container to workspace number 6";
          "${mod}+Shift+ampersand" = "move container to workspace number 7";
          "${mod}+Shift+asterisk" = "move container to workspace number 8";
          "${mod}+Shift+numbersign" = "move container to workspace number 9";
          "${mod}+Shift+at" = "move container to workspace number 10";

          "${mod}+r" = "mode resize";
        };
      };
  };

  programs.nixvim = { lib, ... }: { traxys.vvk.enable = lib.mkForce false; };

  traxys.wm = "niri";
}
