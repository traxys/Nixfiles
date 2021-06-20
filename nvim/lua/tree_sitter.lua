require'nvim-treesitter.configs'.setup {
    ensure_installed = {"rust", "c", "cpp", "json", "lua", "python", "toml", "latex", "nix"},
	highlight = {
		enable = true,                 -- false will disable the whole extension
		disable = {"elixir", "teal"},  -- list of language that will be disabled
	},
	refactor = {
		highlight_definitions = { enable = true },
		highlight_current_scope = { enable = false },
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "grr",
			},
		},
	},
}

