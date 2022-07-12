local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- Global Plugin Remaps --
-- undotree side explorer
keymap('n', '<leader>u', ':UndotreeShow<cr><C-w>j:q<cr>', opts)

-- vim-fugitive:
keymap('n', '<leader>gh', ':diffget //3<cr>', opts)
keymap('n', '<leader>gu', ':diffget //2<cr>', opts)
keymap('n', '<leader>gs', ':G<cr>', opts)
keymap('n', '<leader>Gd', ':Gdiffsplit<cr>', opts)
keymap('n', '<leader>gd', ':Gdiff !~', opts)
keymap('n', '<leader>gc', ':Git commit<cr>', opts)

-- vim-for-poets:
-- keymap('i', '<C-x><C-x>', '<C-r>=RhymeWord()<cr>', opts)


-- FZF --
keymap('n', '<leader>Fi', ':Files<cr>', opts)
