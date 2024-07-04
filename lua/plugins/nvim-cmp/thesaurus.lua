local cmp = require("cmp");
if not cmp then return end

local thesaurus = {}

local source = {}
source.new = function()
  return setmetatable({}, { __index = source })
end
source.get_trigger_characters = function()
  return { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
           'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
           'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
           'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
           'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' }
end

source.is_available = function()
  return vim.api.nvim_get_mode().mode == 'i'
end

local thesaurus_path = vim.fn.expand(os.getenv('HOME') .. "/.config/nvim/dicts/thesaurus/thesaurus-no-underscore-no-numbers-no-names-no-space.txt")


for line in io.lines(thesaurus_path) do
  local parts = vim.fn.split(line, ',')
  -- put remainder (comma sep list of synonyms) into the thesaurus table
  table.insert(thesaurus, parts)
end

source.complete = function(self, request, callback)
  if not vim.fn.filereadable(thesaurus_path) then return end
  -- find previous whitespace / word
  local line = vim.fn.getline('.')
  local original_start = vim.fn.col('.') - 1
  local start = original_start
  while start > 0 and string.match(line:sub(start, start), '%S') do
      start = start - 1
  end
  local query_word = line:sub(start + 1, vim.fn.col('.') - 2)
  local input = query_word
  if #input < 3 then return end  --- Short input requires a lot of processing, so let's skip it.

  --vim.api.nvim_echo({{input, 'Normal'}}, true, {})

  if not input then return end
  -- get neovim type of request.context.cursor.row
  -- log the thesaurus file
  local items = {}
  local seen_items = {}

  for _, parts in ipairs(thesaurus) do
    for _, p in ipairs(parts) do
      -- Check if the line starts with the input AND the current alphabetical char at index 1
      -- Also check whether a space is somewhere in the 'h' or 'val' - if it is, then skip it.
      -- DUPEFILTER: ( check if the current part is not the same as the input )

      if not(p == input) and vim.startswith(p, input) then
        for _, _p in ipairs(parts) do
          if not(_p == p) and not(seen_items[_p] ~= nil) then
            seen_items[_p] = true
            table.insert(items, {
              label = _p .. ' [' .. p .. ']',
              textEdit = {
                newText = _p,
                filterText = _p,
                new_text = _p,
                range = {
                  ['start'] = {
                      line = request.context.cursor.row - 1,
                      character = original_start,
                  },
                  ['end'] = {
                      line = request.context.cursor.row - 1,
                      character = request.context.cursor.col - 1,
                  }
                },
              },
              kind = '[' .. p .. '] '..cmp.lsp.CompletionItemKind.Thesaurus,
            })
          end
          -- vim.api.nvim_echo({{_p, 'Normal'}}, true, {})
          -- vim.api.nvim_echo({{tostring('row:'..request.context.cursor.row), 'Normal'}}, true, {})
          -- vim.api.nvim_echo({{tostring('input:'..#input), 'Normal'}}, true, {})
          -- vim.api.nvim_echo({{tostring('startcol:'..(request.context.cursor.col - #input)), 'Normal'}}, true, {})
          -- vim.api.nvim_echo({{tostring('char:'..request.context.cursor.col), 'Normal'}}, true, {})
          callback({ items = items, isIncomplete = true })
        end
      end
    end
  end
  callback({items = items, isIncomplete = true})
end

cmp.register_source('thesaurus', source.new())
