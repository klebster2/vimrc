local vim = vim

-- Setup nvim-cmp.
local cmp = require("cmp");
if not cmp then return end

-- => cmp for datamuse (This is also an example of how to implement api calling with cmp)
-- local source = {}
-- source.new = function()
--   return setmetatable({}, { __index = source })
-- end
-- 
-- source.get_trigger_characters = function()
--   return { ' ' }
-- end
-- 
-- -- datamuse specific
-- local function sort_by_score(entry1, entry2)
--   local score1 = entry1.completion_item.score or 0
--   local score2 = entry2.completion_item.score or 0
--   return score1 > score2
-- end
-- 
-- source.complete = function(self, request, callback)
--   local line = vim.api.nvim_get_current_line()
--   local start = vim.fn.col('.') - 1
--   -- fix this to trigger only on certain context
--   -- context 1:
--   -- change the previous word (use the next word somehow as)
--   repeat
--     start = start - 1
--   until start <= 0 or line:sub(start, start) == ' '
--   local query_word = line:sub(start + 1, vim.fn.col('.') - 1)
--   --if vim.fn.strlen(query_word) <= 2 then
--   --  return ""
--   --end
--   local side = 'a'
--   -- Side 'a' means 'nouns that are often used to describe the adjective input'.
--   -- Datamuse uses the label 'a' to denote 'follower' of word in the context of Google n-grams
--   -- and likewise the label 'b' to denote 'predecessor' of word in the context of Google n-grams
--   -- See the datamuse api docs here for more information: https://www.datamuse.com/api/
--   local function process_response(data)
--     local items = {}
--     local first_entry_bg = 0
--     local first_entry_jj = 0
--     for m in pairs(data) do
--       if data[m].word_type == "jj" .. side then
--         if first_entry_jj == 0 then
--           first_entry_jj = data[m].score
--         end
--       elseif data[m].word_type == "bg" .. side then
--         if first_entry_bg == 0 then
--           first_entry_bg = data[m].score
--         end
--       end
--       table.insert(items, {
--         --label = data[m].word_type == "jj" .. side and data[m].word .. " " .. query_word or query_word ..
--         --    " " .. data[m].word,
--         label = data[m].word,
--         detail = "Datamuse score:" ..
--             tostring(math.floor(data[m].score * 100 /
--             (data[m].word_type == "jj" .. side and first_entry_jj or first_entry_bg)))
--           .. ("\nFollowing " .. tostring(data[m].word_type == "jj" .. side and "noun" or "word") ),
--         score = data[m].score,
--         kind = 1
--       })
--     end
--     callback(items)
--   end
--   local function get_cmd(word_type)
--     local cmd = 'curl -s ' .. 'https://api.datamuse.com/words?rel_' ..
--         word_type .. side .. '=' .. query_word .. ' | jq -c \'.[]+{"word_type":"' ..
--         word_type .. side .. '"}\''
--     return cmd
--   end
--   -- The command assumes linux utils (cat, cURL and jq are available)
--   local cmd = "cat <(" .. get_cmd("bg") .. ") <(" .. get_cmd("jj") .. ") | jq -s '[.[]]'"
--   local cmd_result = vim.fn.system(cmd):gsub('\n+$', '')
--   local data = vim.fn.json_decode(cmd_result)
--   process_response(data)
-- end
--
--cmp.register_source('datamuse', source.new())
-- <= cmp for datamuse

-- Also see -> $HOME/.config/nvim/snippets/
local luasnip = require("luasnip");
if not luasnip then return end
local lspconfig = require("lspconfig");
if not lspconfig then return end
local lspkind = require("lspkind");
if not lspkind then return end

local cmp_nvim_lsp = require("cmp_nvim_lsp");
if not cmp_nvim_lsp then return end

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_flags = { debounce_text_changes = 120 }
local border = { "╭", "╍", "╮", "│", "╯", "╍", "╰", "│" }
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local lsp = vim.lsp
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'lss', lsp.stop_client, bufopts)               -- Stop client (especially useful for when unknown errors happen)
  vim.keymap.set('n', 'gd', lsp.buf.definition, bufopts)             -- gjump definition
  vim.keymap.set('n', 'K', lsp.buf.hover, bufopts)                   -- jump to help for that opt the cursor is over
  vim.keymap.set('n', '<leader>d', lsp.buf.type_definition, bufopts) -- jump to definition (<leader>D)
  vim.keymap.set('n', '<leader>nn', lsp.buf.rename, bufopts)         -- newname (<leader>nn)
  vim.keymap.set('n', '<leader>ca', lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', lsp.buf.formatting, bufopts)
end

-- Default language Servers:
local default_language_servers = {
  "bashls",
  "clangd",
  "cmake",
  "grammarly",
  "html",
  "jedi_language_server",
  "jsonls",
  "lua_ls",
  "marksman",
  "pyright",
  "rust_analyzer",
  "vimls",
  "yamlls",
}

local kind_mapper = {2,3,4,5,6,7,1,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24}

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = default_language_servers,
}
for _, value in ipairs(default_language_servers) do
  lspconfig[value].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  }
