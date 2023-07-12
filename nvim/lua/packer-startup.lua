local use = require("packer").use
require("packer").startup(function()
    -- Packer can manage itself as an optional plugin
    use "wbthomason/packer.nvim" -- packer.nvim

    -- Colorscheme
    use "morhetz/gruvbox"

    use {
      "kyazdani42/nvim-tree.lua",
      requires = {
        "kyazdani42/nvim-web-devicons", -- optional, for file icons
      }, -- if using WSL2, Windows Terminal need nerd font so install Consolas NF on the OS terminal
      tag = "nightly" -- optional, updated every week. (see issue #1193)
    }  -- tree view
    use { -- lsp configuration for linting, etc.
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "onsails/lspkind-nvim",
    }
    use { -- cmp for completion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "nvim-lua/plenary.nvim",
    }

    use { -- luasnip - see $HOME/.vim_runtime/nvim/snippets
      "L3MON4D3/LuaSnip", -- snippets for completion see https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
      "rafamadriz/friendly-snippets",
    }
    use { -- cmp text editor-like plugins
    --  "uga-rosa/cmp-dictionary",
      "f3fora/cmp-spell", -- see $HOME/.vim_runtime/nvim/lua/plugins/nvim-cmp-cfg.lua
    --  "rudism/telescope-dict.nvim",
    --  "rhysd/vim-grammarous",
    --  "preservim/vim-wordy",
    }
    use { 'junegunn/fzf', run='vim -u NONE "fzf#install()" -c q' }
    use "junegunn/fzf.vim"
    -- fzf-wordnet
    use "CTHULHU-Jesus/fzf-wordnet.vim"

    use "svermeulen/vimpeccable"
    use "tpope/vim-fugitive" -- github help
    use "jremmen/vim-ripgrep" -- search

    use {
      "mbbill/undotree",
      run='vim -u NONE -c "helptags undotree/doc" -c q'
    }
    use "wsdjeg/vim-lua"
    use {
      "tpope/vim-surround",
      run='vim -u NONE -c "helptags surround/doc" -c q'
    }
    use { "gelguy/wilder.nvim", config = function() end, }
    -- python
    use { "psf/black", branch= "main" } -- python black

    if vim.fn.executable("isort") == 0 then -- check if Isort is not installed
      local python_host_prog = vim.api.nvim_eval("g:python3_host_prog")
      if python_host_prog then
        local install_cmd = python_host_prog .. " -m pip install isort"
        vim.fn.system(install_cmd)
        -- if vim.fn.executable("isort") == 0 then
        --   vim.api.nvim_echo({{"Failed to automatically install isort. Please install it manually.", "ErrorMsg"}}, true, {})
        -- else
          use "fisadev/vim-isort"
        --end
      else
        vim.api.nvim_echo({{"g:python3_host_prog is not set. Cannot install isort.", "ErrorMsg"}}, true, {})
      end
    else
      use "fisadev/vim-isort"
    end
    use { "preservim/tagbar" } -- view python objects
    use {
      'heavenshell/vim-pydocstring',
      run = "make install",
      ft = { 'python' }
    } -- docstring format
    -- status bar
    -- use "vim-airline/vim-airline"
    -- -- copilot
    -- use {
    --   "zbirenbaum/copilot.lua",
    --   cmd = "Copilot",
    --   event = "InsertEnter",
    --   config = function()
    --     require("copilot").setup({
    --     })
    --   end,
    --   filetypes = {
    --     ["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
    --   },
    -- }
    -- use {
    --   "zbirenbaum/copilot-cmp",
    --   after = { "copilot.lua" },
    -- }
    -- use {
    --   "jackMort/ChatGPT.nvim", -- chat gpt for queries / completion
    --     requires = {
    --       "MunifTanjim/nui.nvim",
    --       "nvim-lua/plenary.nvim",
    --       "nvim-telescope/telescope.nvim"
    --     }
    -- }
    use { "anuvyklack/windows.nvim", -- pretty window rescaling (nice to have)
      requires = {
          "anuvyklack/middleclass",
          "anuvyklack/animation.nvim"
      },
      config = function()
          vim.o.winwidth = 10
          vim.o.winminwidth = 10
          vim.o.equalalways = false
          require("windows").setup()
      end
    }
    use { "numToStr/Comment.nvim" }
    use { "sheerun/vim-polyglot" }
    use { "klebster2/vim-wiktionary" }
end)
