local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- Global Plugin Remaps --
------ UndoTree
keymap('n', '<leader>u', ':UndotreeToggle<cr>', opts)

-- vim-fugitive --
keymap('n', '<leader>gh', ':diffget //3<cr>', opts)
keymap('n', '<leader>gu', ':diffget //2<cr>', opts)
keymap('n', '<leader>gs', ':G<cr>', opts)
keymap('n', '<leader>Gd', ':Gdiffsplit<cr>', opts)
keymap('n', '<leader>gd', ':Gdiff !~', opts)
keymap('n', '<leader>gc', ':Git commit<cr>', opts)

-- FZFLua --
keymap('n', '<leader>fi', ':FzfLua files<cr>', opts)
keymap('n', '<leader>rg', ':FzfLua live_grep<cr>', opts)

-- Open small side explorer
keymap('n', '<leader>vs :vsplit .<cr>', ':vertical resize 40<cr>', opts)

-- PackerSync is what Plug Install  used to be (pi)
keymap('n', '<leader>pi', ':PackerSync<cr>', opts)

-- vim-for-poets: TODO

-------- leader easy edit packer plugin
keymap('n', '<leader>ep', ':NvimTreeOpen $HOME/.config/nvim/lua/plugins<cr>', opts)

keymap('n', '<leader>idi', ':FzfLua live_grep cwd=~/.vim_runtime/dicts<cr>:sleep 1000m<cr>i\\b\\b<left><left>', opts)

-- keymap('i', '<C-x><C-x>', '<C-r>=RhymeWord()<cr>', opts)
-- keymap('n', '<leader>fi', "require(\"fzf-lua\").fzf_live(\"rg --column --colors 'match:bg:yellow' --color=always --smart-case\", { winopts = { height=0.33, width=0.66 }})", opts)
