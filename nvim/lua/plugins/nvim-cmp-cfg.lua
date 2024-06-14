--- Setup nvim-cmp.
local cmp = require("cmp");
if not cmp then return end

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
  --- Enable completion triggered by <c-x><c-o>
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
end

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

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = default_language_servers,
  force_install = true
}


for _, value in ipairs(default_language_servers) do
  lspconfig[value].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  }
end

--- Works with 'DroidSansMono Nerd Font Mono'
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

local kind_mapper = {
  Text = 1,
  Method = 2,
  Function = 3,
  Constructor = 4,
  Field = 5,
  Variable = 6,
  Class = 7,
  Interface = 8,
  Module = 9,
  Property = 10,
  Unit = 11,
  Value = 12,
  Enum = 13,
  Keyword = 14,
  Snippet = 15,
  Color = 16,
  File = 17,
  Reference = 18,
  Folder = 19,
  EnumMember = 20,
  Constant = 21,
  Struct = 22,
  Event = 23,
  Operator = 24,
  TypeParameter = 25,
}

--- Set configuration for specific filetype.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {
      { name = 'buffer' }
    }, {
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }, {
      { name = 'spell' }
    }, {
      { name = 'look' }
    }
  )
})

cmp.setup.cmdline('./', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }
  )
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }, {
      { name = 'spell' }
    }, {
      { name = 'look' }
    }
  )
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
    --- { name = "copilot",  group_index = 1,     keyword_length = 2 },
    { name = "nvim_lua", group_index = 2,     keyword_length = 2 },
    { name = "luasnip",  group_index = 2,     keyword_length = 2 },
    { name = "nvim_lsp", max_item_count = 10, group_index = 2 },
    { name = "path",     max_item_count = 8,  group_index = 2 },
    { name = "buffer",   max_item_count = 8,  keyword_length = 3, group_index = 2 },
    --{ name = "spell",    max_item_count = 8, keyword_length = 4, group_index = 2 },
    { name = 'look',     max_item_count = 8, keyword_length = 4,  option = { convert_case = true, loud = true, dict = '/usr/share/dict/words' }}
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
        (lsp_symbols[vim_item.kind] or "!"),
        (lspkind.presets.default[vim_item.kind] or "!")
      )
      vim_item.menu = ({
        nvim_lua = "", -- lua engine
        luasnip = "", -- snippets engine
        nvim_lsp = "", -- local context
        treesitter = "", -- treesitter ( $HOME/.vim_runtime/nvim/lua/plugins/treesitter.lua )
        path = "ﱮ",
        buffer = "﬘",
        spell = "暈",
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
