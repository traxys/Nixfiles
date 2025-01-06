{
  pkgs,
  config,
  helpers,
  lib,
  ...
}:
{
  imports = [
    ./lsp.nix
    ./notes.nix
    ./completion.nix

    ./modules/commands.nix

    ./plugins/headerguard.nix
    ./plugins/lsp-signature.nix
    ./plugins/diagram-nvim.nix
  ];

  colorschemes.tokyonight = {
    settings.style = "night";
    enable = true;
  };

  plugins.mini = {
    enable = true;
    modules.icons = { };
    mockDevIcons = true;
  };

  performance = {
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      configs = true;
      plugins = true;
    };
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        "vimplugin-treesitter-grammar-nix"
        "nvim-treesitter"
        "openscad.nvim"
        "yanky.nvim"
      ];
    };
  };

  plugins.lz-n.enable = true;

  autoGroups.BigFileOptimizer = { };
  autoCmd = [
    {
      event = "BufReadPost";
      pattern = [
        "*.md"
        "*.rs"
        "*.lua"
        "*.sh"
        "*.bash"
        "*.zsh"
        "*.js"
        "*.jsx"
        "*.ts"
        "*.tsx"
        "*.c"
        ".h"
        "*.cc"
        ".hh"
        "*.cpp"
        ".cph"
      ];
      group = "BigFileOptimizer";
      callback = helpers.mkRaw ''
        function(auEvent)
          local bufferCurrentLinesCount = vim.api.nvim_buf_line_count(0)

          if bufferCurrentLinesCount > 2048 then
            vim.notify("bigfile: disabling features", vim.log.levels.WARN)

            vim.cmd("TSBufDisable refactor.highlight_definitions")
        vim.g.matchup_matchparen_enabled = 0
        require("nvim-treesitter.configs").setup({
         matchup = {
           enable = false
         }
        })
          end
        end
      '';
    }
  ];

  globals = {
    neo_tree_remove_legacy_commands = 1;
    mapleader = " ";
  };

  opts = {
    termguicolors = true;
    number = true;
    tabstop = 4;
    shiftwidth = 4;
    scrolloff = 7;
    signcolumn = "yes";
    cmdheight = 2;
    pumheight = 15;
    cot = [
      "menu"
      "menuone"
      "noselect"
    ];
    updatetime = 100;
    colorcolumn = "100";
    # Too many false positives
    spell = false;
    listchars = "tab:>-,lead:·,nbsp:␣,trail:•";
    fsync = true;

    timeout = true;
    timeoutlen = 300;
  };

  commands = {
    "SpellFr" = "setlocal spelllang=fr";
  };

  filetype = {
    filename = {
      Jenkinsfile = "groovy";
    };
    extension = {
      lalrpop = "lalrpop";
    };
  };

  keymaps =
    let
      modeKeys =
        mode:
        lib.attrsets.mapAttrsToList (
          key: action:
          { inherit key mode; } // (if builtins.isString action then { inherit action; } else action)
        );
      nm = modeKeys [ "n" ];
    in
    helpers.keymaps.mkKeymaps { options.silent = true; } (nm {
      "ft" = "<cmd>Neotree<CR>";
      "fG" = "<cmd>Neotree git_status<CR>";
      "fR" = "<cmd>Neotree remote<CR>";
      "fc" = "<cmd>Neotree close<CR>";
      "bp" = "<cmd>Telescope buffers<CR>";

      "<C-s>" = "<cmd>Telescope spell_suggest<CR>";
      "mk" = "<cmd>Telescope keymaps<CR>";
      "fg" = "<cmd>Telescope git_files<CR>";

      "gr" = "<cmd>Telescope lsp_references<CR>";
      "gI" = "<cmd>Telescope lsp_implementations<CR>";
      "gW" = "<cmd>Telescope lsp_workspace_symbols<CR>";
      "gF" = "<cmd>Telescope lsp_document_symbols<CR>";
      "ge" = "<cmd>Telescope diagnostics bufnr=0<CR>";
      "gE" = "<cmd>Telescope diagnostics<CR>";

      "<leader>h" = {
        action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
        options = {
          desc = "toggle inlay hints";
        };
      };
      "yH" = {
        action = "<Cmd>Telescope yank_history<CR>";
        options.desc = "history";
      };
      "<leader>wS" = {
        action = helpers.mkRaw ''
          function()
            require('telescope.builtin').live_grep({
              cwd = "~/wiki",
              glob_pattern = "*.md"
            })
          end
        '';
        options.desc = "search in wiki";
      };
      "<leader>Y" = {
        action = helpers.mkRaw ''
          function ()
            vim.go.operatorfunc = "v:lua.osc52_yank_cb";
            local yank = require('vim.ui.clipboard.osc52').copy('+')
          end
        '';
        options = {
          desc = "yank through osc52";
          expr = true;
        };
      };
    })
    ++ [
      {
        key = "<leader>rn";
        mode = [ "n" ];
        action = helpers.mkRaw ''
          function()
          	return ":IncRename " .. vim.fn.expand("<cword>")
          end
        '';
        options.expr = true;
      }
    ];

  plugins.nvim-osc52 = {
    enable = true;
    package = pkgs.vimPlugins.nvim-osc52;
    keymaps.enable = true;
  };

  plugins.gitsigns.enable = true;
  plugins.gitmessenger.enable = true;

  # plugins.firenvim.enable = false;

  plugins.telescope = {
    enable = true;
    extensions = {
      ui-select.enable = true;
    };
    settings = {
      defaults.layout_strategy = "vertical";
    };
  };

  plugins.treesitter = {
    enable = true;

    settings = {
      indent.enable = true;
      highlight.enable = true;
    };

    nixvimInjections = true;

    grammarPackages = with config.plugins.treesitter.package.passthru.builtGrammars; [
      arduino
      asm
      bash
      bitbake
      c
      cpp
      cuda
      dart
      devicetree
      diff
      dockerfile
      editorconfig
      fish
      gitattributes
      gitcommit
      gitignore
      git_rebase
      groovy
      html
      ini
      json
      just
      lalrpop
      latex
      linkerscript
      lua
      make
      markdown
      markdown_inline
      mermaid
      meson
      ninja
      nix
      printf
      python
      regex
      rst
      rust
      slint
      sql
      tlaplus
      toml
      typst
      vim
      vimdoc
      xml
      yaml
      zig
    ];
  };

  plugins.treesitter-refactor = {
    enable = true;
    highlightDefinitions = {
      enable = true;
      clearOnCursorMove = true;
    };
    smartRename = {
      enable = true;
    };
    navigation = {
      enable = true;
    };
  };

  plugins.treesitter-context = {
    enable = true;
  };

  plugins.vim-matchup = {
    treesitter = {
      enable = true;
      include_match_words = true;
    };
    enable = true;
  };
  plugins.headerguard.enable = true;

  plugins.comment = {
    enable = true;
  };

  plugins.neo-tree = {
    enable = true;
  };

  plugins.plantuml-syntax.enable = true;

  plugins.indent-blankline = {
    enable = true;

    settings = {
      scope = {
        enabled = true;

        show_start = true;
      };
    };
  };

  plugins.typst-vim.enable = true;

  plugins.lualine = {
    enable = true;
  };

  plugins.trouble = {
    enable = true;
    lazyLoad.settings.cmd = "Trouble";
  };

  plugins.noice = {
    enable = true;

    settings = {
      messages = {
        view = "mini";
        view_error = "mini";
        view_warn = "mini";
      };

      lsp.override = {
        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        "vim.lsp.util.stylize_markdown" = true;
        "cmp.entry.get_documentation" = true;
      };
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = true;
        lsp_doc_border = false;
      };
    };
  };

  plugins.openscad = {
    enable = false;
    settings = {
      load_snippets = true;
    };
  };

  plugins.snacks.enable = true;

  extraConfigLuaPre = lib.mkBefore ''
    if vim.env.PROF then
      require("snacks.profiler").startup({
        startup = {
          event = "VimEnter"
        }
      })
    end
  '';

  extraConfigLuaPost = ''
    require("luasnip.loaders.from_snipmate").lazy_load()

    require("cmp_git").setup({})

    -- debug.sethook(function()
    --     local file = io.open("/home/traxys/nvim_bt", "a")
    --     file:write(debug.traceback("backtrace"))
    --     file:close()
    -- end, "c", 43)
  '';

  plugins.which-key.enable = true;

  plugins.leap.enable = true;

  plugins.yanky = {
    enable = true;
    settings.picker.telescope = {
      useDefaultMappings = true;
      enable = true;
    };
  };

  files."ftplugin/nix.lua" = {
    opts = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };
    extraConfigLua = ''
      vim.lsp.inlay_hint.enable(true)
    '';
  };

  files."ftdetect/sql.lua" = {
    globals.omni_sql_no_default_maps = 0;
    globals.omni_sql_default_compl_type = "syntax";
  };

  extraPackages = with pkgs; [
    # sca2d
    djlint
    muon
    gh
  ];

  extraPlugins = with pkgs.vimPlugins; [
    telescope-ui-select-nvim
    vim-snippets
    vim-just
    ltex_extra-nvim
    vim-wakatime
  ];
}
