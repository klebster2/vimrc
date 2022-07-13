-- packer options                 -- ./nvim/lua/options.lua
require("options")

-- packer startup                 -- ./nvim/lua/keymappings.lua
require("keymappings")

-- packer install                 -- ./nvim/lua/packer-install.lua
require("packer-install")
-- packer plugins install         -- ./nvim/lua/packer-startup.lua
require("packer-startup")

-- plugin configurations          -- ./nvim/lua/plugins/ 
require("plugins.fzf-cfg")        -- ./nvim/lua/plugins/fzf-cfg.lua
require("plugins.nvim-compe-cfg") -- ./nvim/lua/plugins/nvim-compe-cfg.lua
require("plugins.nvim-tree-cfg")  -- ./nvim/lua/plugins/nvim-tree-cfg.lua
require("plugins.keymappings")    -- ./nvim/lua/plugins/keymappings.lua    -- keymappings for all plugins

require("autocmds")               -- ./nvim/lua/autocmds.lua

require("lsp")                    -- ./nvim/lua/lsp
require("lsp.lua-ls")             -- ./nvim/lua/lsp/lua-ls.lua
require("lsp.keymappings")        -- ./nvim/lua/lsp/keymappings.lua

vim.api.nvim_exec(
[[
"augroup packer_user_config
"  autocmd!
"  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
"augroup end

"source $HOME/.vim_runtime/vimrcs/basic.vim
]],

true)
