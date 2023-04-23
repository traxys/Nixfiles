{
  pkgs,
  config,
  ...
}: {
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

  xdg.desktopEntries.teams = {
    name = "teams";
    exec = "${pkgs.chromium}/bin/chromium --app=https://teams.microsoft.com";
  };

  programs.zsh.shellAliases = {
    gemail = "git send-email --to='dl-bxi-sw-ll-patches@atos.net'";
  };

  home.stateVersion = "21.11";
}
