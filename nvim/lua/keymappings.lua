local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Native Vim Keymaps (No plugins should be needed)
---- Move between windows
keymap('n', '<leader>h', ':wincmd h<CR>', opts)
keymap('n', '<leader>j', ':wincmd j<CR>', opts)
keymap('n', '<leader>k', ':wincmd k<CR>', opts)
keymap('n', '<leader>l', ':wincmd l<CR>', opts)

keymap('n', '<leader>vx', ':Vex<CR>', opts)
keymap('n', '<leader>sx', ':Sex<CR>', opts)

---- Visual mode remaps
------ Indentation
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

------ Quote text in Visual mode
-------- TODO: use https://github.com/tpope/vim-surround

---- Insert mode remaps
------ jk to ESC
keymap('i', 'jk', '<ESC>', opts)
------ and for butterfingers
keymap('i', 'kj', '<ESC>', opts)

---- Normal mode remaps
------ line numbers
keymap('n', '<leader>sn', ':set number!<cr>', opts)
keymap('n', '<leader>srn', ':set relativenumber!<cr>', opts)
------ viewing behaviour
keymap('n', '<leader>sw', ':set wrap!<cr>', opts)
------ paste behaviour pasting rather than following commands in insertmode
keymap('n', '<leader>sp', ':set paste!<cr>', opts)
------ no highlight search (turn off)
keymap('n', '<leader>nhl', ':set no hlsearch<cr>', opts)

------ nvim init opts
-------- easy source
keymap('n', '<leader>sv', ':source ~/.config/nvim/init.lua<cr>:edit<cr>', opts)
-------- easy vimrc (init.lua) edit
keymap('n', '<leader>ev', ':vertical split ~/.config/nvim/init.lua<cr>:edit<cr>', opts)
-------- easy packer plugin edit
keymap('n', '<leader>ep', ':vertical split ~/.config/nvim/lua/plugins <cr>:edit<cr>', opts)
-------- scrollbind for scrolling multiple files
keymap('n', '<leader>sb', ':set scrollbind!<cr>', opts)

------ Command remaps
-------- forgive :Wq
vim.api.nvim_command("command! Wq :wq")
-------- and Q
vim.api.nvim_command("command! Q :q")

------ What the commit?
-------- Random commit message
keymap('n', '<leader>wtc', ":r!curl -s 'http://whatthecommit.com/index.txt'<cr>", opts)
-------- insert datetime
keymap('n', '<leader>dt', ":put =strftime('%d/%m/%y %H:%M:%S')<cr>", opts)


------ C Mode
-------- expand current script path     
keymap('c', '%%', "<C-R>=expand('%:h').'/'<cr>", opts)

-------- enable creation of newlines in normal mode
keymap('n', '<c-o>', '<esc>o<esc>', opts)
keymap('n', '<c-O>', '<esc>O<esc>', opts)
-------- hard H and L remaps
keymap('n', 'H', '0w', opts)
keymap('n', 'L', '$', opts)
keymap('n', 's', 'i<cr><esc>', opts)
