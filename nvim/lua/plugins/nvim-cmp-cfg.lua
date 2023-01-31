USER = vim.fn.expand('$USER')

local system_name = "UNKNOWN"

if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
elseif vim.fn.has("win32") == 1 then
    system_name = "Windows"
else
    print("Unsupported system for sumenko")
end

local sumenko_root_path = "/home/" .. USER .. "/.config/nvim/lua-language-server/main.lua"
local sumenko_binary = "/home/" .. USER .. "/.config/nvim/lua-language-server/bin/lua-language-server"

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

-- So as not to load absolutely everything.
vim.lsp.set_log_level("info")

local capabilities = cmp_nvim_lsp.default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local lsp_flags = {
  debounce_text_changes = 150,  -- This is the default in Nvim 0.7+
}
local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local lsp = vim.lsp
  -- Mappings. (See `:help vim.lsp.*` for documentation on any of the below functions)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'lss', lsp.stop_client, bufopts)      -- Stop client (especially useful for when unknown errors happen)
  vim.keymap.set('n', 'gD', lsp.buf.declaration, bufopts)   -- gjump declaration
  vim.keymap.set('n', 'gd', lsp.buf.definition, bufopts)    -- gjump definition
  vim.keymap.set('n', 'K', lsp.buf.hover, bufopts)          -- jump to help for that opt the cursor is over
  vim.keymap.set('n', '<leader>D', lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>nn', lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', lsp.buf.formatting, bufopts)
end

if system_name ~= "" then
    lspconfig.sumneko_lua.setup {
        cmd = {sumenko_binary, "-E", sumenko_root_path},
        window = {
          border = border,
        },
        settings = {
            Lua = {
                runtime = {
                    -- tell the language server which version of lua you're using (most likely luajit in the case of neovim)
                    version = "luaJIT",
                    -- setup your lua path
                    path = vim.split(package.path, ';'),
                },
                diagnostics = {
                    -- get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
                workspace = {
                    -- make the server aware of neovim runtime files
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                },
            }
        },
        capabilities = capabilities,
        on_attach = on_attach,
    }
    lspconfig.pyright.setup{
        on_attach = on_attach,
        flags = lsp_flags,
    }
else
    print("System failiure ( may be due to " .. system_name .. " incompatibility) .")
end

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

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
lspconfig.pyright.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}

lspconfig.vimls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    window = { border = border },
    experimental = { ghost_text = true, native_menu = false },
    mapping = cmp.mapping.preset.insert(
        {
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true
            },
            ['<C-e>'] = cmp.mapping.abort(),  -- Also <C-y> (default)
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


-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- local keymap = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
