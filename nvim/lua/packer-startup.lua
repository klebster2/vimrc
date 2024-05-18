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

    use {
      'junegunn/fzf', run='vim -u NONE "fzf#install()" -c q',
      requires = {
        'junegunn/fzf.vim',
      }
    }

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
    use {
      'rafi/telescope-thesaurus.nvim',
      requires={
        'nvim-telescope/telescope.nvim',
      },
      opts = {
        extensions = {
          thesaurus = {
            provider = 'datamuse',
          },
        },
      }
    }

    -- LLM (Language Models) for autocompletion
    use { "David-Kunz/gen.nvim",   -- Uses Ollama under the hood
      config = function()
        require("gen").setup({
          model = "gemma:2b", -- The default model to use.
            port = "11434", -- The port on which the Ollama service is listening.
            quit_map = "q", -- set keymap for close the response window
            retry_map = "<c-r>", -- set keymap to re-send the current prompt
            init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
            -- Function to initialize Ollama
            command = function(options)
                local body = {model = options.model, stream = true}
                return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
            end,
            -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
          -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
          -- This can also be a command string.
          -- The executed command must return a JSON object with { response, context }
          -- (context property is optional).
          -- list_models = '<omitted lua function>', -- Retrieves a list of model names
          show_prompt = true, -- Shows the prompt submitted to Ollama.
          show_model = true, -- Displays which model you are using at the beginning of your chat session.
      })
      end
    }
    use { -- copilot (paid)
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
end)
