vim.lsp.set_log_level("debug")

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
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

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
    }
    -- the current version of grammarly is broken when it comes to vim lsp
    -- see the workaround in ./install_vimrc.sh
    require('lspconfig').grammarly.setup{
        cmd = { grammarly_binary, "--stdio" },
        filetypes = { "markdown", "text" },
    }
--        on_attach=on_attach,
else
    print("System name is " .. system_name .. " failiure.")
end

-- root_dir = util.find_git_ancestor,
-- single_file_support= true,
