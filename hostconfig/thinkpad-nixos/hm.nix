{
  pkgs,
  config,
  lib,
  ...
}:
let
  projects = {
    btf = [
      "bxi-test-frameworks"
      "bxi-frameworks"
    ];
    bxi3 = [ "bxi3" ];
    libs2 = [ "bxi-jenkins-libs2" ];
    hps = [ "bxi-hps" ];
    doc = [ "bxi-doc" ];
    container = [ "bxi-containers" ];
    flash-tools = [ "bxi-flash-tools" ];
    gpumap = [ "gpumap" ];
    ofi = [ "libfabric-bxi-portals" ];
    lustre = [ "lustre-ptl4lnd" ];
    ptlnet = [ "ptlnet" ];
    openshmem = [ "sandia-openshmem" ];
    bxi-base = [ "bxi-base" ];
    bxi2-portals = [ "bxi-portals" ];
    bxi2-mod = [ "bxi-module" ];
    bxi2-ptltest = [ "bxi-portals-tests" ];
    bxicomm = [ "bxicomm" ];
  };
in
{
  imports = [ ./work.nix ];

  home.packages = with pkgs; [
    bear
    clang-analyzer
    clang-tools
    cppcheck
    jira-cli-go
    libfabric
    opensc
    pcsclite
    pcsctools
    python3Packages.clustershell
    shellcheck
    shfmt
    slack
    sshfs
  ];

  wm.startup = [ { command = "chromium --app=http://teams.microsoft.com"; } ];

  wm.workspaces.definitions."".assign = [
    "Microsoft Teams"
    "Chromium-browser"
  ];

  programs.git = {
    userName = "Quentin Boyer";
    userEmail = config.workAddr;
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
    EMAIL_CONN_TEST = "x";
  };

  home.file = {
    "libs/opensc-pkcs11.so".source = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    "libs/libpcsclite.so.1".source = "${pkgs.pcsclite}/lib/libpcsclite.so.1";
    "bin/bxi-cn" = {
      text = ''
        #!/usr/bin/env bash

        exec podman run -e KERNEL_BULL_ENV=1 -it -v .:/src -w /src bril-docker-release/bxi-rhel:8.6 "$@"
      '';
      executable = true;
    };
    "bin/bxigpu-cn" = {
      text = ''
        #!/usr/bin/env bash

        exec podman run -e KERNEL_BULL_ENV=1 -it -v .:/src -w /src bril-docker-release/bxi-gpu:8.6 "$@"
      '';
      executable = true;
    };
  };

  terminal.font.size = 10.5;

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.aerc = {
    enable = true;
    extraAccounts = {
      work-t =
        let
          workCfg = config.accounts.email.accounts.work.aerc;
        in
        {
          inherit (workCfg.extraAccounts) check-mail-cmd check-mail-timeout;
          from = "Quentin Boyer <${config.workAddr}>";
          outgoing = "msmtpq --read-envelope-from --read-recipients";
          default = "_unread";
          postpone = "Drafts";
          source = "notmuch://~/Maildir";
          address-book-cmd = "${pkgs.notmuch-addrlookup}/bin/notmuch-addrlookup --format=aerc %s";
          query-map =
            let
              mkPatchDir = name: "patches/${name}=tag:${name}";
              patchDirs = builtins.concatStringsSep "\n" (builtins.map mkPatchDir (builtins.attrNames projects));
            in
            "${pkgs.writeText "querymap" ''
              inbox=tag:inbox and not tag:spammy
              inflight=thread:{tag:inflight}
              review=thread:{tag:review}
              _unread=thread:{tag:unread}
              _todo=thread:{tag:todo}
              ext/iommu=tag:iommu
              stage=thread:{tag:stage}
              archi=thread:"{tag:'archi' or subject:'[NICIA] CR réunion architecture'}"

              ${patchDirs}
            ''}";
        };
    };
    extraConfig = {
      general.unsafe-accounts-conf = true;

      ui = {
        mouse-enabled = true;
        threading-enabled = true;
      };

      filters = {
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "text/html" = "html | colorize";
        "subject,~^\\[PATCH" = "delta";
      };

      openers = {
        "x-scheme-handler/http*" = "firefox";
      };
    };
    extraBinds = {
      global = {
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-t>" = ":term<Enter>";
        "?" = ":help keys<Enter>";
      };

      messages = {
        "q" = ":quit<Enter>";

        "j" = ":next<Enter>";
        "<Down>" = ":next<Enter>";
        "<PgDn>" = ":next 100%<Enter>";

        "k" = ":prev<Enter>";
        "<Up>" = ":prev<Enter>";
        "<PgUp>" = ":prev 100%<Enter>";

        "g" = ":select 0<Enter>";
        "G" = ":select -1<Enter>";

        "J" = ":next-folder<Enter>";
        "K" = ":prev-folder<Enter>";

        "T" = ":toggle-threads<Enter>";

        "<Enter>" = ":view<Enter>";

        "C" = ":compose<Enter>";

        "<C-r>" = ":read<Enter>";

        "rr" = ":reply -a<Enter>";
        "rq" = ":reply -aq<Enter>";
        "Rr" = ":reply<Enter>";
        "Rq" = ":reply -q<Enter>";

        "/" = ":search<space>";
        "\\" = ":filter<space>";
        "n" = ":next-result<Enter>";
        "N" = ":prev-result<Enter>";
        "<Esc>" = ":clear<Enter>";

        "v" = ":mark -t<Enter>";
        "V" = ":mark -v<Enter>";

        "tdi" = ":tag -inflight<Enter>:select 0<Enter>";
        "tdr" = ":tag -review<Enter>:select 0<Enter>";
        "tdt" = ":tag -todo<Enter>:select 0<Enter>";

        "zI" = ":cf inbox<Enter>";
        "zi" = ":cf inflight<Enter>";
        "zr" = ":cf review<Enter>";
        "zu" = ":cf _unread<Enter>";
        "zt" = ":cf _todo<Enter>";
        "zT" = ":cf tag:";
      };

      view = {
        "/" = ":toggle-key-passthrough<Enter>/";

        "q" = ":close<Enter>";
        "O" = ":open<Enter>";
        "S" = ":save<space>";
        "D" = ":delete<Enter>";
        "<C-l>" = ":open-link <space>";
        "f" = ":forward<Enter>";

        "rr" = ":reply -a<Enter>";
        "rq" = ":reply -aq<Enter>";
        "Rr" = ":reply<Enter>";
        "Rq" = ":reply -q<Enter>";

        "H" = ":toggle-headers<Enter>";
        "<C-k>" = ":prev-part<Enter>";
        "<C-j>" = ":prev-part<Enter>";
        "J" = ":next<Enter>";
        "K" = ":prev<Enter>";
      };

      "view::passthrough" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<Esc>" = ":toggle-key-passthrough<Enter>";
      };

      compose = {
        "$noinherit" = true;
        "$ex" = "<C-x>";

        "<C-k>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";

        "<tab>" = ":next-field<Enter>";
        "<backtab>" = ":prev-field<Enter>";

        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };

      "compose::editor" = {
        "$noinherit" = true;
        "$ex" = "<C-x>";

        "<C-k>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";

        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };

      "compose::review" = {
        "y" = ":send<Enter>";
        "n" = ":abort<Enter>";
        "v" = ":preview<Enter>";
        "p" = ":postpone<Enter>";
        "q" = ":choose -o d discard abort -o p postpone postpone<Enter>";
        "e" = ":edit<Enter>";
        "a" = ":attach<space>";
        "d" = ":detach<space>";
      };
    };
  };

  programs.notmuch = {
    enable = true;
    new.tags = [ "new" ];
    hooks = {
      preNew = "${pkgs.isync}/bin/mbsync --all";
      postNew =
        let
          mkProjectMatch = project: "subject:'/PATCH\\s${project}\\s/'";
          mkProjectMatches = labels: lib.concatStringsSep " or " (builtins.map mkProjectMatch labels);

          mkProject = tag: labels: ''
            notmuch tag +${tag} -unread -new -- tag:new and \( ${mkProjectMatches labels} \) and tag:me
            notmuch tag +${tag} +unread -new -- tag:new and \( ${mkProjectMatches labels} \) and not tag:me
          '';

          projectFilters = builtins.concatStringsSep "\n" (lib.attrsets.mapAttrsToList mkProject projects);

          spammyFilters = [
            "subject:'[confluence] Recommended in Confluence for Boyer, Quentin'"
            "subject:'[PCI-SIG]'"
            "from:enterprisedb.com"
            "from:GIGA@atos.net"
          ];

          spammySearch = lib.concatStringsSep " or " spammyFilters;
        in
        ''
          notmuch tag +work -- tag:new and 'path:work/**'
          notmuch tag +iommu -new -- tag:new and to:iommu@lists.linux.dev and subject:'/\[PATCH/'
          notmuch tag -unread -- tag:iommu and subject:'/^Re:/'
          notmuch tag +inflight -- tag:new and from:${config.workAddr} and subject:'/^\[PATCH/'
          notmuch tag +review -- tag:new and not from:${config.workAddr} and subject:'/^\[PATCH/'
          notmuch tag -unread +me -- tag:new and from:${config.workAddr}
          notmuch tag -unread -new +spammy -- tag:new and \( ${spammySearch} \)
          ${projectFilters}
          notmuch tag +inbox +unread -new -- tag:new and not tag:me
          notmuch tag +inbox -unread -new -- tag:new and tag:me
        '';
    };
  };

  programs.zsh.shellAliases = {
    "khal-today" = "khal list today today -f '{start-time}-{end-time}: {title}'";
  };

  traxys.waybar.modules."custom/khal".enable = true;
  traxys.waybar.modules."disk#root".enable = false;
  traxys.waybar.modules."battery".enable = true;
  traxys.waybar.modules."network#wifi" = {
    enable = true;
    interface = "wlp4s0";
  };

  accounts = {
    calendar = {
      accounts.personal.primary = lib.mkForce false;

      accounts.work = {
        primary = true;
        remote = {
          url = "http://localhost:1080/users/${config.workAddr}/calendar/";
          type = "caldav";
          userName = "${config.workAddr}";
          passwordCommand = [
            "echo"
            "foobar"
          ];
        };
        khal = {
          enable = true;
          color = "light green";
        };
        vdirsyncer.enable = true;
      };
    };

    email = {
      accounts.work = rec {
        address = "quentin.boyer@eviden.com";
        imap = {
          host = "localhost";
          port = 1143;
          tls.enable = false;
        };
        mbsync = {
          enable = true;
          create = "maildir";
          subFolders = "Verbatim";
          extraConfig.account = {
            AuthMechs = "LOGIN";
            Timeout = 60;
          };
        };
        passwordCommand = "echo foobar";
        notmuch.enable = true;
        msmtp = {
          enable = true;
          extraConfig.auth = "plain";
        };
        primary = true;
        realName = "Quentin Boyer";
        userName = address;
        smtp = {
          host = "localhost";
          port = 1025;
          tls.enable = false;
        };

        aerc = {
          enable = true;
          extraAccounts = {
            check-mail-cmd = "notmuch new";
            check-mail-timeout = "60s";
          };
        };
      };
    };
  };

  systemd.user.services.notmuch-new = {
    Unit = {
      Description = "notmuch synchronization";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.notmuch}/bin/notmuch new";
    };
  };

  systemd.user.timers.notmuch = {
    Unit = {
      Description = "notmuch synchronization";
    };

    Timer = {
      OnCalendar = "*:0/5";
      Unit = "notmuch-new.service";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  xdg.desktopEntries.teams = {
    name = "teams";
    exec = "${pkgs.chromium}/bin/chromium --app=https://teams.microsoft.com";
  };

  home.homeDirectory = "/home/boyerq";
  home.username = "boyerq";
  home.stateVersion = "21.11";

  wayland.windowManager.sway.extraConfig = "exec /usr/libexec/polkit-gnome-authentication-agent-1";
  wm.keybindings = {
    "${config.wm.modifier}+Shift+l" = lib.mkForce "exec /usr/bin/swaylock";
  };
}
