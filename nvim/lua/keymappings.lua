vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Keymaps
-- Move between windows
keymap('n', '<leader>h', ':wincmd h<CR>', opts)
keymap('n', '<leader>j', ':wincmd j<CR>', opts)
keymap('n', '<leader>k', ':wincmd k<CR>', opts)
keymap('n', '<leader>l', ':wincmd l<CR>', opts)

keymap('n', '<leader>vx', ':Vex<CR>', opts)
keymap('n', '<leader>sx', ':Sex<CR>', opts)

-- Indentation
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- jk to ESC
keymap('i', 'jk', '<ESC>', opts)
-- and for butterfingers
keymap('i', 'kj', '<ESC>', opts)

-- line numbers
keymap('n', '<leader>sn', ':set number!<cr>', opts)
keymap('n', '<leader>srn', ':set relativenumber!<cr>', opts)
-- viewing behaviour
keymap('n', '<leader>sw', ':set wrap!<cr>', opts)
-- paste behaviour
keymap('n', '<leader>sp', ':set paste!<cr>', opts)
-- easy source
keymap('n', '<leader>sv', ':source ~/.config/nvim/init.lua<cr>:edit<cr>', opts)
-- scrollbind for scrolling multiple files
keymap('n', '<leader>sb', ':set scrollbind!<cr>', opts)
vim.api.nvim_command("command! Wq :wq")

-- Plugin Remaps --
-- undotree side explorer

keymap('n', '<leader>u', ':UndotreeShow<CR><C-w>j:q<CR>', opts)

-- vim-fugitive:
keymap('n', '<leader>gh', ':diffget //3<CR>', opts)
keymap('n', '<leader>gu', ':diffget //2<CR>', opts)
keymap('n', '<leader>gs', ':G<CR>', opts)
keymap('n', '<leader>Gd', ':Gdiffsplit<CR>', opts)
keymap('n', '<leader>gd', ':Gdiff !~', opts)
keymap('n', '<leader>gc', ':Git commit<CR>', opts)

-- vim-for-poets:
keymap('i', '<C-x><C-x>', '<C-r>=RhymeWord()<cr>', opts)

