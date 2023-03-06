-- Learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it." [in other words, remap, and unmap]
-- You can return to the previous file by using <c+o> (or <c+i>)

-- basic options
require("options")
require("keymappings")

-- packer and plugin installation and packages
require("packer-install")
require("packer-startup")

-- plugin configurations
require("plugins/nvim-tree-cfg")
require("plugins/keymappings")
require("plugins/options")

-- default cmp AND lsp (language server protocol) configuration (for python)
require("luasnip-config")
require("luasnippets")
require("plugins/nvim-cmp-cfg")

-- autocmds (per file type)
require("autocmds")

-- Chat gpt for queries / completion
require("chat-gpt")

-- miniconda for the nvim python loc
require("miniconda-python-loc")

vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/basic.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/datamuse.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/fasttext.vim ]], true)

-- TODO: wordnet
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet.vim ]], true)
-- wordnet-synonyms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-synonyms.vim ]], true)
-- wordnet-anagrams
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-anagrams.vim ]], true)
-- wordnet-antonyms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-antonyms.vim ]], true)
-- wordnet-definitions
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-definitions.vim ]], true)
-- wordnet-hyponyms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-hyponyms.vim ]], true)
-- wordnet-hypernyms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-hypernyms.vim ]], true)
-- wordnet-meronyms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-meronyms.vim ]], true)
-- wordnet-entailments
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-entailments.vim ]], true)
-- wordnet-attributes
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-attributes.vim ]], true)
-- wordnet-derivations
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-derivations.vim ]], true)
-- wordnet-pertainyms

-- TODO: wordnet-verbs
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-pertainyms.vim ]], true)
-- wordnet-verbgroups
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbgroups.vim ]], true)
-- wordnet-verbframes
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbframes.vim ]], true)
-- wordnet-verbexamples
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbexamples.vim ]], true)
-- wordnet-verbcollocations
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbcollocations.vim ]], true)
-- wordnet-verbregions
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbregions.vim ]], true)
-- wordnet-verbusage
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbusage.vim ]], true)
-- wordnet-verbderivations
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbderivations.vim ]], true)
-- wordnet-verbentailments
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbentailments.vim ]], true)
-- wordnet-verbattributes
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbattributes.vim ]], true)
-- wordnet-verbcauses
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbcauses.vim ]], true)
-- wordnet-verbalsosees
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbalsosees.vim ]], true)
-- wordnet-verbantonyms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbantonyms.vim ]], true)
-- wordnet-verbderivationallyrelatedforms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbderivationallyrelatedforms.vim ]], true)
-- wordnet-verbparticipleof
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbparticipleof.vim ]], true)
-- wordnet-verbpertainyms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbpertainyms.vim ]], true)
-- wordnet-verbmeronyms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbmeronyms.vim ]], true)
-- wordnet-verbholonyms
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbholonyms.vim ]], true)
-- wordnet-verbentailments
-- vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/wordnet-verbentailments.vim ]], true)
--
