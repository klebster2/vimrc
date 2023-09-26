local vim = vim
--- Setup nvim-cmp.
vim.cmd [[ packadd nvim-cmp ]]
vim.cmd [[ packadd cmp-nvim-lsp ]]
vim.cmd [[ packadd cmp-buffer ]]
vim.cmd [[ packadd cmp-look ]]

--- Setup nvim-cmp.
local cmp = require("cmp");
if not cmp then return end

--- -> cmp for datamuse (This is also an example of how to implement api calling with cmp)
--- require('plugins/nvim-cmp/datamuse') -- $HOME/.vim_runtime/nvim/lua/plugins/nvim-cmp/datamuse.lua

--- datamuse specific sorting function
local function sort_by_score(entry1, entry2)
  local score1 = entry1.completion_item.score or 0
  local score2 = entry2.completion_item.score or 0
  return score1 > score2
end
--- <- cmp for datamuse

--- -> cmp for local code generation using huggingface transformers
local source = {}
source.new = function()
  return setmetatable({}, { __index = source })
end
source.get_trigger_characters = function()
  return { '=', '(', '[', '{' }
end

--- datamuse specific sorting function
--source.complete = function(self, request, callback)
---  local prediction_length = 100  -- 100 tokens to predict
---  --local line = vim.api.nvim_get_current_line()
---  local current_line_num = vim.api.nvim_win_get_cursor(0)[1]
---  local start_line = math.max(current_line_num - 3, 0) -- Ensure it doesn't go below 0
---  local relevant_lines = vim.api.nvim_buf_get_lines(0, start_line, current_line_num, false)
---  local lines_text = table.concat(relevant_lines, "\\n")
--
---  local function process_response(data)
---    local items = {}
---    table.insert(items, {
---      label = data.generated_text,
---      detail = "transformer model:" .. "Salesforce/codet5p-770m-py",
---      kind = 1
---    })
---    callback(items)
---  end
---  local function get_cmd(line)
---    -- Note that we are calling a local endpoint here setup via langtransformer_fastapi
---    -- Using the huggingface transformers library
--
---    -- return coroutine.create(function()
---    -- async_function(function(result)
---    --   if vim.api.nvim_get_var('request_id') == request_id then
---    --     -- Process the result and use it in cmp
---    --     -- E.g., cmp.complete({ items = { ... } })
---    --   end
---    -- end)
---    local cmd = 'curl -s ' .. '"http://localhost:8080/code_prediction/"' ..
---      ' -H "Content-Type: application/json"' ..
---      ' --data \'{' ..
---          '"text": ' .. '"' .. line:gsub('"', '\\"'):gsub("'","\\'"):gsub("\n", "\\n"):gsub("$", "\\\\$") .. '"' .. "," ..
---          '"model": ' .. '"Salesforce/codet5p-770m-py"' .. "," ..
---          '"prediction_length": ' .. prediction_length ..
---        '}\''
---    print(cmd)
---    return cmd
---  end
---  local function process_cmd(cmd)
---    return coroutine.create(
---      function()
---        local cmd_result = vim.fn.system(cmd)
---        local data = vim.fn.json_decode(cmd_result)
---        process_response(data)
---      end)
---  end
--
---  -- The command assumes linux util (cURL is available)
---  coroutine.resume(process_cmd(get_cmd(lines_text)))
--end
--cmp.register_source('Salesforce__codet5p_770m_py', source.new())
--- <- cmp for local code generation using hugginface transformers

--- Also see -> $HOME/.config/nvim/snippets/
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
--- Use an on_attach function to only map the following keys
--- after the language server attaches to the current buffer
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
  --vim.keymap.set('n', '<leader>f', lsp.buf.formatting, bufopts)
end

--- Default language Servers:
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
--- Set configuration for specific filetype.
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

--- Window options
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

require('cmp').setup({
})

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
--- Enable generic language servers with the additional completion capabilities offered by nvim-cmp
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
    -- { name = "Salesforce__codet5p_770m_py",   group_index = 1, keyword_length = 1},
    { name = "copilot",  group_index = 1,     keyword_length = 2 },
    { name = "nvim_lua", group_index = 2,     keyword_length = 2 },
    { name = "luasnip",  group_index = 2,     keyword_length = 2 },
    { name = "nvim_lsp", max_item_count = 10, group_index = 2 },
    { name = "path",     max_item_count = 8,  group_index = 2 },
    { name = "buffer",   max_item_count = 8,  keyword_length = 3, group_index = 2 },
    { name = "spell",    max_item_count = 8,  keyword_length = 4, group_index = 2 },
    --{ name = 'look',     keyword_length = 2,  option = { convert_case = true, loud = true, dict = '/usr/share/dict/words' }}
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
        Salesforce__codet5p_770m_py = "SF_CodeT5+", -- transformers
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
  --sorting = {
  --  comparators = {
  --    cmp.config.exact,
  --    cmp.config.recently_used,
  --    cmp.config.locality,
  --    function(entry1, entry2)
  --      local kind1 = kind_mapper[entry1:get_kind()]
  --      local kind2 = kind_mapper[entry2:get_kind()]
  --      if kind1 < kind2 then
  --        return true
  --      end
  --    end,
  --  }
  --}
}
--- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
