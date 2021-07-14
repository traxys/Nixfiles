{ config, pkgs, ... }:

let
  sensitiveInfo = (import ./sensitive.nix);
in
{
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

  networking = {
    hostName = "ZeNixLaptop";
    interfaces = {
      eno0.useDHCP = true;
      wlp1s0.useDHCP = true;
    };
    wireguard.interfaces = {
      octopi = {
        ips = [ "10.42.42.4/32" ];
        privateKeyFile = "/etc/wireguard/zelaptop.key";
        peers = [
          {
            publicKey = sensitiveInfo.octopiPubKey;
            presharedKeyFile = "/etc/wireguard/octopi-laptop.psk";
            allowedIPs = [ "10.42.42.1/32" ];
            endpoint = "${sensitiveInfo.homeUrl}:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  users.users.traxys = {
    uid = 1000;
    isNormalUser = true;
    home = "/home/traxys";
    extraGroups = [ "wheel" "networkmanager" "adbusers" ];
    shell = pkgs.zsh;
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  services.printing = {
    enable = true;
	drivers = [pkgs.hplip];
  };

  hardware.opengl = {
    enable = true;
  };
}











