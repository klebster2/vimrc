-- Setup nvim-cmp.
local cmp = require("cmp")
if not cmp then return end

local luasnip = require("luasnip")
if not luasnip then return end

local lspconfig = require("lspconfig")
if not lspconfig then return end

local lspkind = require("lspkind")
if not lspkind then return end

local cmp_nvim_lsp = require("cmp_nvim_lsp")
if not cmp_nvim_lsp then return end

local lsp_symbols = {
    Text = "   Text ",
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {"rust_analyzer", "pyright", "tsserver", "vimls"}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities = capabilities
    }
end

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    window = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    experimental = {
      ghost_text = true,
      native_menu = false,
    },
    mapping = cmp.mapping.preset.insert(
        {
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true
            },
            ['<C-e>'] = cmp.mapping.abort(),  -- Also using <C-y>
            ['<Space>'] = cmp.mapping.abort(),
            ["<Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end,
                {"i", "s"}
            ),
            ["<S-Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end,
                {"i", "s"}
            )
        }
    ),
    sources = {
      { name = "luasnip" },
      { name = "nvim_lsp", max_item_count = 6 },
      { name = "vsnip" },  -- See https://github.com/L3MON4D3/LuaSnip
      { name = "calc" },
      { name = "path" },
      { name = "spell" },  -- See https://github.com/f3fora/cmp-spell
      { name = "buffer", max_item_count = 6 },
    },
    formatting = {
      fields = {
        cmp.ItemField.Abbr,
        cmp.ItemField.Kind,
        cmp.ItemField.Menu,
      },
      format = function(entry, item)
          item.kind = string.format(
            "%s %s",
            lspkind.presets.default[item.kind],
            lsp_symbols[item.kind]
          )
          item.menu = ({
            nvim_lsp = "ﲳ",
            nvim_lua = "",
            luasnip = "",
            treesitter = "",
            path = "ﱮ",
            buffer = "﬘",
            bash = "",
            spell = "暈",
          })[entry.source.name]
          return item
      end,
    },
}

-- Set configuration for specific filetype.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
  })
})
