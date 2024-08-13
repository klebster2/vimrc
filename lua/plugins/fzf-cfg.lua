return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require('fzf-lua').setup{
      winopts = {
        hl = {
          border = "FloatBorder",
          normal = "IncSearch",
        }
      }
    }
    vim.keymap.set("n", "<c-F>", require('fzf-lua').files, { desc = "Fzf Files"} )
    vim.keymap.set("n", "<c-T>", require('fzf-lua').helptags, { desc = "Fzf helptags" })
    vim.keymap.set("n", "<c-X>", require('fzf-lua').grep_cword, { desc = "Fzf Live Grep on CWORD" })
  end
}
