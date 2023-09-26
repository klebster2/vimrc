vim = vim
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

--- Global Plugin Remaps --
------ UndoTree
keymap('n', '<leader>u', ':UndotreeToggle<cr>', opts)

--- vim-fugitive --
keymap('n', '<leader>gh', ':diffget //3<cr>', opts)
keymap('n', '<leader>gu', ':diffget //2<cr>', opts)
keymap('n', '<leader>gs', ':G<cr>', opts)
keymap('n', '<leader>Gd', ':Gdiffsplit<cr>', opts)
keymap('n', '<leader>gd', ':Gdiff !~', opts)
keymap('n', '<leader>gc', ':Git commit<cr>', opts)
keymap('n', '<leader>ga', ':Git add %<cr>', opts)

--- FZFLua --
--- keymap('n', '<leader>fi', ':FzfLua files<cr>', opts)
--- keymap('n', '<leader>rg', ':FzfLua live_grep<cr>', opts)

--- Open small side explorer
keymap('n', '<leader>vs', ':NvimTreeOpen .<cr>:vertical resize 40<cr>', opts)

--- PackerSync is what Plug Install  used to be (pi)
keymap('n', '<leader>pi', ':PackerSync<cr>', opts)

-------- leader easy edit packer plugin
keymap('n', '<leader>eV', ':NvimTreeOpen $HOME/.config/nvim/lua/<cr>', opts)
keymap('n', '<leader>ebf', ':vsplit $HOME/.bash_functions<cr>', opts)


-------- Custom GPT remap
--- keymap('n', '<leader>wg', ':vs $HOME/.local/share/nvim/tmp/gpt<cr>PjdG<esc><c-w><c-h>', opts)

keymap('n', '<leader>ebh', ':vs .<cr>:r!echo "history" | bash -i 2>/dev/null | sed -e "s/\x1b\\[.//g"', opts)

--- Get Etymology
keymap('n', '<leader>ze', ':WiktionaryParser english etymology<cr>', opts)
keymap('n', '<silent><script><expr> <C-J>', 'copilot#Accept("\\<CR>")', opts)

--- Telescope
keymap('n', '<leader>ff', "<cmd>Telescope find_files<cr>", opts)
--keymap('n', '<leader>f', "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({previewer=false}))<cr>", opts)
keymap('n', '<c-t>', "<cmd>Telescope live_grep<cr>", opts)
