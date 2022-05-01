{
  config,
  pkgs,
  ...
}: {
  boot = {
    initrd = {
      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/de0242ac-788a-44fc-a1ef-8d7bfaa448c6";
          preLVM = true;
          #keyFile = "/etc/secrets/initrd/keyfile";
          fallbackToPassword = true;
        };
        home = {
          device = "/dev/disk/by-uuid/b028c674-64c5-40e0-88c4-481d78854049";
          preLVM = true;
          #keyFile = "/etc/secrets/initrd/keyfile";
          fallbackToPassword = true;
        };
      };
      secrets = {
        "/etc/secrets/initrd/keyfile" = "/etc/secrets/initrd/keyfile";
      };
      #kernelParams = [ "iomem=relaxed" ];
    };
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        enableCryptodisk = true;
      };
    };
  };

  /*
    services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
   layout = "us";
   xkbVariant = "dvp";
   libinput.enable = true;
      desktopManager.session = [
        {
          name = "home-manager";
          start = ''
   		${pkgs.runtimeShell} $HOME/.hm-xsession-dbg&
   		waitPID=$!
   	'';
        }
      ];
    };
   */

  users = {
    users = {
      traxys = {
        uid = 1000;
        isNormalUser = true;
        home = "/home/traxys";
        extraGroups = ["wheel" "networkmanager" "adbusers"];
        shell = pkgs.zsh;
      };
      localtimed.group = "localtimed";
    };
    groups.localtimed = {};
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  services.printing = {
    enable = true;
    drivers = [pkgs.hplip pkgs.gutenprint pkgs.cnijfilter2];
  };
  services.avahi = {
    nssmdns = true;
    enable = true;
  };

  hardware.opengl = {
    enable = true;
  };
}
