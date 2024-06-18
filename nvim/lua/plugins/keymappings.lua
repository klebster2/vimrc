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
keymap('n', '<leader>ee', ':WiktionaryEtymology<cr>', opts)

--- Plugin: Telescope
keymap('n', '<leader>ff', "<cmd>Telescope find_files<cr>", opts)
keymap('n', '<leader>f', "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({previewer=false}))<cr>", opts)
keymap('n', '<c-t>', "<cmd>Telescope live_grep<cr>", opts)

-- perl -pe 'use POSIX qw(strftime); s/^#(\d+)/strftime "#%F %H:%M:%S", localtime($1)/e' "$1"
keymap('n', '<leader>ebh', ":new<cr>:r!perl -pe 'use POSIX qw(strftime); s/^\\#(\\d+)/strftime \"\\#\\%F \\%H:\\%M:\\%S\", localtime($1)/e' $HISTFILE<cr>", opts)
-- keymap('n', '<leader>ebh', ':new<cr>:r!cat $HISTFILE<cr>', opts)

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