end
-- Set configuration for specific filetype.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'buffer' }
  }, {
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

cmp.setup.cmdline('./', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local lsp_symbols = {
  Text = "   Text",
  Method = "   Method",
  Function = "   Function",
  Constructor = "   Constructor",
  Field = " ﴲ  Field",
  Variable = "[] Variable",
  Class = "   Class",
  Interface = " ﰮ  Interface",
  Module = "   Module",
  Property = " 襁 Property",
  Unit = "   Unit",
  Value = "   Value",
  Enum = " 練 Enum",
  Keyword = "   Keyword",
  Snippet = "   Snippet",
  Color = "   Color",
  File = "   File",
  Reference = "   Reference",
  Folder = "   Folder",
  EnumMember = "   EnumMember",
  Constant = " ﲀ  Constant",
  Struct = " ﳤ  Struct",
  Event = "   Event",
  Operator = "   Operator",
  TypeParameter = "   TypeParameter",
}

-- Window options
local doc_window_conf = cmp.config.window.bordered({
border = border,
winhighlight = "Normal:MyPmenu,FloatBorder:MyPmenu,CursorLine:MyPmenuSel,Search:None",
side_padding = 0,
col_offset = 1,
})
local completion_window_conf = cmp.config.window.bordered({
  border = "none",
  winhighlight = "Normal:MyPmenu,FloatBorder:MyPmenu,CursorLine:MyPmenuSel,Search:None",
  side_padding = 0,
  col_offset = -1,
})
local window = {
  documentation = doc_window_conf,
  completion = completion_window_conf,
}

vim.api.nvim_set_hl(0, "MyPmenu", { bg = "#1d2021", fg = "#928374" })
vim.api.nvim_set_hl(0, "MyNormal", { fg = "#98971a" })
vim.api.nvim_set_hl(0, "MyFloatBorder", { fg = "#1d2021" })
vim.api.nvim_set_hl(0, "MyPmenuSel", { bg = "#fbf1c7", fg = "#282828", bold = true, italic = true })
vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#d5c4a1" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#fbf1c7" })
vim.api.nvim_set_hl(0, "CmpItemAbbrFuzzy", { fg = "#ec5300" })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#8ec07c" })

cmp.setup.filetype({ 'text', 'markdown' }, {
    sources = {
      { name = "datamuse", max_item_count = 50,  keyword_length = 5, group_index = 3 },
      { name = "spell",    max_item_count = 8,  keyword_length = 4, group_index = 2 },
      --{ name = "path",     max_item_count = 8,  group_index = 2 },
      --{ name = "buffer",   max_item_count = 8,  keyword_length = 3, group_index = 2 },
    },
    sorting = {
      comparators = {
        -- sort_by_score, -- datamuse custom score sorter
        cmp.config.recently_used,
      }
    }
})
-- Enable generic language servers with the additional completion capabilities offered by nvim-cmp
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  window = window,
  experimental = { ghost_text = false, native_menu = false },
  mapping = cmp.mapping.preset.insert(
    {
      -- tab is not enabled here
      ["<CR>"] = cmp.mapping.confirm({
        -- this is the important line
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.close(),
      ["<C-y>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true
      },
      ["<C-Space>"] = cmp.mapping.complete(),
    }
  ),
  sources = {
    -- { name = "copilot",  group_index = 1,     keyword_length = 2 },
    { name = "nvim_lua", group_index = 2,     keyword_length = 2 },
    { name = "luasnip",  group_index = 2,     keyword_length = 2 },
    { name = "nvim_lsp", max_item_count = 10, group_index = 2 },
    { name = "path",     max_item_count = 8,  group_index = 2 },
    { name = "buffer",   max_item_count = 8,  keyword_length = 3, group_index = 2 },
    { name = "spell",    max_item_count = 8,  keyword_length = 4, group_index = 2 },
  },
  formatting = {
    fields = {
      cmp.ItemField.Menu,
      cmp.ItemField.Abbr,
      cmp.ItemField.Kind,
    },
    format = function(entry, vim_item)
      vim_item.kind = string.format(
        "%s %s",
        (lsp_symbols[vim_item.kind] or "?"),
        (lspkind.presets.default[vim_item.kind] or "?")
      )
      vim_item.menu = ({
        nvim_lua = "", -- lua engine
        luasnip = "", -- snippets engine
        nvim_lsp = "", -- local context
        treesitter = "",
        path = "ﱮ",
        buffer = "﬘",
        spell = "暈",
        datamuse = "❂",
      })[entry.source.name]
      vim_item.abbr = vim_item.abbr:match("[^(]+")
      return vim_item
    end,
  },
  sorting = {
    comparators = {
      cmp.config.exact,
      cmp.config.recently_used,
      cmp.config.locality,
      function(entry1, entry2)
        local kind1 = kind_mapper[entry1:get_kind()]
        local kind2 = kind_mapper[entry2:get_kind()]
        if kind1 < kind2 then
          return true
        end
      end,
    }
  }
}
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
