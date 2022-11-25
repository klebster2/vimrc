local vimp = require('vimp')

vimp.nnoremap('<leader>rz', function ()
  local cursorword = vim.fn.expand("<cword>")
  local jq = "jq -r '.[].word'"
  local cut_sed = "cut -d '|' -f1,2 | sed -re 's/<\\/?b>//g'"
  local cmd = "curl 'https://api.rhymezone.com/words?max=600&nonorm=1&k=rz_wke&rel_wke=" .. cursorword .. "' | " .. jq .. " | " .. cut_sed
  local bufnr = vim.api.nvim_exec([[echom bufnr()]], true)
  local contents = {}
  vim.api.nvim_echo({{bufnr, 'None'}}, true, {})
  require('fzf-lua').fzf_exec(
    cmd,
    {
      fzf_opts = {
        ['--preview-window'] = 'nohidden,down,5%',
        ['--preview'] = require('fzf-lua').shell.action(function(items)
          local counter = 0
          --local counter_prev = 0
          vim.tbl_map(function(x)
              table.insert(contents, x)
              local values_in_contents = {}
              for value in pairs(contents) do
                  if value == x then
                    vim.api.nvim_echo({{x, 'None'}}, true, {})
                    vim.api.nvim_buf_set_lines(tonumber(bufnr), 0, 0, false, {x})
                    table.insert(values_in_contents, value)
                  end
              end
              --counter_prev = counter
              counter = counter + 1
          end, items)
          return contents
        end)
      },
    }
    )
end)

-- vimp.nnoremap('<leader>D', function () -- D for etymology
--   local cursorword = vim.fn.expand("<cword>")
--   vim.api.nvim_echo({{x, 'None'}}, true, {})
--   local cmd = "curl 'https://api.rhymezone.com/words?max=600&nonorm=1&k=rz_wke&rel_wke=" .. cursorword .. "' | " .. jq .. " | " .. cut_sed
--   local contents = {}
--   vim.api.nvim_echo({{bufnr, 'None'}}, true, {})
--   require('fzf-lua').fzf_exec(
--     cmd,
--     {
--       fzf_opts = {
--         ['--preview-window'] = 'nohidden,down,5%',
--         ['--preview'] = require('fzf-lua').shell.action(function(items)
--           local counter = 0
--           --local counter_prev = 0
--           vim.tbl_map(function(x)
--               table.insert(contents, x)
--               local values_in_contents = {}
--               for value in pairs(contents) do
--                   if value == x then
--                     vim.api.nvim_echo({{x, 'None'}}, true, {})
--                     vim.api.nvim_buf_set_lines(tonumber(bufnr), 0, 0, false, {x})
--                     table.insert(values_in_contents, value)
--                   end
--               end
--               --counter_prev = counter
--               counter = counter + 1
--           end, items)
--           return contents
--         end)
--       },
--     }
--     )
-- end)

vimp.nnoremap('<leader>bh', function ()
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
-- hello
