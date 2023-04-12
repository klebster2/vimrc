vim = vim
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
keymap('n', '<leader>vs', ':NvimTreeOpen .<cr>:vertical resize 40<cr>', opts)

-- PackerSync is what Plug Install  used to be (pi)
keymap('n', '<leader>pi', ':PackerSync<cr>', opts)

-------- leader easy edit packer plugin
keymap('n', '<leader>eV', ':NvimTreeOpen $HOME/.config/nvim/lua/<cr>', opts)
keymap('n', '<leader>ebf', ':vsplit $HOME/.bash_functions<cr>', opts)


-------- Custom GPT remap
keymap('n', '<leader>wg', ':vs $HOME/.local/share/nvim/tmp/gpt<cr>PjdG<esc><c-w><c-h>', opts)

keymap('n', '<leader>ebh', ':vs .<cr>:r!echo "history" | bash -i 2>/dev/null | sed -e "s/\x1b\\[.//g"', opts)
--vim.api.nvim_exec( [[
--function! RipgrepFzf(query, fullscreen)
--  let command_fmt = "perl -pe 'use POSIX qw(strftime); s/^\#\([0-9]+\)/strftime ''\#\%F \%H:\%M:\%S'', localtime(\$1)/e' $HOME/.bash_eternal_history | grep \%s || true"
--  let initial_command = printf(command_fmt, shellescape(a:query))
--  echom initial_command
--  let reload_command = printf(command_fmt, '{q}')
--  let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
--  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
--  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
--endfunction
--command! -nargs=* -bang RGBH call RipgrepFzf(<q-args>, <bang>0)
--  ]], opts)
--keymap('n', '<leader>ebh', ':RGBH', opts)
