require("options")
require("keymappings")

require("plugins")
require("plugins.packer-startup")
require("plugins.keymappings")

require("autocmds")

require("nvim-compe-cfg")
require("nvim-tree-cfg")

require("lsp")
require("lsp.lua-ls")
require("lsp.keymappings")

vim.api.nvim_exec(
[[
set background=dark
colorscheme gruvbox
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_unite = 1
let g:WebDevIconsOS = 'Windows'

]],
true)
