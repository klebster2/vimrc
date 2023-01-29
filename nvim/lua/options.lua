-- global
vim.go.errorbells = false
vim.go.smartcase = true
vim.go.swapfile = false
vim.go.backup = false
vim.go.shiftround = true
vim.go.foldlevelstart = 1

-- buffer
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.wildmenu = true
vim.opt.wildmode = {'list', 'longest'}
vim.opt.mouse = nil
vim.opt.runtimepath = vim.opt.runtimepath + '~/.config/nvim/snippets'

-- local to window
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false

-- other
vim.g.syntax_on = true

-- options
-- complete option
vim.o.completeopt = "menu,menuone,noselect"

-- color options
vim.o.termguicolors = true
vim.o.background = "dark"

-- spelling
vim.opt.spell = false
vim.opt.spelllang = { 'en_gb' }

-- guard for distributions lacking the 'persistent_undo' feature.
vim.cmd([[
if has('persistent_undo')
    " define a path to store persistent undo files.
    let target_path = expand('~/.config/vim-persisted-undo/')
    " create dir and any parent dirs if loc doesn't exist
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif
    " point Vim to the defined undo directory.
    let &undodir = target_path
    " finally, enable undo persistence.
    set undofile
endif
]])
