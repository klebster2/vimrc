-- Mappings.

-- (See https://github.com/neovim/nvim-lspconfig/README.md)
vim.lsp.set_log_level("debug")

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local keymap = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
