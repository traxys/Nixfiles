{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot.initrd = {
    enable = true;
    availableKernelModules = [
      "r8169"
    ];

    kernelModules = [ "amdgpu" ];

    # secrets = {
    #   "/etc/secrets/initrd/keyfile" = "/etc/secrets/initrd/keyfile";
    # };
    # kernelParams = [ "iomem=relaxed" ];
    network.ssh = {
      enable = true;
      port = 8022;
    };
  };
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  boot.kernelParams = [
    "video=HDMI-A-1:1920x1080@75"
    "video=DP-2:1920x1080@75"
  ];

  programs.droidcam.enable = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [ droidcam-obs ];
  };

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  networking = {
    hostName = "ZeNixComputa";
    interfaces = {
      enp4s0 = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
    };
    firewall.allowedTCPPorts = [
      8080
      8085
      5201
      7777
      24642
      80
      443
      843
      38202
      38203
      8554
      1935
      8888
      8889
      8890
    ];
    firewall.allowedUDPPorts = [
      24642
      80
      443
      843
      38202
      38203
      8000
      8001
      8002
      8003
    ];
  };

  time.timeZone = "Europe/Paris";

  users.users = {
    traxys.uid = 1000;
    guest = {
      isNormalUser = true;
      home = "/home/guest";
    };
  };

  services.mediamtx = {
    enable = true;
    settings = {
      authMethod = "internal";
      authInternalUsers = [
        {
          user = "any";
          pass = "";
          ips = [ ];
          permissions = [
            {
              action = "publish";
              path = "";
            }
            {
              action = "read";
              path = "";
            }
            {
              action = "playback";
              path = "";
            }
          ];
        }
      ];
      paths = {
        traxys = { };
      };
    };
  };

  hardware.ckb-next = {
    enable = true;
    package = pkgs.ckb-next.overrideAttrs (old: {
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DUSE_DBUS_MENU=0" ];
    });
  };

  services.postgresql = {
    package = pkgs.postgresql_16;
    enable = true;
    ensureUsers = [ { name = "traxys"; } ];
    ensureDatabases = [
      "list"
      "regalade"
    ];
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."atw-dash" = {
    listen = [
      {
        addr = "127.0.0.1";
        port = 63542;
      }
    ];

    root = pkgs.fetchgit {
      url = "https://forge.hackers.town/antijingoist/atw-dashboard.git";
      rev = "03fa6a4a9ccb18844060e44ba9869b1a80922090";
      hash = "sha256-RAMRfHV6pB2jgmw/iBr3cj2AsNOQxaT69fk61sgutPQ=";
    };
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = [ "qwen3.5:9b" ];
  };

  services.meilisearch = {
    enable = true;
    masterKeyFile = "/var/lib/secrets/meilisearch";
  };

  services.librechat = {
    enable = true;
    enableLocalDB = true;

    credentials = {
      CREDS_IV = "/var/lib/secrets/librechat_creds_iv";
      CREDS_KEY = "/var/lib/secrets/librechat_creds_key";
      JWT_SECRET = "/var/lib/secrets/librechat_jwt_secret";
      JWT_REFRESH_SECRET = "/var/lib/secrets/librechat_jwt_refresh_secret";
    };

    env = {
      ALLOW_REGISTRATION = false;
    };

    settings = {
      version = "1.3.19";

      endpoints = {
        custom = [
          {
            name = "Ollama";
            apiKey = "ollama";
            baseURL = "http://localhost:11434/v1/";
            models = {
              default = config.services.ollama.loadModels;
              fetch = false;
            };
            titleConvo = true;
            titleModel = "current_model";
            modelDisplayName = "ZeNixComputa";
          }
        ];
      };
    };

    meilisearch.enable = true;
  };

  hardware.cpu.amd.updateMicrocode = true;

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
