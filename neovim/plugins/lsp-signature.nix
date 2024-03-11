{
  config,
  lib,
  pkgs,
  helpers,
  ...
}:
with lib; {
  options.plugins.lsp_signature = {
    enable = mkEnableOption "lsp_signature, a plugin to show function signatures";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.lsp_signature-nvim;
      description = "Package to use for lsp_signature";
    };

    debug = {
      enable = helpers.defaultNullOpts.mkBool false "set to true to enable debug logging";
      logPath =
        helpers.defaultNullOpts.mkNullable types.str
        ''vim.fn.stdpath("cache") .. "/lsp_signature.log"'' "log dir when debug is on";
      verbose = helpers.defaultNullOpts.mkBool false "show debug line number";
    };

    bind = helpers.defaultNullOpts.mkBool true ''
      This is mandatory, otherwise border config won't get registered.
      If you want to hook lspsaga or other signature handler, pls set to false
    '';

    docLines = helpers.defaultNullOpts.mkInt 10 ''
      will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
      set to 0 if you DO NOT want any API comments be shown
      This setting only take effect in insert mode, it does not affect signature help in normal
      mode.
    '';

    maxHeight = helpers.defaultNullOpts.mkInt 12 "max height of signature floating_window";
    maxWidth = helpers.defaultNullOpts.mkInt 82 "max_width of signature floating_window";
    noice = helpers.defaultNullOpts.mkBool false "set to true if you using noice to render markdown";
    wrap = helpers.defaultNullOpts.mkBool true ''
      allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too
      long
    '';

    floatingWindow = {
      enable = helpers.defaultNullOpts.mkBool true ''
        show hint in a floating window, set to false for virtual text only mode
      '';

      aboveCurLine = helpers.defaultNullOpts.mkBool true ''
        try to place the floating above the current line when possible
        Note:
            will set to true when fully tested, set to false will use whichever side has more space
          	this setting will be helpful if you do not want the PUM and floating win overlap
      '';

      # NOTE: this could be functions, if need be we can adjust the types
      offX = helpers.defaultNullOpts.mkInt 1 "adjust float windows x position";
      offY = helpers.defaultNullOpts.mkInt 0 ''
        adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
      '';
    };

    closeTimeout = helpers.defaultNullOpts.mkInt 4000 ''
      close floating window after ms when laster parameter is entered
    '';

    fixPos = helpers.defaultNullOpts.mkBool false ''
      set to true, the floating window will not auto-close until finish all parameters
    '';

    hint = {
      enable = helpers.defaultNullOpts.mkBool true "virtual hint enable";
      prefix = helpers.defaultNullOpts.mkStr "🐼 " ''
        Panda for parameter, NOTE: for the terminal not support emoji, might crash
      '';
      scheme = helpers.defaultNullOpts.mkStr "String" "";
    };

    hiParameter =
      helpers.defaultNullOpts.mkStr "LspSignatureActiveParameter"
      "how your parameter will be highlight";

    handlerOpts = {
      border = let
        bordersTy =
          types.enum ["double" "rounded" "single" "shadow" "none"];
      in
        helpers.defaultNullOpts.mkNullable (types.either bordersTy (types.listOf bordersTy))
        ''"rounded"'' "";
    };

    alwaysTrigger = helpers.defaultNullOpts.mkBool false ''
      sometime show signature on new line or in middle of parameter can be confusing, set it to
      false for #58
    '';

    autoCloseAfter = helpers.defaultNullOpts.mkNullable types.int "null" ''
      autoclose signature float win after x sec, disabled if nil.
    '';
    extraTriggerChars = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Array of extra characters that will trigger signature completion, e.g., ["(" ","]
    '';
    zindex = helpers.defaultNullOpts.mkInt 200 ''
      by default it will be on top of all floating windows, set to <= 50 send it to bottom
    '';

    padding = helpers.defaultNullOpts.mkStr "" ''
      character to pad on left and right of signature can be " ", or "|"  etc
    '';

    transparency = helpers.defaultNullOpts.mkNullable types.int "null" ''
      disabled by default, allow floating win transparent value 1~100
    '';
    shadowBlend = helpers.defaultNullOpts.mkInt 36 ''
      if you using shadow as border use this set the opacity
    '';
    shadowGuibg = helpers.defaultNullOpts.mkStr "Black" ''
      if you using shadow as border use this set the color e.g. "Green" or "#121315"
    '';
    timerInterval = helpers.defaultNullOpts.mkInt 200 ''
      default timer check interval set to lower value if you want to reduce latency
    '';
    toggleKey = helpers.defaultNullOpts.mkNullable types.str "null" ''
      toggle signature on and off in insert mode,  e.g. "<M-x>"
    '';

    selectSignatureKey = helpers.defaultNullOpts.mkNullable types.str "null" ''
      cycle to next signature, e.g. "<M-n>" function overloading
    '';

    moveCursorKey = helpers.defaultNullOpts.mkNullable types.str "null" ''
      imap, use nvim_set_current_win to move cursor between current win and floating
    '';
  };

  config = let
    cfg = config.plugins.lsp_signature;
    setupOptions = {
      debug = cfg.debug.enable;
      log_path = cfg.debug.logPath;
      verbose = cfg.debug.verbose;

      bind = cfg.bind;
      doc_lines = cfg.docLines;
      max_height = cfg.maxHeight;
      noice = cfg.noice;

      floating_window = cfg.floatingWindow.enable;
      floating_window_above_cur_line = cfg.floatingWindow.aboveCurLine;
      floating_window_off_x = cfg.floatingWindow.offX;
      floating_window_off_y = cfg.floatingWindow.offY;

      close_timeout = cfg.closeTimeout;
      fix_pos = cfg.fixPos;

      hint_enable = cfg.hint.enable;
      hint_prefix = cfg.hint.prefix;
      hint_scheme = cfg.hint.scheme;

      hi_parameter = cfg.hiParameter;
      handle_opts = {border = cfg.handlerOpts.border;};

      always_trigger = cfg.alwaysTrigger;
      auto_close_after = cfg.autoCloseAfter;
      extra_trigger_chars = cfg.extraTriggerChars;
      zindex = cfg.zindex;

      padding = cfg.padding;

      transparency = cfg.transparency;
      shadow_blend = cfg.shadowBlend;
      shadow_guibg = cfg.shadowGuibg;
      timer_interval = cfg.timerInterval;
      toggle_key = cfg.toggleKey;

      select_signature_key = cfg.selectSignatureKey;
      move_cursor_key = cfg.moveCursorKey;
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require("lsp_signature").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
