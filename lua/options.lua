----- Default options for Neovim (without any plugins / plugin options)
--- global
--- luacheck: globals vim
vim.go.errorbells = false
vim.go.smartcase = true
vim.go.swapfile = false
vim.go.backup = false
--vim.go.foldlevelstart = 1
--- backspace opt
vim.go.backspace= "indent,eol,start"

--- buffer
---- indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wildmenu = true
vim.opt.wildmode = {'list', 'longest'}
vim.opt.mouse = nil
vim.opt.spell = false
vim.opt.spelllang = { 'en_gb' }  -- The default spell lang
vim.opt.shell='bash --login'

vim.cmd([[ filetype plugin indent on ]])
vim.cmd([[let tabwidth=4]])

--- local to window
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false

--- other
vim.g.syntax_on = true

--- color options
vim.o.termguicolors = true
vim.o.background = "dark"
vim.opt.mouse = "a"
