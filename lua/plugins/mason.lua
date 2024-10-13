return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup()
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
		require("mason-lspconfig").setup({
			ensure_installed = default_language_servers,
			force_install = true,
		})
		require("mason-tool-installer").setup({
			ensure_installed = {
				"black",
				"eslint_d",
				"isort",
				"jq",
				"prettier",
				"pylint",
				"stylua",
			},
		})
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		if not cmp_nvim_lsp then
			return
		end
		local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

		if not lspconfig then
			return
		end
		for _, value in ipairs(default_language_servers) do
			lspconfig[value].setup({
				on_attach = function(_, bufnr)
					--- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
					local lsp = vim.lsp
					local bufopts = { noremap = true, silent = true, buffer = bufnr }
					vim.keymap.set("n", "lss", lsp.stop_client, bufopts) -- Stop client (especially useful for when unknown errors happen)
					vim.keymap.set("n", "gd", lsp.buf.definition, bufopts) -- gjump definition
					vim.keymap.set("n", "K", lsp.buf.hover, bufopts) -- jump to help for that opt the cursor is over
					vim.keymap.set("n", "<leader>d", lsp.buf.type_definition, bufopts) -- jump to definition (<leader>D)
					vim.keymap.set("n", "<leader>nn", lsp.buf.rename, bufopts) -- newname (<leader>nn)
					vim.keymap.set("n", "<leader>ca", lsp.buf.code_action, bufopts)
					vim.keymap.set("n", "gr", lsp.buf.references, bufopts)
				end,
				flags = { debounce_text_changes = 400 },
				capabilities = capabilities,
			})
		end
		lspconfig["lua_ls"].setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" }, -- disable vim global warnings
					},
				},
			},
			capabilities = capabilities,
		})
	end,
}
