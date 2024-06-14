----- Default options for Neovim (without any plugins / plugin options)
--- global
--- luacheck: globals vim
vim.go.errorbells = false
vim.go.smartcase = true
vim.go.swapfile = false
vim.go.backup = false
vim.go.shiftround = true
vim.go.foldlevelstart = 1
--- backspace opt
vim.go.backspace= "indent,eol,start"

--- buffer
---- indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.wildmenu = true
vim.opt.wildmode = {'list', 'longest'}
vim.opt.mouse = nil
vim.opt.spell = false
vim.opt.spelllang = { 'en_gb' }  -- The default spell lang

--- local to window
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false

--- other
vim.g.syntax_on = true

vim.opt.tabline = "-"
--- options
--- complete option
vim.o.completeopt = "menu,menuone,noselect"

--- color options
vim.o.termguicolors = true
vim.o.background = "dark"

vim.opt.mouse = ""
