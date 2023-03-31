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
-- keymap('n', '<leader>fi', ':FzfLua files<cr>', opts)
-- keymap('n', '<leader>rg', ':FzfLua live_grep<cr>', opts)

-- Open small side explorer
keymap('n', '<leader>vs :vsplit .<cr>', ':vertical resize 40<cr>', opts)

-- PackerSync is what Plug Install  used to be (pi)
keymap('n', '<leader>pi', ':PackerSync<cr>', opts)

-- vim-for-poets: TODO

-------- leader easy edit packer plugin
keymap('n', '<leader>eV', ':NvimTreeOpen $HOME/.config/nvim/lua/<cr>', opts)
keymap('n', '<leader>idi', ':FzfLua live_grep cwd=~/.vim_runtime/dicts<cr>:sleep 100m<cr>i\\b\\b<left><left>', opts)

-------- Custom GPT4 Remaps
keymap('n', '<leader>wG', ':vs $HOME/.local/share/nvim/tmp/gpt<cr>P<esc><c-w><c-h>', opts)


--hello world


