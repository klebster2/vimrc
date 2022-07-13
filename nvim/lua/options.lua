-- global
vim.go.errorbells = false
vim.go.smartcase = true
vim.go.swapfile = false
vim.go.backup = false
vim.go.shiftround = true
vim.go.foldlevelstart = 1

-- buffer
vim.bo.autoindent = true
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.tabstop = 4

-- local to window
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.wrap = false

-- other
vim.g.syntax_on = true

-- options
-- complete option
vim.o.completeopt = "menuone,noselect"

-- color options
vim.o.termguicolors = true
vim.o.background = "dark"

-- undodir
vim.opt.undodir = '$HOME/.config/nvim/.undo/'

--vim.opt_global.buffer.is_bash = 1
vim.opt_local.errorbells = false
