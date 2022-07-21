local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- Native Vim Keymaps (No plugins should be needed)
---- Normal mode remaps
---- try to simplify resizing splits
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
---- Move between windows
keymap('n', '<leader>h', ':wincmd h<CR>', opts)
keymap('n', '<leader>j', ':wincmd j<CR>', opts)
keymap('n', '<leader>k', ':wincmd k<CR>', opts)
keymap('n', '<leader>l', ':wincmd l<CR>', opts)
---- Visual splits
keymap('n', '<leader>vx', ':vs .<CR>', opts)
keymap('n', '<leader>sx', ':Ss .<CR>', opts)
---- Leader Window closing remaps
keymap('n', '<leader>o', ':only<cr>', opts)

----- Line Numbers
keymap('n', '<leader>sn', ':set number!<cr>', opts)
keymap('n', '<leader>srn', ':set relativenumber!<cr>', opts)
------ Viewing Behaviour
keymap('n', '<leader>sw', ':set wrap!<cr>', opts)
------ Paste behaviour pasting rather than following commands in insertmode
keymap('n', '<leader>sp', ':set paste!<cr>', opts)
------ No highlight search (turn off)
keymap('n', '<leader>nhl', ':set no hlsearch<cr>', opts)

------ nvim init opts
-------- easy source
keymap('n', '<leader>sv', ':source $HOME/.config/nvim/init.lua<cr>', opts)
-------- easy vimrc (init.lua) edit
keymap('n', '<leader>ev', ':vertical split $HOME/.config/nvim/init.lua<cr>:edit<cr>', opts)
-------- scrollbind for scrolling multiple files
keymap('n', '<leader>sb', ':set scrollbind!<cr>', opts)

------ Tab remaps
keymap('n', '<leader>tp', ':tabprev<cr>', opts)
keymap('n', '<leader>tn', ':tabnext<cr>', opts)
keymap('n', '<leader>tt', ':tabnew<cr>', opts)

------ What the commit?
-------- Random commit message
keymap('n', '<leader>wtc', ":r!curl -s 'http://whatthecommit.com/index.txt'<cr>", opts)

------ Insert datetime
keymap('n', '<leader>dt', ":put =strftime('%d/%m/%y %H:%M:%S')<cr>", opts)

-------- enable creation of newlines in normal mode
keymap('n', '<c-o>', '<esc>o<esc>', opts)
keymap('n', '<c-O>', '<esc>O<esc>', opts)
-------- hard H and L remaps
keymap('n', 'H', '0w', opts)
keymap('n', 'L', '$', opts)
--keymap('n', 's', 'i<cr><esc>', opts)

------ Visual mode remaps
------ Indentation
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

------ Rhymezone API:
-- TODO: fix
-- keymap('v', '<leader>zz', "!curl -s 'https://api.rhymezone.com/words?max=600&nonorm=1&k=rz_wke&rel_wke=%V' | jq '.[].word' | sed -r 's/\\\"([a-z]+):(.+):(.+)(.*):(.*)\"/\5\t\2\t\3\t\4/g' | sed 's/\\//g'", opts)

------ Quote text in Visual mode
-------- TODO: use https://github.com/tpope/vim-surround

---- Insert mode remaps
------ jk to ESC
keymap('i', 'jk', '<ESC>', opts)
------ and for butterfingers
keymap('i', 'kj', '<ESC>', opts)
------ sane escape from insert mode
keymap('i', '<c-c>', '<ESC>', opts)
-- inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
-- keymap('i', '<expr> <Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', opts)
-- keymap('i', '<expr> <S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', opts)

------ Command Mode
-------- expand current script path     
keymap('c', '%%', "<C-R>=expand('%:h').'/'<cr>", opts)
-------- navigate tab completion with <c-j> and <c-k>
-------- runs conditionally
keymap('c', "<C-j>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } )
keymap('c', "<C-k>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } )
---- " Leader write with permissions ------------- {{{
keymap('c', 'w!!', 'w !sudo tee > /dev/null %', opts)
keymap('c', 'Vs', 'vs', opts)

------ Operator mappings
-------- in next parenthesis
keymap('o', 'in(', ":<c-u>normal! f(vi(<cr>", opts)
-------- in last parenthesis
keymap('o', 'il(', ':<c-u>normal! F)vi(<cr>', opts)
-------- and next parenthesis
keymap('o', 'an(', ':<c-u>normal! f(va(<cr>', opts)
-------- and last parentthesis
keymap('o', 'al(', ':<c-u>normal! F)va(<cr>', opts)
-------- more operator pending mappings (change inside next email address)
keymap('o', 'in@', ':<c-u>execute "normal! ?^.+@$\rvg_"<cr>', opts)
keymap('o', 'an@', ':<c-u>execute "normal! ?^\\S\\+@\\S\\+$\r:nohlsearch\r0vg"<cr>', opts)

------ Command remaps
-------- forgive :Wq (Write and quit)
vim.api.nvim_command("command! Wq :wq")
-------- and Q
vim.api.nvim_command("command! Q :q")

------ Spell
keymap('n', '<leader>ss', ':set spell!<cr>', opts)

-- TODO
-- -------- use cht.sh to search for command help
-- keymap('n', '<leader>cht', ":terminal<CR> cht.sh", opts)
