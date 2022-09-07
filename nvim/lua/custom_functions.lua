-- let wordUnderCursor = expand("<cword>") hello god
-- local execute = vim.api.nvim_command
local vimp = require('vimp')
-- r = reload vimrc
vimp.nnoremap('<leader>rz', function ()
  -- vim.echom(vim.fn.expand("<cword>"))
  local cword = vim.fn.expand("<cword>")
  local jq = "jq -r '.[].word'"
  local cut_sed = "cut -d '|' -f1,2 | sed -re 's/<\\/?b>//g'"
  local cmd = "curl 'https://api.rhymezone.com/words?max=600&nonorm=1&k=rz_wke&rel_wke=" .. cword .. "' | " .. jq .. " | " .. cut_sed
  require('fzf-lua').fzf_exec(
    cmd,
    {
      fzf_opts = {
        ['--preview-window'] = 'nohidden,down,5%',
        ['--preview'] = require('fzf-lua').shell.action(function(items)
          local contents = {}
          vim.tbl_map(function(x)
              table.insert(contents, ">" .. x)
          end, items)
          return contents
        end)
      },
    }
)
end)

vimp.nnoremap('<leader>bh', function ()
  -- vim.echom(vim.fn.expand("<cword>"))
  local cmd = "edit_history $HOME/.bash_eternal_history"
  require('fzf-lua').fzf_exec(
    cmd,
    {
      fzf_opts = {
        ['--preview-window'] = 'nohidden,down,5%',
        ['--preview'] = require('fzf-lua').shell.action(function(items)
          local contents = {}
          vim.tbl_map(function(x)
              table.insert(contents, ">" .. x)
          end, items)
          return contents
        end)
      },
    }
)
end)
