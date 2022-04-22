vim.lsp.set_log_level("debug")

USER = vim.fn.expand('$USER')
local sumneko_root_path = ""
local sumneko_binary_path = ""

if vim.fn.has('mac')  == 1 then
  sumneko_root_path = ""
  sumneko_binary_path = ""
elseif vim.fn.has('unix') == 1 then
  sumneko_root_path = "/home/" .. USER .. "/.config/nvim/language-servers/lua-language-server/"
  sumneko_binary_path = "/home/" .. USER .. "/.config/nvim/language-servers/lua-language-server/bin/lua-language-server"
else
  print("Unsupported system for sumneko")
end
 
require('lspconfig').sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "main.lua"},
  settings = {
  lua = {
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
	-- do not send telemetry data containing a randomized but unique identifier
	telemetry = {
	enable = false,
	  },
	},
  }
}
