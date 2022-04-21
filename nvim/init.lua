--3 types of config opts
--
-- global: vim.o
require('options')
require('plugins')
require('keymappings')
require('nvim-tree-cfg')
require('nvim-compe-cfg')
require('lsp')
require('lsp.lua-ls')

--lua require'lspconfig'.pyls.setup{on_attach=require'completion'.on_attach}

--vim.g.colors_name = 'gruvbox'
-- empty setup using defaults: add your own options

