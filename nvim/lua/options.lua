-- global
vim.go.errorbells = false
vim.go.smartcase = true
vim.go.swapfile = false
vim.go.backup = false
vim.go.shiftround = true

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

-- option
vim.o.completeopt = "menuone,noselect,noinsert"

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
  "autocmd BufEnter * call ncm2#enable_for_buffer()
  inoremap <c-c> <ESC>
  inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
]])
