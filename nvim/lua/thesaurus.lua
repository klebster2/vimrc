--- First, find the current file root, thesaurus is three directories back, then inside dicts/theasaurus as thesaurus.txt
vim.api.nvim_exec([[ 
  set thesaurus+=$HOME/.vim_runtime/dicts/thesaurus/thesaurus.txt
]], true)
-- By manually using <ctrl+t> in normal mode, you can look up the word under the cursor in the thesaurus
