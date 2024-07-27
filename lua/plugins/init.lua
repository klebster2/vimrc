return {
  {
    "christoomey/vim-tmux-navigator",
    lazy=true,
  },
  { 'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    require('lualine').setup {
      options = {
        icons_enabled = true,
        fmt = string.lower,
        theme  = require('lualine.themes.gruvbox_dark'),
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { "mode"},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    }
  },
  { "wsdjeg/vim-lua" },
  { "gelguy/wilder.nvim" },
  { "preservim/tagbar" }, -- view python objects
  { "anuvyklack/windows.nvim"},  -- window resizer
  { "numToStr/Comment.nvim" },
  { "sheerun/vim-polyglot" },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup()
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  },
}
