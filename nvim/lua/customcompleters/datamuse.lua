local Job = require('plenary.job')
local source = {}
source.new = function ()
  local self = setmetatable({}, { __index = source })
  return self
end

source.complete = function(self, _, callback)
  --local line = vim.fn.getline('.')
  --local start = vim.fn.col('.') - 1
  --while start > 0 and line:sub(start - 1, start - 1):match('%S') do
  --    start = start - 1
  --end
  --local query_word = line:sub(start, vim.fn.col('.') - 2)
  local query_word = "hello"
  local cmd1="curl --silent https://api.datamuse.com/words?rel_jjb="..query_word.."| jq '[.[]+{\"type\": \"jjb\"}]'"
  local cmd2="curl --silent https://api.datamuse.com/words?rel_bgb="..query_word.."| jq '[.[]+{\"type\": \"bgb\"}]'"

  local cmd = "cat <("..cmd1..") <("..cmd2..") | jq -s '[.[][]]'"

  Job :new({
    cmd,
    on_exit = function (job)
      local res = job:result()
      local ok, parsed = pcall(vim.fn.json_decode, table.concat(res, " "))
      if not ok then
        vim.notify "Error parsing json"
        return
      end

      local items = {}
      for  _, datamuse_item in ipairs(parsed) do
        --datamuse_item.
        table.insert(items, {
          label = string.format("%s (%s)", datamuse_item['word'], datamuse_item['score']),
          --documentation = {kind = datamuse_item['score']},
          --kind = 'ﲳ',
          --type = datamuse_item["type"],
          -- documentation = datamuse_item['score'],
        })
      end
      callback { items = items, isIncomplete = false }
    end,
  }):start()
end


--    for _, m in ipairs(data) do
--        if (m["type"] == "jjb") then
--            if (first_entry_jjb == 0) then
--                first_entry_jjb = m["score"]
--            end
--            table.insert(unsorted, {
--                icase = 1,
--                word = "good "..m['word'],
--                menu = (m['score']*100 / first_entry_jjb),
--                kind = 'ﲳ',
--                type = m["type"],
--            })
--        elseif (m["type"] == "bgb") then
--            if (first_entry_bgb == 0) then
--                first_entry_bgb = m["score"]
--            end
--            table.insert(unsorted, {
--                icase = 1,
--                word = "good "..m['word'],
--                menu = (m['score']*100 / first_entry_bgb),
--                kind = 'ﲳ',
--                type = m["type"],
--            })
--        end
--    end
--    return unsorted
source.get_trigger_characters = function()
  return { ' ' }
end

source.is_available = function()
  return true
end

require('cmp').register_source('datamuse', source.new())
