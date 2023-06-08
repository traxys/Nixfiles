{
  pkgs,
  config,
  ...
}: let
  workAddr = "quentin.boyer@***REMOVED***";
in {
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
    python39Packages.clustershell
    shellcheck
    shfmt
    slack
    sshfs
  ];

  wm.startup = [
    {command = "chromium --app=http://teams.microsoft.com";}
  ];

  wm.workspaces.definitions."".assign = [
    "Microsoft Teams"
    "Chromium-browser"
  ];

  programs.git = {
    userName = "Quentin Boyer";
    userEmail = config.extraInfo.email;
  };

  home.sessionVariables = {
    OPENSC_SO = "${pkgs.opensc}";
    EMAIL_CONN_TEST = "s";
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

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.aerc = {
    enable = true;
    extraAccounts = {
      work-t = let
        workCfg = config.accounts.email.accounts.work.aerc;
      in {
        inherit
          (workCfg.extraAccounts)
          check-mail-cmd
          check-mail-timeout
          ;
        from = "Quentin Boyer <${workAddr}>";
        outgoing = "msmtpq --read-envelope-from --read-recipients";
        default = "_unread";
        postpone = "Drafts";
        source = "notmuch://~/Maildir";
        address-book-cmd = "${pkgs.notmuch-addrlookup}/bin/notmuch-addrlookup --format=aerc %s";
        query-map = "${pkgs.writeText "querymap" ''
          inbox=tag:inbox and not tag:spammy
          inflight=thread:{tag:inflight}
          review=thread:{tag:review}
          _unread=tag:unread

          patches/bxi3=tag:bxi3
          patches/btf=tag:btf
          patches/libs2=tag:libs2
          patches/doc=tag:doc
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

        "zI" = ":cf inbox<Enter>";
        "zi" = ":cf inflight<Enter>";
        "zr" = ":cf review<Enter>";
        "zu" = ":cf _unread<Enter>";
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
    new.tags = ["new"];
    hooks = {
      preNew = "${pkgs.isync}/bin/mbsync --all";
      postNew = let
        mkProjectMatch = project: "subject:'/PATCH\\s${project}/'";
        mkProjectMatches = labels: lib.concatStringsSep " or " (builtins.map mkProjectMatch labels);

        mkProject = tag: labels: ''
          notmuch tag +${tag} -unread -new -- tag:new and \( ${mkProjectMatches labels} \) and tag:me
          notmuch tag +${tag} +unread -new -- tag:new and \( ${mkProjectMatches labels} \) and not tag:me
        '';

        spammyFilters = [
          "subject:'[confluence] Recommended in Confluence for Boyer, Quentin'"
          "subject:'[PCI-SIG]'"
          "from:enterprisedb.com"
          "from:GIGA@***REMOVED***"
        ];

        spammySearch = lib.concatStringsSep " or " spammyFilters;
      in ''
        notmuch tag +work -- tag:new and 'path:work/**'
        notmuch tag +inflight -- tag:new and from:${workAddr} and subject:'/^\[PATCH/'
        notmuch tag +review -- tag:new and not from:${workAddr} and subject:'/^\[PATCH/'
        notmuch tag -unread +me -- tag:new and from:${workAddr}
        notmuch tag -unread -new +spammy -- tag:new and \( ${spammySearch} \)
        ${mkProject "btf" ["bxi-test-frameworks" "bxi-frameworks"]}
        ${mkProject "bxi3" ["bxi3"]}
        ${mkProject "libs2" ["bxi-jenkins-libs2"]}
        ${mkProject "hps" ["bxi-hps"]}
        ${mkProject "doc" ["bxi-doc"]}
        notmuch tag +inbox +unread -new -- tag:new and not tag:me
        notmuch tag +inbox -unread -new -- tag:new and tag:me
      '';
    };
  };

  accounts.email = {
    accounts.work = rec {
      address = workAddr;
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

  systemd.user.services.notmuch-new = {
    Unit = {Description = "notmuch synchronization";};

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.notmuch}/bin/notmuch new";
    };
  };

  systemd.user.timers.notmuch = {
    Unit = {Description = "notmuch synchronization";};

    Timer = {
      OnCalendar = "*:0/5";
      Unit = "notmuch-new.service";
    };

    Install = {WantedBy = ["default.target"];};
  };

  xdg.desktopEntries.teams = {
    name = "teams";
    exec = "${pkgs.chromium}/bin/chromium --app=https://teams.microsoft.com";
  };

  programs.zsh.shellAliases = {
    gemail = let
      nwadminSendmail = pkgs.writeScript "nwadmin-sendmail" ''
        #!/usr/bin/env sh

        # shellcheck disable=SC2029
        ssh nwadmin "/usr/sbin/sendmail -r ${workAddr} $*"
        exit $?
      '';
    in ''git send-email --sendmail-cmd="${nwadminSendmail}" --to="dl-bxi-sw-ll-patches@***REMOVED***"'';
  };

  home.stateVersion = "21.11";
}
