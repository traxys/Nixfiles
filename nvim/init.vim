lua require("plugins")
lua require("misc")
lua require("tree_sitter")
lua require("lsp")
lua require("completion")
lua require("statusline")

set termguicolors
colorscheme moonfly
set number
set tabstop=4
set shiftwidth=4
set ai
set scrolloff=7
set signcolumn=yes
set cmdheight=2
set hidden

let g:tex_flavor = "latex"

set completeopt=menuone,noselect

let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
let g:indentLine_fileTypeExclude = ['markdown', 'json']

let g:grammalecte_cli_py = "/usr/bin/grammalecte-cli"
let latex_ignore = "typo_guillemets_typographiques_simples_doubles_ouvrants
	\ typo_guillemets_typographiques_simples_doubles_fermants
	\ esp_milieu_ligne"
let g:grammalecte_disable_rules = "apostrophe_typographique
	\ apostrophe_typographique_après_t
    \ espaces_début_ligne espaces_milieu_ligne
    \ espaces_fin_de_ligne
    \ typo_points_suspension1
    \ typo_tiret_incise
    \ nbsp_avant_double_ponctuation
    \ nbsp_avant_deux_points
    \ nbsp_après_chevrons_ouvrants
    \ nbsp_avant_chevrons_fermants1
    \ unit_nbsp_avant_unités1
    \ unit_nbsp_avant_unités2
    \ unit_nbsp_avant_unités3 
    \ typo_espace_manquant_après2" . latex_ignore

let g:languagetool_cmd='/usr/bin/languagetool'
let g:languagetool_lang="fr"

nnoremap <silent> bp <cmd>Telescope buffers<CR>
nnoremap <silent> ca <cmd>Telescope lsp_code_actions<CR>
nnoremap <silent> gr <cmd>Telescope lsp_references<CR>
nnoremap <silent> gW <cmd>Telescope lsp_workspace_symbols<CR>
nnoremap <silent> gF <cmd>Telescope lsp_document_symbols<CR>
nnoremap <silent> ft <cmd>Telescope file_browser<CR>
nnoremap <silent> ge <cmd>Telescope lsp_document_diagnostics<CR>
nnoremap <silent> mn <cmd>Telescope man_pages sections=1,3,5<CR>
nnoremap <silent> fg <cmd>Telescope git_files<CR>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ff <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <C-s> <cmd>Telescope spell_suggest<CR>

nnoremap <silent> mk <cmd>Telescope keymaps<CR>
command SpellFr setlocal spell spelllang=fr

autocmd BufNewFile,BufRead *.nix set ft=nix

"syntax enable
filetype plugin indent on
set omnifunc=v:lua.vim.lsp.omnifunc

set updatetime=300
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{}
