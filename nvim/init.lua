---- learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it." [in other words, remap, and unmap]
---- You can return to the previous file by using <c+o> (or <c+i>)
--- see :help 'runtimepath' or :help 'rtp'
--- Basic options
require("options")                   --> $HOME/.vim_runtime/nvim/lua/options.lua

--- Basic keymappings
require("keymappings")               --> $HOME/.vim_runtime/nvim/lua/keymappings.lua

--- Default CMP + LSP 'Mason' (language server protocol) configuration (for python)
require("packer-install")            --> $HOME/.vim_runtime/nvim/lua/packer-install.lua
require("packer-startup")            --> $HOME/.vim_runtime/nvim/lua/packer-startup.lua

require("thesaurus")                 --> $HOME/.vim_runtime/nvim/lua/thesaurus.lua

--- Plugin configurations   # TODO: move to plugins-vendor
require("plugins/nvim-tree-cfg")     --> $HOME/.vim_runtime/nvim/after/lua/plugins/nvim-tree-cfg.lua    # TODO: move to /after
require("plugins/keymappings")       --> $HOME/.vim_runtime/nvim/after/lua/plugins/keymappings.lua      # TODO: move to /after
require("plugins/options")           --> $HOME/.vim_runtime/nvim/after/lua/options.lua                  # TODO: move to /after
require("plugins/snippets")              --> $HOME/.vim_runtime/nvim/after/lua/snippets/init.lua        # TODO: move to /after

--- Default CMP + LSP 'Mason' (language server protocol) configuration (for python)
require("luasnip-config")            --> $HOME/.vim_runtime/nvim/lua/luasnip-config.lua                 # TODO: move to /after

require("plugins/nvim-cmp-cfg")      --> $HOME/.vim_runtime/nvim/after/lua/plugins/nvim-cmp-cfg.lua     # TODO: move to /after
require("plugins/nvim-telescope")    --> $HOME/.vim_runtime/nvim/after/lua/plugins/nvim-telescope.lua   # TODO: move to /after
require("plugins/indent-blank-line") --> $HOME/.vim_runtime/nvim/after/lua/plugins/indent-blank-line.lua  # TODO: move to /after

--- TODO: split into autocmds-vendor and autocmds
--- Autocmds (per file type)
require("autocmds")                  --> $HOME/.vim_runtime/nvim/lua/autocmds.lua

--- (Legacy) vimscript files         --> $HOME/.vim_runtime/vimrcs/
--- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/fasttext.vim ]], true)
--- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/maskprediction.vim ]], true)
--- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/code-generation.vim ]], true)
