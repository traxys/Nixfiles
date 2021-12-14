vim.o.termguicolors = true
vim.cmd("colorscheme moonfly")

require("tree_sitter")
require("lsp")
require("completion")
require("statusline")

require('gitsigns').setup()

vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.ai = true
vim.o.scrolloff = 7
vim.o.signcolumn = "yes"
vim.o.cmdheight = 2
vim.o.hidden = true

vim.g.tex_flavor = "latex"

vim.o.completeopt = "menuone,noselect"

vim.g.indentLine_concealcursor = "inc"
vim.g.indentLine_conceallevel = 2
vim.g.indentLine_fileTypeExclude = { "markdown", "json" }

vim.g.grammalecte_cli_py = "/usr/bin/grammalecte-cli"
latex_ignore = [[
	typo_guillemets_typographiques_simples_doubles_ouvrants
	typo_guillemets_typographiques_simples_doubles_fermants
	esp_milieu_ligne
]]
vim.g.grammalecte_disable_rules = [[ apostrophe_typographique
	apostrophe_typographique_après_t
    espaces_début_ligne espaces_milieu_ligne
    espaces_fin_de_ligne
    typo_points_suspension1
    typo_tiret_incise
    nbsp_avant_double_ponctuation
    nbsp_avant_deux_points
    nbsp_après_chevrons_ouvrants
    nbsp_avant_chevrons_fermants1
    unit_nbsp_avant_unités1
    unit_nbsp_avant_unités2
    unit_nbsp_avant_unités3
    typo_espace_manquant_après2 ]] .. latex_ignore

vim.g.languagetool_cmd = "/usr/bin/languagetool"
vim.g.languagetool_lang = "fr"

vim.api.nvim_set_keymap("n", "bp", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ca", "<cmd>Telescope lsp_code_actions<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gW", "<cmd>Telescope lsp_workspace_symbols<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gF", "<cmd>Telescope lsp_document_symbols<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ft", "<cmd>Telescope file_browser<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ge", "<cmd>Telescope diagnostics bufnr=0<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gE", "<cmd>Telescope diagnostics<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "mn", "<cmd>Telescope man_pages sections=1,3,5<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "fg", "<cmd>Telescope git_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K ", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-s>", "<cmd>Telescope spell_suggest<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "mk", "<cmd>Telescope keymaps<CR>", { noremap = true, silent = true })

vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"
vim.o.updatetime = 300

require("nvim-web-devicons").setup({ default = true })
require("filetype").setup({
	overrides = {
		extensions = {
			nix = "nix",
			rsh = "rsh",
		},
	},
})

--autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

vim.cmd([[
command SpellFr setlocal spell spelllang=fr

filetype plugin indent on

autocmd CursorHold * lua vim.diagnostic.open_float()
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{}
]])
