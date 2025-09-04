return {
	"neovim/nvim-lspconfig",
	config = function()
		require("neoconf").setup({})
		local lspconfig = require("lspconfig")

		-- Ruff LSP
		lspconfig.ruff.setup {
			on_attach = function(client, bufnr)
				-- Ruff only provides diagnostics + code actions,
				-- disable hover so it doesn't conflict with other servers
				client.server_capabilities.hoverProvider = false

				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			end,
		}

		-- Optionally also run Pyright (for type checking + hover docs)
		lspconfig.pyright.setup {
			on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			end,
		}
	end,
		-- in your Lazy spec (e.g. lua/plugins/lsp.lua)
	event = { "BufReadPre", "BufNewFile" }, -- load LSP when opening files
	--#event = "VeryLazy",
	lazy = true,
	dependencies = {
		"folke/neoconf.nvim",
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {
					"angularls",
					"bashls",
					"cssls",
					"cssmodules_ls",
					"diagnosticls",
					"docker_compose_language_service",
					"dockerls",
					"emmet_ls",
					"eslint",
					"golangci_lint_ls",
					"gopls",
					"html",
					"jsonls",
					"lua_ls",
					"marksman",
					"powershell_es",
					"sqlls",
					"tailwindcss",
					"yamlls",
				},
				automatic_installation = true,
				automatic_enable = false,
			},
			dependencies = {
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
				cmd = "Mason",
				lazy = true,
			},
		},
		{
			"jubnzv/virtual-types.nvim",
			event = "LspAttach",
		},
		{
			"dmmulroy/ts-error-translator.nvim",
			config = true,
			event = "LspAttach",
			ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
			lazy = true,
		},
		{
			"chrisgrieser/nvim-lsp-endhints",
			event = "LspAttach",
			opts = {
				icons = {
					type = "󰋙 ",
					parameter = " ",
				},
				label = {
					padding = 1,
					marginLeft = 0,
					bracketedParameters = false,
				},
				autoEnableHints = false,
			},
			lazy = true,
		},
	},
}
