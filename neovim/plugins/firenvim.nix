{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins;
{
  options.plugins.firenvim = {
    enable = mkEnableOption "Enable firenvim support";
    global =
      let
        mkKey = mkOption {
          type = types.enum [
            "default"
            "noop"
          ];
          default = "default";
          description = ''
            When it is possible to do so, if you press this keyboard shortcut while not in a Firenvim
            frame, Firenvim will attempt to emulate the expected behavior of the shortcut
          '';
        };

        nvimModes = [
          "all"
          "normal"
          "visual"
          "insert"
          "replace"
          "cmdline_normal"
          "cmdline_insert"
          "cmdline_replace"
          "operator"
          "visual_select"
          "cmdline_hover"
          "statusline_hover"
          "statusline_drag"
          "vsep_hover"
          "vsep_drag"
          "more"
          "more_lastline"
          "showmatch"
        ];

        modeOptions = listToAttrs (
          map (mode: {
            name = mode;
            value = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "Keys to ignore in ${mode} mode";
            };
          }) nvimModes
        );
      in
      {
        alt = mkOption {
          type = types.enum [
            "all"
            "alphanum"
          ];
          # TODO: set to 'alphanum' by default on macOS
          default = "all";
          description = ''
            Change the handling of alt with dead keys. See
            https://github.com/glacambre/firenvim#special-characters-on-macos for more information.
          '';
        };
        "<C-n>" = mkKey;
        "<C-t>" = mkKey;
        "<C-w>" = mkKey;
        "<CS-n>" = mkKey;
        "<CS-t>" = mkKey;
        "<CS-w>" = mkKey;
        ignoreKeys = mkOption {
          type = types.submodule { options = modeOptions; };
          default = { };
          description = ''
            You can make Firenvim ignore key presses (thus letting the browser handle them) by
            specifying them in this module
          '';
        };
        cmdlineTimeout = mkOption {
          type = types.int;
          default = 3000;
          description = ''
            Due to space constraints, the external command line covers part of the buffer.
            This can be a problem as sometimes neovim will send a message that tells Firenvim to draw
            the command line, and then never send the message to tell Firenvim to stop displaying it.

            In order to work around this problem, a "cmdlineTimeout" configuration option has been
            implemented, which makes Firenvim hide the external command line after the cursor has
            moved and some amount of milliseconds have passed:
          '';
        };
      };

    local = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            cmdline = mkOption {
              type = types.nullOr (
                types.enum [
                  "neovim"
                  "firenvim"
                  "none"
                ]
              );
              default = null;
              description = ''
                You can chose between neovim's built-in command line, firenvim's command line and no
                command line at all

                Choosing none does not make sense unless you have alternative way to display the
                command line such as noice.nvim.
              '';
            };
            content = mkOption {
              type = types.nullOr (
                types.enum [
                  "html"
                  "text"
                ]
              );
              default = null;
              description = ''
                This option controls how Firenvim should read the content of an element.
                Setting it to 'html' will make Firenvim fetch the content of elements as HTML,
                'text' will make it use plaintext.
              '';
            };
            priority = mkOption {
              type = types.int;
              default = 0;
              description = "Higher priority options overwrite lower priority ones";
            };
            renderer = mkOption {
              type = types.nullOr (
                types.enum [
                  "html"
                  "canvas"
                ]
              );
              default = null;
            };
            selector = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                This options is a CSS selector that allows to choose which elements firenvim
                will link to
              '';
            };
            takeover = mkOption {
              type = types.nullOr (
                types.enum [
                  "always"
                  "once"
                  "empty"
                  "nonempty"
                  "never"
                ]
              );
              default = null;
              description = ''
                When set to 'always', Firenvim will always take over elements for you. When set to
                'empty', Firenvim will only take over empty elements. When set to 'never', Firenvim
                will never automatically appear, thus forcing you to use a keyboard shortcut in order
                to make the Firenvim frame appear. When set to 'nonempty', Firenvim will only take
                over elements that aren't empty. When set to 'once', Firenvim will take over elements
                the first time you select them, which means that after :q'ing Firenvim, you'll have
                to use the keyboard shortcut to make it appear again.
              '';
            };
            filename = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                This setting is a format string where each element in curly braces will be replaced
                with a value and where the maximum length can be specified with a percentage. Possible
                format elements are 'hostname' (= the domain name of the website), 'pathname'
                (= the path of the page), 'selector' (= the CSS selector of the text area),
                'timestamp' (= the current date) and 'extension' (the language extension when using
                Firenvim on a code editor or txt otherwise).
              '';
            };
          };
        }
      );
      default = {
        ".*" = {
          cmdline = "firenvim";
          content = "text";
          priority = 0;
          renderer = "canvas";
          selector = ''textarea:not([readonly]), div[role="textbox"]'';
          takeover = "always";
          filename = "{hostname%32}_{pathname%32}_{selector%32}_{timestamp%32}.{extension}";
        };
      };
      description = ''
        Configure firenvim for different urls. The keys are regex to match URL, and if multiple
        regex match the URL then the value with the highest priority is choosen
      '';
    };
  };

  config =
    let
      cfg = config.plugins.firenvim;
    in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [ firenvim ];

      globals.firenvim_config = {
        globalSettings = cfg.global;
        localSettings = cfg.local;
      };
    };
}
