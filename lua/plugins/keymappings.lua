local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

--- Global Plugin Remaps --
--- Plugin: UndoTree
keymap('n', '<leader>u', ':UndotreeToggle<cr>', opts)

--- Plugin: vim-fugitive --
keymap('n', '<leader>gh', ':diffget //3<cr>', opts)
keymap('n', '<leader>gu', ':diffget //2<cr>', opts)
keymap('n', '<leader>gs', ':G<cr>', opts)
keymap('n', '<leader>Gd', ':Gdiffsplit<cr>', opts)
keymap('n', '<leader>gd', ':Gdiff !~', opts)
keymap('n', '<leader>gc', ':Git commit<cr>', opts)
keymap('n', '<leader>ga', ':Git add %<cr>', opts)

--- Open small side explorer
keymap('n', '<leader>vs', ':NvimTreeOpen .<cr>:vertical resize 40<cr>', opts)

--- PackerSync is what Plug Install  used to be (pi)
keymap('n', '<leader>pi', ':PackerSync<cr>', opts)

-------- leader easy edit packer plugin
keymap('n', '<leader>eV', ':NvimTreeOpen $HOME/.config/nvim/lua/<cr>', opts)
keymap('n', '<leader>ebf', ':vsplit $HOME/.bash_functions<cr>', opts)

--- Get Etymology
--keymap('n', '<leader>ee', ':WiktionaryEtymology<cr>', opts)

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Fzf-Lua Mappings
vim.keymap.set("n", "<c-F>", require('fzf-lua').files, { desc = "Fzf Files" })
vim.keymap.set("n", "<c-T>", require('fzf-lua').helptags, { desc = "Fzf helptags" })
vim.keymap.set("n", "<c-X>", require('fzf-lua').grep_cword, { desc = "Fzf Live Grep on CWORD" })

-- Go to this file: ( <leader>epm )
keymap('n', '<leader>epm', ':e ~/.config/nvim/lua/plugins/keymappings.lua<cr>', opts)
