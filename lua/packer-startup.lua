local use = require("packer").use

local function setup_python_library(python_host_prog, library_name, pip_installable_name)
  local install_cmd = python_host_prog .. " -c 'import " .. library_name .. "'"
  if vim.fn.system(install_cmd) == 0 then
    vim.api.nvim_echo({{library_name .. " is already installed.", "Normal"}}, true, {})
  else
    install_cmd = python_host_prog .. " -m pip install " .. pip_installable_name
    vim.fn.system(install_cmd)
  end
end
-- Packer can manage itself as an optional plugin
require("packer").startup(function()
    use "wbthomason/packer.nvim" -- packer.nvim
    use { -- For file / directory viewing
      "kyazdani42/nvim-tree.lua",
      requires = {
        "kyazdani42/nvim-web-devicons", -- optional, for file icons
      }, -- if using WSL2, Windows Terminal needs nerd font so install Consolas NF on the OS terminal
    }  -- tree view
    use { -- lsp configuration for linting, etc.
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "onsails/lspkind-nvim",
    }
    use { -- cmp for completion --> $HOME/.config/nvim/lua/plugins/nvim-cmp-cfg.lua
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "octaltree/cmp-look",
      "klebster2/cmp-rogets-thesaurus",
      "saadparwaiz1/cmp_luasnip",
      "nvim-lua/plenary.nvim",
      "L3MON4D3/LuaSnip", -- snippets for completion see https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip and luasnip ( $HOME/.config/nvim/snippets )
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
    use {
      'mireq/luasnip-snippets',
      dependencies = {'L3MON4D3/LuaSnip'},
      init = function()
        -- Mandatory setup function
        require('luasnip_snippets.common.snip_utils').setup()
      end
    }
    use {
      "christoomey/vim-tmux-navigator",
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

    use {
      'junegunn/fzf', run='vim -u NONE "fzf#install()" -c q',
      requires = {
        'junegunn/fzf.vim',
      }
    }
    use "svermeulen/vimpeccable"
    use "tpope/vim-fugitive" -- github / git
    use "ThePrimeagen/git-worktree.nvim" -- github / git
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
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
    use { "psf/black", branch= "main" } -- python black
    use {
      "fisadev/vim-isort",
      run = function()
        if vim.fn.executable("isort") == 0 then -- check if Isort is not installed
            setup_python_library(vim.api.nvim_eval("g:python3_host_prog"), "isort", "isort")
        end
      end,
    }
    use { "preservim/tagbar" } -- view python objects
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.3',
      requires = { 'nvim-lua/plenary.nvim' }
    }
    use { "anuvyklack/windows.nvim",
      requires = "anuvyklack/middleclass",
      config = function()
          require('windows').setup()
      end
    }
    use {
      "wincent/shellbot",
      run = function()
        require("chatgpt").chatgpt()
      end,
    }
    use { "numToStr/Comment.nvim" }
    use { "sheerun/vim-polyglot" }
    use {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup()
      end,
    }
    use {
      "zbirenbaum/copilot-cmp",
      after = { "copilot.lua" },
      config = function ()
        require("copilot_cmp").setup()
      end
    }
end)

