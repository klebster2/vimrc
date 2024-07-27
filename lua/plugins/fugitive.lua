return {
  "tpope/vim-fugitive",
  lazy = true,
  config = function()
    local keymap = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    --- Plugin: vim-fugitive --
    keymap('n', '<leader>gh', ':diffget //3<cr>', opts)
    keymap('n', '<leader>gu', ':diffget //2<cr>', opts)
    keymap('n', '<leader>gs', ':G<cr>', opts)
    keymap('n', '<leader>Gd', ':echom "Enter a number from 0 to reference the nth last commit (0 will be the last commit)"<cr>:sleep 2<cr>:Gdiffsplit<cr>', opts)
    keymap('n', '<leader>gd', ':Gdiff !~', opts)
    keymap('n', '<leader>gc', ':Git commit<cr>', opts)
    keymap('n', '<leader>ga', ':Git add %<cr>', opts)
  end
} -- github / git
