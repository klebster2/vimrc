--local cmp = require("cmp");
--if not cmp then return end
--
--local thesaurus = {}
--
--local source = {}
--source.new = function()
--  return setmetatable({}, { __index = source })
--end
--source.get_trigger_characters = function()
--  return { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
--           'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
--           'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
--           'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
--           'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' }
--end
--
--
--source.is_available = function()
--  return vim.api.nvim_get_mode().mode == 'i'
--end
--
--local thesaurus_path = vim.fn.expand(os.getenv('HOME') .. "/.config/nvim/dicts/thesaurus/thesaurus-no-underscore-no-numbers-no-names-no-space.txt")
--
--
--for line in io.lines(thesaurus_path) do
--  local parts = vim.fn.split(line, ',')
--  -- put remainder (comma sep list of synonyms) into the thesaurus table
--  table.insert(thesaurus, parts)
--end
--
--source.complete = function(self, request, callback)
--  if not vim.fn.filereadable(thesaurus_path) then return end
--  -- find previous whitespace / word
--  local line = vim.fn.getline('.')
--  local original_start = vim.fn.col('.') - 1
--  local start = original_start
--  while start > 0 and string.match(line:sub(start, start), '%S') do
--      start = start - 1
--  end
--  local query_word = line:sub(start + 1, vim.fn.col('.') - 2)
--  local input = query_word
--  if #input < 3 then return end  --- Short input requires a lot of processing, so let's skip it.
--
--  --vim.api.nvim_echo({{input, 'Normal'}}, true, {})
--
--  if not input then return end
--  -- get neovim type of request.context.cursor.row
--  -- log the thesaurus file
--  local items = {}
--  local seen_items = {}
--
--  for _, parts in ipairs(thesaurus) do
--    for _, p in ipairs(parts) do
--      -- Check if the line starts with the input AND the current alphabetical char at index 1
--      -- Also check whether a space is somewhere in the 'h' or 'val' - if it is, then skip it.
--      -- DUPEFILTER: ( check if the current part is not the same as the input )
--
--      if not(p == input) and vim.startswith(p, input) then
--        for _, _p in ipairs(parts) do
--          if not(_p == p) and not(seen_items[_p] ~= nil) then
--            seen_items[_p] = true
--            table.insert(items, {
--              label = _p .. ' [' .. p .. ']',
--              textEdit = {
--                newText = _p,
--                filterText = _p,
--                new_text = _p,
--                range = {
--                  ['start'] = {
--                      line = request.context.cursor.row - 1,
--                      character = original_start,
--                  },
--                  ['end'] = {
--                      line = request.context.cursor.row - 1,
--                      character = request.context.cursor.col - 1,
--                  }
--                },
--              },
--              kind = '[' .. p .. '] '..cmp.lsp.CompletionItemKind.Thesaurus,
--            })
--          end
--          -- vim.api.nvim_echo({{_p, 'Normal'}}, true, {})
--          -- vim.api.nvim_echo({{tostring('row:'..request.context.cursor.row), 'Normal'}}, true, {})
--          -- vim.api.nvim_echo({{tostring('input:'..#input), 'Normal'}}, true, {})
--          -- vim.api.nvim_echo({{tostring('startcol:'..(request.context.cursor.col - #input)), 'Normal'}}, true, {})
--          -- vim.api.nvim_echo({{tostring('char:'..request.context.cursor.col), 'Normal'}}, true, {})
--          callback({ items = items, isIncomplete = true })
--        end
--      end
--    end
--  end
--  callback({items = items, isIncomplete = true})
--end
--
--cmp.register_source('thesaurus', source.new())

---- # Wikipedia Except:
---- Roget's Thesaurus is a widely used English-language thesaurus, created in 1805 by Peter Mark Roget (1779–1869), British physician, natural theologian and lexicographer.
---- ## History
---- It was released to the public on 29 April 1852.[1][page needed] Roget was inspired by the Utilitarian teachings of Jeremy Bentham and wished to help "those who are painfully groping their way and struggling with the difficulties of composition ... this work processes to hold out a helping hand".[2] The Karpeles Library Museum houses the original manuscript in its collection.[3]

local cmp = require("cmp")
if not cmp then return end

local rogets_thesaurus = {}

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

local rogets_thesaurus_path = vim.fn.expand(os.getenv('HOME') .. "/.config/nvim/rogets_thesaurus.tsv")

-- Create key-value parts for the thesaurus based on number
local key_value_parts = {}

for line in io.lines(rogets_thesaurus_path) do
    local parts = vim.split(line, '\t', true) -- True to trim results

    if #parts >= 3 and parts[2] then
      local number = parts[1]
      local key = parts[2]
      local synonyms = vim.split(parts[3], ',', true) -- True to trim results
      if key and synonyms then
        -- turn key to lowercase
        --
        table.insert(synonyms, 1, number) -- Insert number at the beginning
        table.insert(synonyms, 2, key:lower()) -- Insert key as second element
        table.insert(rogets_thesaurus, synonyms)
      end
      for syn in ipairs(synonyms) do
        synonyms[syn] = synonyms[syn]:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
      end
      -- update the key_value_parts table (append the synonyms)
      local _synonyms_table = {}
      for k=2, #synonyms do
        table.insert(_synonyms_table, synonyms[k])
      end
      if key_value_parts[number] then
        table.insert(key_value_parts[number], _synonyms_table)
      else
        key_value_parts[number] = {_synonyms_table}
      end

    end
end

function table.table_copy(t)
   local t2 = {}
   for k,v in pairs(t) do
      t2[k] = v
   end
   return t2
end

function string.clean_synonym(syn)
  local cleaned= (
          syn
          :gsub('.%s%[.*%]', '')
          :gsub(' Adj. ', ' - ')
          :gsub(' Noun ', ' - ')
          :gsub(' V. ', ' - ')
          :gsub(' Adv. ', ' - ')
          :gsub('%s?&c..?','')
          --:gsub('.%s.*%a+$','')
        )
  return cleaned
end

function table.reverse(tab)
    for i = 1, math.floor(#tab/2), 1 do
        tab[i], tab[#tab-i+1] = tab[#tab-i+1], tab[i]
    end
    return tab
end

source.complete = function(self, request, callback)
  if not vim.fn.filereadable(rogets_thesaurus_path) then return end
  local line = vim.fn.getline('.')
  local original_start = vim.fn.col('.') - 1
  local start = original_start
  while start > 0 and string.match(line:sub(start, start), '%S') do
      start = start - 1
  end
  local query_word = line:sub(start + 1, vim.fn.col('.') - 1)
  if #query_word < 3 then return end  --- Short input requires a lot of processing, so let's skip it.

  local items = {}
  local seen_items = {}

  for _, parts in ipairs(rogets_thesaurus) do
    local concept_number = parts[1]
    local concept = parts[2]
    for i = 2, #parts do
      local cleaned_synonym = string.clean_synonym(parts[i])
      -- remove common determiners e.g. 'a' 'the' 'an'
      if string.match(cleaned_synonym, '^'..query_word) and not seen_items[concept_number] then
        local synonyms_kv = {}
        local initial_doc = '**' .. concept .. '**' .. ' ' .. concept_number .. ' - (' .. parts[i] .. ')'

        --- Check previous results for the same synonym (we will concatenate the docs)
        for remove_idx, item in ipairs(items) do
          if seen_items[concept_number] == nil then
              synonyms_kv = table.table_copy(item.synonyms_kv)
              initial_doc = item.initial_doc .. '\n' .. initial_doc
              table.remove(items, remove_idx)
              break
          end
        end

        -- In lua we can split long strings into multiple lines by using the concatenation operator (..)
        for k=1, #key_value_parts[concept_number] do
          local _all_other_synset = {}
          local use_as_primary_row = false
          local synset = key_value_parts[concept_number][k]
          local _synset = {}
          for j, syn in ipairs(synset) do
            -- remove common
            if j>1 then
              table.insert(_synset, syn)
            end

            --- If one row contains the query_word, then use it as the primary row
            if string.match(syn, query_word) then
              use_as_primary_row = true
            end

          end
          if use_as_primary_row then
            local _initial_doc = table.concat(_synset, ', ') .. ' ' .. concept_number
            table.insert(synonyms_kv, 1, _initial_doc)
          end
        end

        synonyms_kv = table.reverse(synonyms_kv)
        local synonyms = '\n'..table.concat(synonyms_kv,'\n')

        local header = '# Roget\'s Thesaurus:\n----------------\n\n'
        table.insert(items, {
          label = cleaned_synonym,
          documentation = '```markdown\n' .. header .. initial_doc.. '\n\n   ' .. parts[i] ..'\n\n## **See also**: ' .. synonyms .. '\n```',
          synonyms_kv = synonyms_kv, -- these values don't correspond to lsp completion item fields, so we'll store them here
          initial_doc = initial_doc, -- these values don't correspond to lsp completion item fields, so we'll store them here
          textEdit = {
            newText = cleaned_synonym,
            filterText = cleaned_synonym,
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
          kind = 26,
        })
        -- vim.api.nvim_echo({{concept_number, 'Normal'}}, true, {})
        -- vim.api.nvim_echo({{tostring('row:'..request.context.cursor.row), 'Normal'}}, true, {})
        -- vim.api.nvim_echo({{tostring('input:'..#input), 'Normal'}}, true, {})
        -- vim.api.nvim_echo({{tostring('startcol:'..(request.context.cursor.col - #input)), 'Normal'}}, true, {})
        -- vim.api.nvim_echo({{tostring('char:'..request.context.cursor.col), 'Normal'}}, true, {})
        --callback({ items = items, isIncomplete = true })
        --end
        seen_items[concept_number] = true
      end
    end
  end
  -- Pad string for readability
  --for _, item in ipairs(items) do
  --  item.label = string.rep('-', length_longest_label - #item.label - #item.textEdit.newText) .. item.label
  --end
  callback({items = items, isIncomplete = false})
end

cmp.register_source('thesaurus', source.new())
