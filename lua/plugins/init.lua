return {
  {
    "christoomey/vim-tmux-navigator",
    lazy=true,
  },
  { "wsdjeg/vim-lua" },
  { "gelguy/wilder.nvim" },
  { "preservim/tagbar" }, -- view python objects
  { "anuvyklack/windows.nvim"},  -- window resizer
  { "numToStr/Comment.nvim" },
  { "sheerun/vim-polyglot" },
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
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
  --#{ dir="~/.config/nvim/fasttext" }
}
