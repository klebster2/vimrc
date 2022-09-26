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
local grammarly_binary = "/home/" .. USER .. "/.local/share/nvim/lsp_servers/grammarly/node_modules/@emacs-grammarly/unofficial-grammarly-language-server/bin/server.js"

-- ~/.local/share/nvim/lsp_servers/

-- See ./nvim/lua/plugins/nvim-compe-cfg.lua
local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  -- Stop client (especially useful for when unknown errors happen)
  vim.keymap.set('n', 'lss', vim.lsp.stop_client, bufopts)
  -- gjump declaration
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  -- gjump definition
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  -- jump to help for that opt the cursor is over
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>nn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

if system_name ~= "" then
    require('lspconfig').sumneko_lua.setup {
        cmd = {sumenko_binary, "-E", sumenko_root_path},
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
    -- the current version of grammarly is broken when it comes to vim lsp
    -- see the workaround in ./install_vimrc.sh
    require('lspconfig').grammarly.setup{
        cmd = { grammarly_binary, "--stdio" },
        filetypes = { "markdown", "text" },
        capabilities = capabilities,
    }
    require('lspconfig').pyright.setup{
        on_attach = on_attach,
        flags = lsp_flags,
    }
else
    print("System name is " .. system_name .. " failiure.")
end

-- root_dir = util.find_git_ancestor,
-- single_file_support= true,
