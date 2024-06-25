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

lspkind.init({
  symbol_map = {
    Copilot = "",
    thesaurus = "",
  },
})

require("plugins.nvim-cmp.thesaurus") ---- TODO - make this a plugin <<< $HOME/.config/nvim/lua/plugins/nvim-cmp/thesaurus.lua

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
    flags = { debounce_text_changes = 120 },
    capabilities = capabilities,
  }
end

--- Works with 'DroidSansMono Nerd Font Mono'
local lsp_symbols = {
  Text = "   TEXT",
  Method = "   METH",
  Function = "   FUNC",
  Constructor = "   CONSTR",
  Field = " ﴲ  FIELD",
  Variable = "[] VAR",
  Class = "   CLASS",
  Interface = " ﰮ  INTERF",
  Module = "   MOD",
  Property = " 襁 PROP",
  Unit = "   UNIT",
  Value = "   VALUE",
  Enum = " 練 ENUM",
  Keyword = "   KEYW",
  Snippet = "   SNIP",
  Color = "   COLOR",
  File = "   FILE",
  Reference = "   REF",
  Folder = "   FOLDER",
  EnumMember = "   ENUMMEM",
  Constant = " ﲀ  CONST",
  Struct = " ﳤ  STRUCT",
  Event = "   EVENT",
  Operator = "   OPER",
  TypeParameter = "   TYPE",
  Copilot = "   COPILOT",
  Thesaurus = "   THESAU",
}

--- Window options
local window = {
  documentation = cmp.config.window.bordered({
    border = { "╭", "╍", "╮", "│", "╯", "╍", "╰", "│" },
    winhighlight = "Normal:MyPmenu,FloatBorder:MyPmenu,CursorLine:MyPmenuSel,Search:None",
    side_padding = 0,
    col_offset = 1,
  }),
  completion = cmp.config.window.bordered({
    border = 'none',
    winhighlight = "Normal:MyPmenu,FloatBorder:MyPmenu,CursorLine:MyPmenuSel,Search:None",
    side_padding = 0,
    col_offset = -1,
  }),
}

local kind_mapper = cmp.lsp.CompletionItemKind
kind_mapper.Copilot = 25
kind_mapper.Thesaurus = 26

cmp.setup.filetype('text', {
    sources = cmp.config.sources({
        { name = 'thesaurus', keyword_length = 3, priority = 10 },
        { name = "spell", max_item_count = 5, priority = 5, keyword_length = 6 },
      }),
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
          (lspkind.presets.default[vim_item.kind] or "")
        )
        vim_item.menu = ({
          spell = "暈",
          thesaurus = "",
        })[entry.source.name]
        return vim_item
    end,
    },
})

--- Set configuration for specific filetype.
cmp.setup.cmdline({'/', '?'}, {
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
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),     --- Mnemonic - back
      ["<C-f>"] = cmp.mapping.scroll_docs(4),      --- Mnemonic - forward
      ["<C-e>"] = cmp.mapping.abort(),             --- Mnemonic - escape
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
      ["<C-y>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true
      },
      ["<C-Space>"] = cmp.mapping.complete({select=true}),
    }
  ),
  sources = {
    { name = "copilot", max_item_count = 10, priority = 10 },
    { name = "nvim_lua", max_item_count = 10, priority = 10 },
    { name = "luasnip", max_item_count = 10, priority = 10 },
    { name = "treesitter", max_item_count = 10, priority = 10 },
    { name = "nvim_lsp", max_item_count = 10, priority = 10 },
    { name = "path", max_item_count = 3, priority = 8 },
    { name = "buffer", max_item_count = 5, priority = 7, keyword_length = 4 },
    { name = "look", max_item_count = 5, priority = 7, keyword_length = 4 },
    { name = "cmdline", max_item_count = 3, priority = 6, keyword_length = 4 },
    {
        name = "spell",   --- check $HOME/.config/nvim/lua/options.lua
        option = {
            keep_all_entries = false,
            enable_in_context = function()
                return true
            end,
            preselect_correct_word = true,
        },
        max_item_count = 3, priority = 5, keyword_length = 6
    },
    { name = "thesaurus", max_item_count = 20, priority = 3, keyword_length = 4 },
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
        (lspkind.presets.default[vim_item.kind] or "")
      )
      vim_item.menu = ({
        Copilot = "", -- Copilot
        nvim_lua = "", -- lua engine
        luasnip = "", -- snippets engine
        nvim_lsp = "", -- local context
        treesitter = "", -- treesitter ( $HOME/.config/nvim/lua/plugins/treesitter.lua )
        path = "ﱮ",
        buffer = "﬘",
        --spell = "暈",
        thesaurus = "",  -- Custom thesaurus
      })[entry.source.name]
      return vim_item
  end,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.exact,
      cmp.config.score,
      cmp.config.recently_used,
      cmp.config.locality,
      function(entry1, entry2)
        local kind1 = kind_mapper[entry1:get_kind()]
        local kind2 = kind_mapper[entry2:get_kind()]
        if kind1 < kind2 then
          return true
        end
      end,
      cmp.config.compare.recently_used,
    }
  }
}


lspconfig['lua_ls'].setup{
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }   -- disable vim global warnings
            }
        }
    },
    capabilities = capabilities
}
