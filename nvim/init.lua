-- Learn Vimscript the Hard Way:
--> "A trick to learning something is to <--
-->  force yourself to use it."          <--
--
--> [in other words, remap, and unmap]   <--

-- basic options                  -- $HOME/.config/nvim/lua/
require("options")                -- $HOME/.config/nvim/lua/options.lua
require("keymappings")            -- $HOME/.config/nvim/lua/keymappings.lua

-- packer and plugin installation
require("packer-install")         -- $HOME/.config/nvim/lua/packer-install.lua

---- packer packages
require("packer-startup")         -- $HOME/.config/nvim/lua/packer-startup.lua

-- plugin configurations          -- $HOME/.config/nvim/lua/plugins/ 
require("plugins.nvim-tree-cfg")  -- $HOME/.config/nvim/lua/plugins/nvim-tree-cfg.lua
require("plugins.keymappings")    -- $HOME/.config/nvim/lua/plugins/keymappings.lua    -- keymappings for all plugins
require("plugins.options")        -- $HOME/.config/nvim/lua/plugins/options.lua        -- plugin options

-- autocmds (per file type)
require("autocmds")               -- $HOME/.config/nvim/lua/autocmds.lua

-- lsp (language server protocol)
require("lsp")                    -- $HOME/.config/nvim/lua/lsp
require("lsp.lua-ls")             -- $HOME/.config/nvim/lua/lsp/lua-ls.lua
require("lsp.keymappings")        -- $HOME/.config/nvim/lua/lsp/keymappings.lua

-- TODO: fix lsp configuration(s) belows..
require("plugins.nvim-cmp-cfg")   -- $HOME/.config/nvim/lua/plugins/nvim-cmp-cfg.lua  -- default cmp configuration

require("custom_functions")       -- $HOME/.config/nvim/lua/custom_functions.lua
require("luasnip-config")         -- $HOME/.config/nvim/lua/luasnip-config.lua

-- Also see ->                    -- $HOME/.config/nvim/snippets/

--require("luasnip/loaders/from_vscode").lazy_load({paths='~/.vim_runtime/nvim/snippets'})
--require("luasnip.loaders.from_vscode").lazy_load({paths={"/home/"..USER.."/.config/nvim/snippets/"}})

vim.api.nvim_exec([[
   source $HOME/.vim_runtime/vimrcs/basic.vim
   source $HOME/.vim_runtime/vimrcs/customcompleters/fasttext.vim
   set completeopt=menu,menuone,noselect
]], true)
