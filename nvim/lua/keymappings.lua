local vim = vim
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

--- Define leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ";"

--- Native Vim Keymaps (No plugins should be needed)
---- Normal mode remaps
---- 1. Jump to keymapping file (this file):
keymap('n' , '<leader>m', ':e $HOME/.config/nvim/lua/keymappings.lua<cr>', opts)
---- 2. Try to simplify resizing splits
if vim.fn.has('unix') then
  -- use ctrl
  keymap('n', 'j', '<C-w>-5', opts)
  keymap('n', 'k', '<C-w>+5', opts)
  keymap('n', 'h', '<C-w><5', opts)
  keymap('n', 'l', '<C-w>>5', opts)
else
  -- use alt key
  keymap('n', '<M-j>', '<C-w>-', opts)
  keymap('n', '<M-k>', '<C-w>+', opts)
  keymap('n', '<M-h>', '<C-w><', opts)
  keymap('n', '<M-l>', '<C-w>>', opts)
end
---- 3. Move between windows
keymap('n', '<leader>h', ':wincmd h<CR>', opts)
keymap('n', '<leader>j', ':wincmd j<CR>', opts)
keymap('n', '<leader>k', ':wincmd k<CR>', opts)
keymap('n', '<leader>l', ':wincmd l<CR>', opts)

---- 4. Visual (vertical) split
keymap('n', '<leader>vx', ':vs .<CR>', opts)

---- 5. Leader Window closing remaps
keymap('n', '<leader>o', ':only<cr>', opts)

---- 6. Line Numbers
keymap('n', '<leader>sn', ':set number!<cr>', opts)
keymap('n', '<leader>srn', ':set relativenumber!<cr>', opts)

---- 7. Viewing Behaviour
keymap('n', '<leader>sw', ':set wrap!<cr>', opts)
------ Paste behaviour pasting rather than following commands in insertmode
keymap('n', '<leader>sp', ':set paste!<cr>', opts)
------ No highlight search (turn off)
keymap('n', '<leader>nhl', ':set no hlsearch<cr>', opts)

---- 8. nvim init opts
-------- easy source
keymap(
  'n',
  '<leader>sv',
  ':source $HOME/.config/nvim/init.lua<cr>:echom "$HOME/.config/nvim/init.lua was sourced"<cr>',
  opts
)
-------- easy vimrc (init.lua) edit
keymap('n', '<leader>ev', ':vertical split $HOME/.config/nvim/init.lua<cr>:edit<cr>', opts)
-------- edit packer plugin installations
keymap('n', '<leader>ep', ':vs $HOME/.config/nvim/lua/packer-startup.lua<cr>', opts)
-------- scrollbind for scrolling multiple files
keymap('n', '<leader>sb', ':set scrollbind!<cr>', opts)

---- 9. Tab remaps
keymap('n', '<leader>tp', ':tabprev<cr>', opts)
keymap('n', '<leader>tn', ':tabnext<cr>', opts)
keymap('n', '<leader>tt', ':tabnew<cr>', opts)
keymap('n', '<leader>tc', ':tabclose<cr>', opts)

------ Insert datetime
keymap('n', '<leader>dt', ":put =strftime('%d/%m/%y %H:%M:%S')<cr>", opts)

------ Visual mode remaps
------ Indentation
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

--- base64 encoding
keymap('v', '<leader>e64', 'c<c-r>=system(\'base64 \', @")<cr><esc>', opts)
--- base64 decoding
keymap('v', '<leader>d64', 'c<c-r>=system(\'base64 --decode\', @")<cr><esc>', opts)

------ Quote text in Visual mode
-------- TODO: use https://github.com/tpope/vim-surround

---- Insert mode remaps
------ jk to ESC
keymap('i', 'jk', '<ESC>', opts)
------ and for butterfingers
keymap('i', 'kj', '<ESC>', opts)

------ Sane escape from insert mode (Ctrl-C)
keymap('i', '<c-c>', '<ESC>', opts)

------ Command Mode Mappings {{
-------- expand current script path and open
keymap('c', '%%', "<C-R>=expand('%:p:h').'/'<cr><cr><C-Left>", opts)

---- " Leader write with permissions ------------- {{{
keymap('c', 'w!!', 'w !sudo tee > /dev/null %', opts)
keymap('c', 'Vs', 'vs', opts)

------ Operator mappings
-------- more operator pending mappings (change inside next email address)
keymap('o', 'in@', ':<c-u>execute "normal! ?^.+@$\rvg_"<cr>', opts)
keymap('o', 'an@', ':<c-u>execute "normal! ?^\\S\\+@\\S\\+$\r:nohlsearch\r0vg"<cr>', opts)

------ Command remaps
-------- forgive :Wq, :WQ (Write and quit)
vim.api.nvim_command("command! Wq :wq")
vim.api.nvim_command("command! WQ :wq")
-------- and Q
vim.api.nvim_command("command! Q :q")

------ Spell
keymap('n', '<leader>ss', ':set spell!<cr>', opts)

------ What the commit?
-------- Random commit message
keymap('n', '<leader>wtc', ":r!curl -s 'https://whatthecommit.com/index.txt'<cr>", opts)
