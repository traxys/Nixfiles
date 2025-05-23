{
  lib,
  pkgs,
  helpers,
  flake,
  ...
}:
{
  # Utility Plugins

  plugins.luasnip = {
    enable = true;
  };

  plugins.lspkind = {
    enable = true;
    cmp = {
      enable = true;
    };
  };

  plugins.nvim-lightbulb = {
    enable = true;
    settings.autocmd.enabled = true;
  };

  plugins.lsp_signature = {
    #enable = true;
  };

  plugins.inc-rename = {
    enable = true;
  };

  extraConfigLuaPost = ''
    vim.api.nvim_create_user_command("LtexLangChangeLanguage", function(data)
        local language = data.fargs[1]
        local bufnr = vim.api.nvim_get_current_buf()
        local client = vim.lsp.get_active_clients({ bufnr = bufnr, name = 'ltex' })
        if #client == 0 then
            vim.notify("No ltex client attached")
        else
            client = client[1]
            client.config.settings = {
                ltex = {
                    language = language
                }
            }
            client.notify('workspace/didChangeConfiguration', client.config.settings)
            vim.notify("Language changed to " .. language)
        end
      end, {
        nargs = 1,
        force = true,
    })

    -- rust-analyzer overrides injections
    vim.api.nvim_set_hl(0, "@lsp.type.string.rust", {})
  '';

  # Language Servers

  extraConfigLuaPre = ''
    local efm_fs = require('efmls-configs.fs')
    local djlint_fmt = {
      formatCommand = string.format('%s --reformat ''${INPUT} -', efm_fs.executable('djlint')),
      formatStdin = true,
    }
  '';

  plugins.efmls-configs = {
    enable = true;

    toolPackages.mdformat = pkgs.mdformat.withPlugins (
      ps: with ps; [
        # TODO: broken with update of mdformat
        # mdformat-gfm
        mdformat-frontmatter
        mdformat-footnote
        mdformat-tables
        mdit-py-plugins
      ]
    );

    setup = {
      sh = {
        #linter = "shellcheck";
        formatter = "shfmt";
      };
      bash = {
        #linter = "shellcheck";
        formatter = "shfmt";
      };
      c = {
        linter = "cppcheck";
      };
      markdown = {
        formatter = [
          "cbfmt"
          "mdformat"
        ];
      };
      nix = {
        linter = "statix";
      };
      lua = {
        formatter = "stylua";
      };
      html = {
        formatter = [
          "prettier"
          (helpers.mkRaw "djlint_fmt")
        ];
      };
      htmldjango = {
        formatter = [ (helpers.mkRaw "djlint_fmt") ];
        linter = "djlint";
      };
      json = {
        formatter = "prettier";
      };
      css = {
        formatter = "prettier";
      };
      ts = {
        formatter = "prettier";
      };
      gitcommit = {
        linter = "gitlint";
      };
    };
  };

  plugins.lsp = {
    enable = true;

    keymaps = {
      silent = true;

      lspBuf = {
        "gd" = "definition";
        "gD" = "declaration";
        "ca" = "code_action";
        "ff" = "format";
        "K" = "hover";
      };
    };

    servers = {
      nixd = {
        enable = true;
        settings = {
          formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
          options =
            let
              getFlake = ''(builtins.getFlake "${flake}")'';
            in
            {
              nixos.expr = ''${getFlake}.nixosConfigurations.ZeNixComputa.options'';
              nixvim.expr = ''${getFlake}.packages.${pkgs.system}.neovimTraxys.options'';
              home-manager.expr = ''${getFlake}.homeConfigurations."boyerq@thinkpad-nixos".options'';
            };
        };
      };
      bashls.enable = true;
      dartls.enable = true;
      clangd = {
        enable = true;
        cmd = [
          "clangd"
          "--header-insertion=never"
        ];
      };
      tinymist.enable = true;
      efm.extraOptions = {
        init_options = {
          documentFormatting = true;
        };
        settings = {
          logLevel = 1;
        };
      };
      taplo.enable = true;
      lua_ls.enable = true;
      lemminx.enable = true;
      basedpyright.enable = true;
      ruff.enable = true;
      # TODO: Find a package
      # bitbake_ls.enable = true;
      # TODO: Find a package
      # ginko_ls.enable = true;
      mesonlsp = {
        enable = true;
        settings.root_markers = [
          [
            "meson_options.txt"
            "meson.options"
          ]
          ".git"
          "meson.build"
        ];
      };
      yamlls.enable = true;
      harper_ls = {
        enable = true;
        autostart = false;
      };
      ltex = {
        enable = true;
        onAttach.function = ''
          require("ltex_extra").setup{
            load_langs = { "en-US", "fr-FR" },
            path = ".ltex",
          }
        '';
        filetypes = [
          "bib"
          "gitcommit"
          "markdown"
          "org"
          "plaintex"
          "rst"
          "rnoweb"
          "tex"
          "pandoc"
          "typst"
          #"mail"
        ];
      };
    };
  };

  plugins.rustaceanvim = {
    enable = true;

    settings.server = {
      default_settings.rust-analyzer = {
        cargo.features = "all";
        checkOnSave = true;
        check.command = "clippy";
        rustc.source = "discover";
      };
    };
  };

  plugins.clangd-extensions = {
    enable = true;
    enableOffsetEncodingWorkaround = true;

    settings.ast = {
      role_icons = {
        type = "";
        declaration = "";
        expression = "";
        specifier = "";
        statement = "";
        "template argument" = "";
      };
      kind_icons = {
        Compound = "";
        Recovery = "";
        TranslationUnit = "";
        PackExpansion = "";
        TemplateTypeParm = "";
        TemplateTemplateParm = "";
        TemplateParamObject = "";
      };
    };
  };

  plugins.otter = {
    enable = true;
    autoActivate = false;
  };
}
