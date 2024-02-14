local use = require("packer").use
require("packer").startup(function()
    -- Packer can manage itself as an optional plugin
    use "wbthomason/packer.nvim" -- packer.nvim
    use "morhetz/gruvbox" -- Preferred colorscheme
    use { -- For file / directory viewing
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
      "octaltree/cmp-look",
      "f3fora/cmp-spell", -- see $HOME/.vim_runtime/nvim/lua/plugins/nvim-cmp-cfg.lua
      "saadparwaiz1/cmp_luasnip",
      "nvim-lua/plenary.nvim",
      "L3MON4D3/LuaSnip", -- snippets for completion see https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip and luasnip ( $HOME/.vim_runtime/nvim/snippets )
      "rafamadriz/friendly-snippets",
    }
    use {
      "KadoBOT/cmp-plugins",
      config = function()
        require("cmp-plugins").setup({
          files = { ".*\\.lua" }  -- default
        })
      end,
    }
    use { 'nvim-lualine/lualine.nvim',
      config = function ()
          local custom_gruvbox = require'lualine.themes.gruvbox_dark'
        require('lualine').setup {
        options = {
          fmt = string.lower,
          theme  = custom_gruvbox
        },
        sections = {
          lualine_a = {
          {
            'mode', fmt = function(str)
            return str:sub(1,1)
            end
          }
        },
        lualine_b = {'branch'} }
    }
      end
    }

    use { 'junegunn/fzf', run='vim -u NONE "fzf#install()" -c q' }

    use "svermeulen/vimpeccable"
    use "tpope/vim-fugitive" -- github / git
    use "ThePrimeagen/git-worktree.nvim" -- github / git
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
          use "fisadev/vim-isort"
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
    use "vim-airline/vim-airline"
    use { -- copilot
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
        })
      end,
      filetypes = {
        ["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
      },
    }
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.3',
      requires = { 'nvim-lua/plenary.nvim' }
    }
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

    use {
      'huggingface/llm.nvim',
      config = function()
        require('llm').setup({
          model = "codellama/CodeLlama-34B-hf", --- also see "bigcode/starcoderplus", "bigcode/starcoder"
          query_params = {
            max_new_tokens = 100,
            temperature = 0.2,             --- lower temperature to get more 'appropriate' output
            top_p = 0.8,                 --- lower top_p to get more suggestions
            stop_tokens = nil,
          },
          fim = {
          enabled = true,
          prefix = "<PRE> ",     ---  "<fim_prefix>" for "codellama/CodeLlama-13b-hf", (the space matters)
          middle = " <MID>",     ---  "<fim_middle>" for "codellama/CodeLlama-13b-hf", (the space matters)
          suffix = " <SUF>",     ---  "<fim_suffix>" for "codellama/CodeLlama-13b-hf", (the space matters)
          },
          context_window = 4096,        --- max number of tokens for the context window (max for "codellama/CodeLlama-13b-hf": 4096, max for "bigcode/starcoder: 8192)
          tokenizer = {
            repository = "codellama/CodeLlama-34B-hf",
          },
          lsp = {
            bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
          },
          enable_suggestions_on_startup = false, -- do not enable by default
      })
      end
    }

    local python_host_prog = vim.api.nvim_eval("g:python3_host_prog")
    if python_host_prog then
      local install_cmd = python_host_prog .. " -m pip install wiktionaryparser PyYAML"
      vim.fn.system(install_cmd)
      use {
        "klebster2/vim-wiktionary",
        config = function()
          vim.g.wiktionary_language = 'english'
        end
      }
    else
      vim.api.nvim_echo({{"g:python3_host_prog is not set. Cannot install wiktionaryparser.", "ErrorMsg"}}, true, {})
    end
end)
