{ pkgs, ... }:
let
  postgresSocketPath = "/var/postgres-risoul";
in
{
  systemd.tmpfiles.rules = [ "d ${postgresSocketPath} 0755 root root" ];

  services.home-assistant = {
    enable = true;

    openFirewall = true;
    customComponents = with pkgs.home-assistant-custom-components; [
      auth_oidc
    ];
    extraComponents = [
      "mqtt"
      "roborock"
      "octoprint"
      "meteo_france"
      "freebox"
      "ipp"
      "isal"
    ];
    extraPackages = ps: with ps; [ psycopg2 ];
    config = {
      default_config = {
        excludes = [ "usb" ];
      };
      recorder = {
        db_url = "postgresql://hass@100.64.0.1/meylanctrl";
      };
      #automation = "!include /var/lib/hass/automations.yaml";
      #script = "!include /var/lib/hass/scripts.yaml";
      #scene = "!include /var/lib/hass/scenes.yaml";
      homeassistant = {
        name = "Meylan";

        unit_system = "metric";
        currency = "EUR";
        country = "FR";

        # auth_providers = [ { type = "homeassistant"; } ];
      };
      logger = {
        default = "info";
        # logs."custom_components.auth_header" = "debug";
      };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
          "100.64.0.1"
        ];
      };
      influxdb = {
        api_version = 2;
        ssl = true;
        host = "influx.familleboyer.net";
        port = 443;
        token = "!include /etc/home-assistant/influx.yaml";
        organization = "Risoul";
        bucket = "ha_meylan";
      };
    };
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      permit_join = true;
      mqtt = {
        base_topic = "zigbee2mqtt";
        server = "mqtt://localhost";
      };
      serial = {
        port = "/dev/ttyUSB0";
      };
      frontend = {
        port = 8080;
      };
      advanced = {
        network_key = "!/etc/zigbee2mqtt-key.yaml network_key";
      };
    };
  };
}
